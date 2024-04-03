import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:frontend/animations/fade_and_slide_transition_page_route.dart';
import 'package:frontend/animations/fade_transition_page_route.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:frontend/providers/password_provider.dart';
import 'package:frontend/user/screens/intro_screen.dart';
import 'package:frontend/user/screens/password_screen.dart';
import 'package:frontend/utils/crypto_util.dart';
import 'package:provider/provider.dart';
import 'package:secure_application/secure_application_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'package:frontend/home/screens/bottom_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    await loginProvider.checkToken();

    SecureApplicationProvider.of(context)?.secure();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    bool token = await loginProvider.getFirstJwt();
    print("토큰 여부 : ${token}");


    if (!_seen) {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const IntroScreen()));
    }
    else if (loginProvider.isLoggedIn && token) {
      //기존 토큰이 확인 되었을 때 로직
      Navigator.of(context).pushReplacement(
          FadeTransitionPageRoute(
              page: PasswordScreen(),
              transitionDuration: const Duration(milliseconds: 200),
              reverseTransitionDuration: const Duration(milliseconds: 200)
          )
      );
    } else {
      //기존 토큰이 없을 시 로그인 화면으로 이동 로직
      Navigator.of(context).pushReplacement(
          FadeTransitionPageRoute(
              page: LoginScreen(),
              transitionDuration: const Duration(milliseconds: 200),
              reverseTransitionDuration: const Duration(milliseconds: 200)
          )
      );
    }
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container()
    );
  }
}
