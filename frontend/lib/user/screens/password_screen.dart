import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/user/widgets/custom_number_pad.dart';
import 'package:frontend/user/widgets/input_indicator.dart';
import 'package:frontend/utils/screen_util.dart';

class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(height: ScreenUtil.h(17),),
          Flexible(
            flex: 1,
            child:
            Column(
              // mainAxisAlignment: cen,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset('assets/images/lock.png', width: 100, height: 100),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "비밀번호를 입력해 주세요",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  // color: Colors.grey,
                  // height: ScreenUtil.h(15),
                  child: InputIndicator(),
                ),

              ],
            ),
          ),

          // Container(height: ScreenUtil.h(5),),

          Flexible(
            flex: 1,
            child: Container(child: CustomNumberPad(),)
          ),
        ],
      ),
    );
  }
}



