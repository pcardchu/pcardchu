import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/animations/fade_slide_animation.dart';
import 'package:frontend/animations/fade_transition_page_route.dart';
import 'package:frontend/animations/shake_animation.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:frontend/providers/user_info_provider.dart';
import 'package:frontend/user/models/login_response.dart';
import 'package:frontend/user/screens/password_screen.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:provider/provider.dart';

class PasswordSubmitScreen extends StatefulWidget {
  const PasswordSubmitScreen({super.key});

  @override
  State<PasswordSubmitScreen> createState() => _PasswordSubmitScreenState();
}

class _PasswordSubmitScreenState extends State<PasswordSubmitScreen> with SingleTickerProviderStateMixin {
  final FocusNode _firstPasswordNode = FocusNode();
  final FocusNode _passwordSubmitNode = FocusNode();
  ShakeAnimation? _shakeAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _firstPasswordNode.requestFocus();
    });
    _shakeAnimation = ShakeAnimation(
      vsync: this,
      begin: 15, // 시작점을 -20으로 설정
      end: -15, // 끝점을 20으로 설정
      durationMilliseconds: 80, // 지속 시간을 300ms로 설정
    );
  }
  @override
  void dispose() {
    super.dispose();
    _shakeAnimation?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider = Provider.of<UserInfoProvider>(context);
    final loginInfoProvider = Provider.of<LoginProvider>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: ScreenUtil.h(10),),
                    Text(
                      "여섯 자리 비밀번호를 입력해 주세요",
                      style: AppFonts.suit(fontWeight: FontWeight.w700, color: AppColors.mainBlue, fontSize: 22),
                    ),
                    SizedBox(
                      width: ScreenUtil.w(85),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16.0),
                          TextField(
                            onChanged: (value) {
                              userInfoProvider.password = value;
                              if(userInfoProvider.password.length == 6) {
                                userInfoProvider.isSix = true;
                              }
                            },
                            obscureText: true,
                            maxLength: 6,
                            onSubmitted: (value) =>
                              FocusScope.of(context).requestFocus(_passwordSubmitNode),
                            focusNode: _firstPasswordNode,
                            decoration:InputDecoration(
                              labelText: '비밀번호',
                              counter: Consumer<UserInfoProvider>( // 예제로 Provider 패턴 사용, 실제 상황에 맞게 조정 필요
                                builder: (context, userInfoProvider, child) {
                                  if(userInfoProvider.password.isNotEmpty && !userInfoProvider.isPasswordCorrect()){
                                    return const Text('숫자만 입력해 주세요', style: TextStyle(color: AppColors.mainRed),);
                                  } else if (userInfoProvider.isSix && userInfoProvider.password.length != 6) {
                                    return const Text('여섯 자리를 모두 입력해 주세요', style: TextStyle(color: AppColors.mainRed),);
                                  } else {
                                    return Text('${userInfoProvider.password.length}/6');
                                  }
                                },
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          Visibility(
                            visible: userInfoProvider.isSix,
                            child: FadeSlideAnimation(
                              child: TextField(
                                onChanged: (value) => userInfoProvider.passwordSubmit = value,
                                obscureText: true,
                                maxLength: 6,
                                focusNode: _passwordSubmitNode,
                                decoration:InputDecoration(
                                  labelText: '비밀번호 확인',
                                  counter: Consumer<UserInfoProvider>( // 예제로 Provider 패턴 사용, 실제 상황에 맞게 조정 필요
                                    builder: (context, userInfoProvider, child) {
                                      if (userInfoProvider.passwordSubmit.length == 6 && userInfoProvider.isPasswordMatch()) {
                                        return const Text('비밀번호가 일치해요', style: TextStyle(color: AppColors.mainGreen),);
                                      } else if(userInfoProvider.passwordSubmit.length == 6 && !userInfoProvider.isPasswordMatch()) {
                                        return const Text('비밀번호가 일치하지 않아요', style: TextStyle(color: AppColors.mainRed),);
                                      } else {
                                        return Text('${userInfoProvider.passwordSubmit.length}/6');
                                      }
                                    },
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Column(
              children: [
                Visibility(
                  visible: userInfoProvider.isAllFieldsFilled,
                  child: FadeSlideAnimation(
                    durationMilliseconds: 400,
                    beginOffset: const Offset(0, 1),
                    child: SizedBox(
                      height: 45,
                      width: ScreenUtil.w(85),
                      child: ElevatedButton(
                        onPressed: () async {
                          var data = userInfoProvider.getRegistrationData();
                          String result = await loginInfoProvider.registration(data);

                          if(result == '성공') {
                            loginInfoProvider.saveFirstJwt();
                            Navigator.of(context).pushReplacement(
                                FadeTransitionPageRoute(
                                    page: PasswordScreen(),
                                    transitionDuration: const Duration(milliseconds: 200),
                                    reverseTransitionDuration: const Duration(milliseconds: 200)
                                )
                            );
                          } else if(result == '토큰만료'){
                            //토큰 만료 재시도 로직
                            const SnackBar(content: Text("잠시 후 다시 시도해 주세요", textAlign: TextAlign.center,));
                          } else {
                            //실패
                            const SnackBar(content: Text("잠시 후 다시 시도해 주세요", textAlign: TextAlign.center,));
                          }
                        },
                        child: const Text('계속하기'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
