import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/user/widgets/custom_number_pad.dart';
import 'package:frontend/user/widgets/input_indicator.dart';
import 'package:frontend/utils/screen_util.dart';

class NumberInputScreen extends StatefulWidget {
  @override
  _NumberInputScreenState createState() => _NumberInputScreenState();
}

class _NumberInputScreenState extends State<NumberInputScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(height: ScreenUtil.h(15),),

          Expanded(
            // flex: 1,
            child: InputIndicator(),
          ),
          Container(height: ScreenUtil.h(5),),

          Expanded(
            // flex: 1,
            child: CustomNumberPad(),
          ),
        ],
      ),
    );
  }
}



