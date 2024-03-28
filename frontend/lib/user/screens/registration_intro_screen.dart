import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/animations/confetti_overlay.dart';
import 'package:frontend/animations/fade_slide_animation.dart';
import 'package:frontend/animations/fade_transition_page_route.dart';
import 'package:frontend/animations/slide_transition_page_route.dart';
import 'package:frontend/home/screens/home_screen.dart';
import 'package:frontend/user/screens/login_screen.dart';
import 'package:frontend/user/screens/more_info_screen.dart';
import 'package:frontend/user/screens/second_screen.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';

class RegistrationIntroScreen extends StatefulWidget {
  const RegistrationIntroScreen({super.key});

  @override
  State<RegistrationIntroScreen> createState() => _RegistrationIntroScreenState();
}

class _RegistrationIntroScreenState extends State<RegistrationIntroScreen> {
  late final confetti;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      confetti = ConfettiOverlay(context: context);
      confetti.show();

      // 컨페티 효과가 끝난 후 자동으로 리소스 정리를 원한다면,
      // 다음과 같이 Future.delayed를 사용하여 dispose() 호출을 예약할 수 있습니다.
      // Future.delayed(Duration(seconds: 5), () {
      //   confetti.dispose();
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          FadeSlideAnimation(
            durationMilliseconds: 1000, // 원하는 지속 시간(밀리초 단위)
            beginOffset: const Offset(0.0, 0.5), // 시작 오프셋 설정
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: ScreenUtil.h(18),
                  child: Image.asset("assets/images/intro_party_popper.png"),
                ),
                SizedBox(height: ScreenUtil.h(2.5),),
                Text(
                  "반갑습니다!",
                  textAlign: TextAlign.center,
                  style: AppFonts.scDream(fontSize: 28, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: ScreenUtil.h(1.5),),
                Text(
                  "추가적인 회원 정보가 필요해요",
                  style: AppFonts.suit(fontSize: 14,fontWeight: FontWeight.w600, color: AppColors.lightGrey),
                )
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 45,
                width: ScreenUtil.w(85),
                child: ElevatedButton(
                  onPressed: (){
                    confetti.dispose();
                    Navigator.of(context).pushReplacement(
                        SlideTransitionPageRoute(
                            page: const MoreInfoScreen(),
                            beginOffset: const Offset(1, 0),
                            transitionDuration: const Duration(milliseconds: 350),
                            reverseTransitionDuration: const Duration(milliseconds: 350)
                        )
                    );
                  },
                  child: const Text('계속하기'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
