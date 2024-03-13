
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/password_provider.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:provider/provider.dart';

class CustomNumberPad extends StatelessWidget {
  // final void Function(int) onNumberSelected;
  //
  // CustomNumberPad({required this.onNumberSelected});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PasswordProvider>(context);
    // final numbers = provider.numbers; // 숫자 배열 상태를 가져옴

    return GridView.count(
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

        var randomNums = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]; // 0부터 9까지의 숫자로 배열 초기화
        // randomNums.shuffle(Random()); // 배열을 무작위로 섞음

        // 0을 포함하여 숫자 버튼 (0은 11번째 위치에 있으므로, 인덱스 조정 필요)
        final number = index < 9 ? index + 1 : 0;

        return TextButton(
          child: Text("${randomNums[number]}"),
          onPressed: () => provider.addNumber(randomNums[number]),
          style: ElevatedButton.styleFrom(
              elevation: 0,
              textStyle: AppFonts.suit(fontSize: 20, fontWeight: FontWeight.w600)
          ),
        );
      }),
    );
  }
}