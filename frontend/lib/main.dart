import 'package:flutter/material.dart';
import 'package:frontend/user/screens/login_screen.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'providers/login_provider.dart';

void main() {
  KakaoSdk.init(nativeAppKey: 'd5a3a615fae48c6968cde53a7d05e645');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
      ],
      child: MaterialApp(
        home: LoginScreen(),
      ),
    );
  }
}
