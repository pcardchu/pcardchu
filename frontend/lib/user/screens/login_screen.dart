import 'package:flutter/material.dart';
import 'package:frontend/home/screens/home_screen.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:frontend/user/widgets/kakao_login_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page",
        style: TextStyle(fontFamily: 'SUIT'),),
      ),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("임시 로그인"),
              onPressed: ()  {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            KakaoLoginButton(),
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
