import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/home/screens/home_screen.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:provider/provider.dart';

///카카오 버튼 위젯입니다.
class KakaoLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text("카카오로 로그인"),
      onPressed: () async {
        await Provider.of<LoginProvider>(context, listen: false).login();
        // 로그인 작업이 완료된 후에 isLoggedIn 상태를 체크
        if (Provider.of<LoginProvider>(context, listen: false).isLoggedIn) {
          // isLoggedIn이 true인 경우, HomeScreen으로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      },
    );
  }
}
