import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/animations/fade_transition_page_route.dart';
import 'package:frontend/home/screens/bottom_nav_screen.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:frontend/providers/password_provider.dart';
import 'package:frontend/providers/user_info_provider.dart';

import 'package:frontend/user/widgets/biometric_switch.dart';
import 'package:frontend/user/widgets/custom_number_pad.dart';
import 'package:frontend/user/widgets/forgot_password_button.dart';
import 'package:frontend/user/widgets/input_indicator.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:provider/provider.dart';

class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  /// 생체인증을 시도하기 전에 사용자의 설정을 확인하기 위한 메서드
  void _checkAndAuthenticate() async {
    final passwordProvider = Provider.of<PasswordProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    if (passwordProvider.isBiometricSupported && passwordProvider.isBiometricEnabled) {
      if (await passwordProvider.authenticateWithBiometrics()) {
        if(await loginProvider.loginWithBiometric()){
          passwordProvider.isAuthenticated = true;

        } else {
          loginProvider.logout(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("다시 로그인해 주세요")));
        }
      }
    }
    // 생체인증을 지원하지 않거나, 사용자가 생체인증 로그인을 활성화하지 않은 경우, 비밀번호 입력 화면 유지
  }

  @override
  void initState() {
    super.initState();

    final passwordProvider = Provider.of<PasswordProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await passwordProvider.loadBiometricEnabled();
      _checkAndAuthenticate();
      await loginProvider.loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final passwordProvider = Provider.of<PasswordProvider>(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Container(),
          Container(height: ScreenUtil.h(15),),
          Flexible(
            flex: 1,
            child:
            Column(
              // mainAxisAlignment: cen,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset('assets/images/lock.png', height: ScreenUtil.h(13)),
                ),
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "비밀번호를 입력해 주세요",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  // color: Colors.grey,
                  // height: ScreenUtil.h(15),
                  child: InputIndicator(),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BiometricSwitch(),
              ForgotPasswordButton(),
            ],
          ),
          SizedBox(
            width: ScreenUtil.w(80),
            child: const Divider(height: 0,),
          ),
          Flexible(
            flex: 1,
            child: Container(
              // height: ScreenUtil.h(50),
              child: CustomNumberPad(),
            )
          ),
          Consumer<UserInfoProvider>(
              builder: (context, provider, child) {
                if(passwordProvider.isAuthenticated) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    try {
                      provider.getUserInfo();
                    } catch(e) {
                      print('유저 정보 조회 오류 : $e');
                    }

                  });
                }
                return Container();
              }
              ),
          Consumer<PasswordProvider>(
              builder : (context, provider, child) {
                if(provider.isAuthenticated) {
                  Future.microtask(() => provider.isAuthenticated = false);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacement(
                        FadeTransitionPageRoute(
                            page: const BottomNavScreen(),
                            transitionDuration: const Duration(milliseconds: 250),
                            reverseTransitionDuration: const Duration(milliseconds: 250)
                        )
                    );
                  });
                }
                return Container();
              }
          ),
        ],
      ),
    );
  }
}



