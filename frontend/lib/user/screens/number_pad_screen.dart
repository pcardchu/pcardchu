import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/password_provider.dart';
import 'package:frontend/user/widgets/custom_number_pad.dart';
import 'package:frontend/user/widgets/input_indicator.dart';
import 'package:provider/provider.dart';

class NumberInputScreen extends StatefulWidget {
  @override
  _NumberInputScreenState createState() => _NumberInputScreenState();
}

class _NumberInputScreenState extends State<NumberInputScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("커스텀 숫자 키패드"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 첫 번째 자식을 Flexible로 감싸서 비율을 지정합니다.
          Expanded(
            child: InputIndicator(),
          ),
          // 두 번째 자식을 Flexible로 감싸서 비율을 지정합니다.
          Flexible(
            flex: 1,
            child: CustomNumberPad(),
          ),
        ],
      ),
    );
  }
}



