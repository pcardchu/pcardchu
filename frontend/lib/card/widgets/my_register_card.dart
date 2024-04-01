import 'package:flutter/material.dart';
import 'package:frontend/utils/screen_util.dart';

class MyRegisterCard extends StatefulWidget {
  const MyRegisterCard({super.key});

  @override
  State<MyRegisterCard> createState() => _MyRegisterCardState();
}

class _MyRegisterCardState extends State<MyRegisterCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.screenWidth,
      height: ScreenUtil.h(56),
      color: Colors.red,
      child: Center(
          child: Text(
        '여기에 스택 카드 들어가예 ~',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      )),
    );
  }
}
