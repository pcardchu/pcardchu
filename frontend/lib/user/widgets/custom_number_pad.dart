
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/password_provider.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:provider/provider.dart';
class CustomNumberPad extends StatefulWidget {
  @override
  _CustomNumberPadState createState() => _CustomNumberPadState();
}

class _CustomNumberPadState extends State<CustomNumberPad> {
  @override
  void initState() {
    super.initState();
    Provider.of<PasswordProvider>(context, listen: false).shuffleNums();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PasswordProvider>(context);
    final randomNums = provider.nums;
    // randomNums.shuffle(); // 배열을 무작위로 섞음
    // final numbers = provider.numbers; // 숫자 배열 상태를 가져옴

    return Container(
      // height: ScreenUtil.w(100),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        childAspectRatio: 1.7,
        padding: const EdgeInsets.all(8),
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        children: List.generate(12, (index) {
          // 숫자 키패드에서 10번째 위치는 비어있음, 11번째는 0, 12번째는 삭제 버튼
          if (index == 9) return Container(); // 비어있는 공간
          if (index == 11) {
            // 삭제 버튼
            return IconButton(
              icon: Icon(Icons.backspace),
              onPressed: () => provider.deleteLast(), // -1을 전달하여 삭제를 알림
            );
          }



          // 0을 포함하여 숫자 버튼 (0은 11번째 위치에 있으므로, 인덱스 조정 필요)
          final number = index < 9 ? index + 1 : 0;

          return TextButton(
            child: Text("${randomNums[number]}"),
            onPressed: () => provider.addNumber(randomNums[number]),
            style: TextButton.styleFrom(
              textStyle: AppFonts.suit(fontSize: 20, fontWeight: FontWeight.w600)
            ),
          );
        }),
      ),
    );
  }
}