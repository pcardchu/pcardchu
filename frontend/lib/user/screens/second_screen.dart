import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/animations/fade_slide_animation.dart';
import 'package:frontend/animations/fade_transition_page_route.dart';
import 'package:frontend/animations/slide_transition_page_route.dart';
import 'package:frontend/user/screens/login_screen.dart';
import 'package:frontend/user/screens/third_screen.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          FadeSlideAnimation(
            durationMilliseconds: 1000, // 원하는 지속 시간(밀리초 단위)
            beginOffset: Offset(0.0, 0.5), // 시작 오프셋 설정
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: ScreenUtil.h(18),
                  child: Image.asset("assets/images/intro_chart.png"),
                ),
                SizedBox(height: ScreenUtil.h(2.5),),
                Text(
                  "나는 어떤 소비를\n하는 사람일까?",
                  textAlign: TextAlign.center,
                  style: AppFonts.scDream(fontSize: 28, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: ScreenUtil.h(1.5),),
                Text(
                  "개인 소비패턴 분석",
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
                    Navigator.of(context).push(
                        SlideTransitionPageRoute(
                        page: const ThirdScreen(),
                        beginOffset: const Offset(1, 0),
                        transitionDuration: const Duration(milliseconds: 350),
                        reverseTransitionDuration: const Duration(milliseconds: 350)
                    )
                    );
                  },
                  child: Text('다음'),
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
