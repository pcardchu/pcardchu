import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';

class ForgotPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        // 버튼 클릭 시 실행할 작업
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent, // 배경색
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 8.0), // 아이콘과 텍스트 사이 간격
            Text(
              "비밀번호를 몰라요",
              style: AppFonts.suit(fontWeight: FontWeight.w500, color: AppColors.mainBlue, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
