import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

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

    if (loginProvider.isLoggedIn) {
      //기존 토큰이 확인 되었을 때 로직
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      //기존 토큰이 없을 시 로그인 화면으로 이동 로직
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
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
