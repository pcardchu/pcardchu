
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/animations/fade_transition_page_route.dart';
import 'package:frontend/home/screens/bottom_nav_screen.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:frontend/providers/password_provider.dart';
import 'package:frontend/user/models/jwt_token.dart';
import 'package:frontend/user/models/second_jwt_response.dart';
import 'package:frontend/user/widgets/biometric_button.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:provider/provider.dart';
class CustomNumberPad extends StatefulWidget {
  @override
  _CustomNumberPadState createState() => _CustomNumberPadState();
}

class _CustomNumberPadState extends State<CustomNumberPad> {
  @override
  void initState() {
    super.initState();

    final passwordProvider = Provider.of<PasswordProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      passwordProvider.shuffleNums();
    });
  }

  @override
  Widget build(BuildContext context) {
    final passwordProvider = Provider.of<PasswordProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    final randomNums = passwordProvider.nums;

    return Container(
      // height: ScreenUtil.w(100),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        childAspectRatio: 1.7,
        padding: const EdgeInsets.all(8),
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        children: List.generate(12, (index) {
          // 숫자 키패드에서 10번째 위치는 비어있음, 11번째는 0, 12번째는 삭제 버튼
          if (index == 9) {
            // 삭제 버튼
            return BiometricButton();
          }
          if (index == 11) {
            // 삭제 버튼
            return IconButton(
              icon: const Icon(Icons.backspace),
              onPressed: () => passwordProvider.deleteLast(), // -1을 전달하여 삭제를 알림
              style: TextButton.styleFrom(
                  foregroundColor: AppColors.mainBlue,
                  textStyle: AppFonts.suit(fontSize: 20, fontWeight: FontWeight.w600),
                  backgroundColor: Colors.transparent
              ),
            );
          }

          // 0을 포함하여 숫자 버튼 (0은 11번째 위치에 있으므로, 인덱스 조정 필요)
          final number = index < 9 ? index + 1 : 0;

          return TextButton(
            child: Text("${randomNums[number]}"),
            onPressed: () async {
              String digest = passwordProvider.addNumber(randomNums[number], loginProvider.userId);
              if(digest.isNotEmpty){
                SecondJwtResponse? result = await loginProvider.checkPassword(digest);

                if(result != null) {
                  if(result.code == 200) {
                    //비밀번호 맞음
                    loginProvider.secondJwt = JwtToken(
                      accessToken: result.accessToken,
                      refreshToken: result.refreshToken,
                      isFirst: false,
                    );

                    if(!passwordProvider.isBiometricEnabled && passwordProvider.isBiometricEnableChecked) {
                      //생체인증을 사용하지 않다가 사용하기에 체크하면
                      if(await loginProvider.updateBiometricToServer(true)) {
                        passwordProvider.updateBiometricEnabled(true);
                      }
                    } else if(passwordProvider.isBiometricEnabled && !passwordProvider.isBiometricEnableChecked) {
                      //생체인증을 사용하다가 사용하기 체크를 해제하면
                      if(await loginProvider.updateBiometricToServer(false)) {
                        passwordProvider.updateBiometricEnabled(false);
                      }
                    }
                    passwordProvider.isAuthenticated = true;

                  } else if(result.code == 400) {
                    //비밀번호 틀림
                    passwordProvider.wrongCount = result.count!;
                  } else {
                    print('뭔가 잘못됨 : ${result.code}');
                    loginProvider.logout(context);
                    // const SnackBar(content: Text("잠시 후 다시 시도해 주세요", textAlign: TextAlign.center,));
                  }

                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.mainBlue,
              textStyle: AppFonts.suit(fontSize: 20, fontWeight: FontWeight.w600),
              backgroundColor: Colors.transparent
            ),
          );
        }),
      ),
    );
  }
}