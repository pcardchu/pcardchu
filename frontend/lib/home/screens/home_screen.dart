import 'package:flutter/material.dart';
import 'package:frontend/card/screens/card_registration.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Column(
        children: [
          Text('Home'),
          ElevatedButton(onPressed: (){
            Provider.of<LoginProvider>(context, listen: false).logout(context);
          }, child: Text("로그아웃")),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CardRegistration(),
                  ),
                );
              },
              child: Text('ocr 테스트'))
        ],
      ),
    );
  }
}
