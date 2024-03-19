import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/home/screens/home_screen.dart';
import 'package:frontend/providers/password_provider.dart';
import 'package:frontend/user/services/local_auth_service.dart';
import 'package:frontend/user/widgets/custom_number_pad.dart';
import 'package:frontend/user/widgets/input_indicator.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:provider/provider.dart';

class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
// 생체인증을 시도하기 전에 사용자의 설정을 확인하기 위한 메서드
  void _checkAndAuthenticate() async {
    final provider = Provider.of<PasswordProvider>(context, listen: false);
    final authService = LocalAuthService();

    // 사용자가 생체인증 로그인을 활성화했는지 확인
    // if (await authService.isBiometricSupported() && await authService.isBiometricEnabled()) {
    if (await authService.isBiometricSupported()) {
      // 생체인증을 시도하고 결과에 따라 처리
      final authenticated = await authService.authenticateWithBiometrics('로그인을 위해 생체인증을 진행해 주세요.');
      if (authenticated) {
        // 생체인증에 성공한 경우, 다음 화면으로 이동
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        // 생체인증에 실패한 경우, 사용자에게 메시지를 표시할 수 있습니다.
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("생체인증에 실패하였습니다.")));
      }
    }
    // 생체인증을 지원하지 않거나, 사용자가 생체인증 로그인을 활성화하지 않은 경우, 비밀번호 입력 화면 유지
  }
  @override
  void initState() {
    super.initState();
    _checkAndAuthenticate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(height: ScreenUtil.h(17),),
          Flexible(
            flex: 1,
            child:
            Column(
              // mainAxisAlignment: cen,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset('assets/images/lock.png', width: 100, height: 100),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
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

          // Container(height: ScreenUtil.h(5),),

          Flexible(
            flex: 1,
            child: Container(child: CustomNumberPad(),)
          ),
        ],
      ),
    );
  }
}



