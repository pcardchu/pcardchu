import 'package:flutter/material.dart';
import 'package:frontend/animations/fade_and_slide_transition_page_route.dart';
import 'package:frontend/animations/fade_transition_page_route.dart';
import 'package:frontend/home/screens/home_screen.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:frontend/user/screens/password_screen.dart';
import 'package:provider/provider.dart';

///카카오 로그인 버튼 위젯
class KakaoLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFEE500), // 버튼 배경색
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // 버튼의 둥근 모서리
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // 패딩 조정
      ),
      onPressed: () async {
        await Provider.of<LoginProvider>(context, listen: false).login();
        // 로그인 작업이 완료된 후에 isLoggedIn 상태를 체크
        if (Provider.of<LoginProvider>(context, listen: false).isLoggedIn) {
          // isLoggedIn이 true인 경우, PasswordScreen으로 이동
          Navigator.pushReplacement(
            context,
              FadeAndSlideTransitionPageRoute(
                  page: PasswordScreen(),
                  duration: Duration(milliseconds: 130),
              )
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset('assets/images/kakao_logo.png', height: 20.0), // 카카오 로고 이미지
          Text(
            "카카오로 로그인",
            style: TextStyle(
              color: Colors.black87, // 텍스트 색상
              fontSize: 16.0, // 텍스트 크기
            ),
          ),
          SizedBox(),
        ],
      ),
    );
  }
}
