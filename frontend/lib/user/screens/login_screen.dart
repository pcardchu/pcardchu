import 'package:flutter/material.dart';
import 'package:frontend/home/screens/home_screen.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:frontend/user/screens/number_pad_screen.dart';
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
              child: Text("홈"),
              onPressed: ()  {
                Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    var begin = Offset(0.0, 1); // 아래에서 시작
                    var end = Offset.zero;
                    var curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ));
              },
            ),
            ElevatedButton(
              child: Text("넘버패드"),
              onPressed: ()  {
                Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => NumberInputScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    var begin = Offset(0.0, 1); // 아래에서 시작
                    var end = Offset.zero;
                    var curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ));
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
