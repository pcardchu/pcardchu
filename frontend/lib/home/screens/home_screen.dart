import 'package:flutter/material.dart';
import 'package:frontend/card/screens/card_registration.dart';

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
