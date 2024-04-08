import 'package:flutter/material.dart';
import 'package:frontend/animations/fade_and_slide_transition_page_route.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:frontend/providers/password_provider.dart';
import 'package:frontend/user/screens/password_screen.dart';
import 'package:frontend/user/screens/registration_intro_screen.dart';
import 'package:provider/provider.dart';

/// 카카오 로그인 버튼 위젯
class KakaoLoginButton extends StatefulWidget {
  @override
  _KakaoLoginButtonState createState() => _KakaoLoginButtonState();
}

class _KakaoLoginButtonState extends State<KakaoLoginButton> {
  bool _isLoggingIn = false; // 로그인 진행 중인지 확인하는 변수

  @override
  Widget build(BuildContext context) {
    LoginProvider provider = Provider.of<LoginProvider>(context, listen: false);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFEE500), // 버튼 배경색
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // 버튼의 둥근 모서리
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // 패딩 조정
      ),
      onPressed: _isLoggingIn ? (){} : () async { // _isLoggingIn이 true면 onPressed를 null로 설정하여 클릭 무시
        setState(() {
          _isLoggingIn = true; // 로그인 시도 상태로 설정
        });

        if (!await provider.login()) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("잠시 후 다시 시도해 주세요", textAlign: TextAlign.center,))
          );
        }

        if (provider.isFirst) {
          // 회원가입 화면으로 이동
          provider.isFirst = false;
          Navigator.pushReplacement(
              context,
              FadeAndSlideTransitionPageRoute(
                page: const RegistrationIntroScreen(),
                duration: const Duration(milliseconds: 130),
              )
          );
        } else if (!provider.isFirst && provider.isLoggedIn) {
          final passwordProvider = Provider.of<PasswordProvider>(context, listen: false);
          passwordProvider.clearAll();
          // PasswordScreen으로 이동
          Navigator.pushReplacement(
              context,
              FadeAndSlideTransitionPageRoute(
                page: PasswordScreen(),
                duration: const Duration(milliseconds: 130),
              )
          );
        }

        setState(() {
          _isLoggingIn = false; // 로그인 시도 상태 해제
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset('assets/images/kakao_logo.png', height: 20.0), // 카카오 로고 이미지
          const Text(
            "카카오로 로그인",
            style: TextStyle(
              color: Colors.black87, // 텍스트 색상
              fontSize: 16.0, // 텍스트 크기
            ),
          ),
          Opacity(opacity: 0.0, child: Image.asset('assets/images/kakao_logo.png', height: 20.0)), // 공간을 맞추기 위한 투명 이미지
        ],
      ),
    );
  }
}
