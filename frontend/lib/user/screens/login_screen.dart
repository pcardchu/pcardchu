import 'package:flutter/material.dart';
import 'package:frontend/home/screens/bottom_nav_screen.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:frontend/user/screens/password_screen.dart';
import 'package:frontend/user/widgets/kakao_login_button.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/app_icon.png', width: ScreenUtil.w(70),),
            SizedBox(height: ScreenUtil.h(20),),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BottomNavScreen(),
                  ),
                );
              },
              child: Text('HOME'),
            ),
            SizedBox(
              width: ScreenUtil.w(70),
              child: KakaoLoginButton(),
            ),
            Consumer<LoginProvider>(
                builder : (context, provider, child) {
                return Text(provider.isLoggedIn.toString());
                }
                ),
          ],
        ) ,
      ),
    );
  }
}