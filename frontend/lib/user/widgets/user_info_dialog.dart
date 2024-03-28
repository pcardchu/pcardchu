import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';

class UserInfoDialog extends StatelessWidget{
  final String date;
  final String gender;
  final VoidCallback onConfirm;

  const UserInfoDialog({
    Key? key,
    required this.date,
    required this.gender,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.mainWhite,
      title: const Text('회원님의 정보가 맞나요?'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('부정확한 정보를 입력하면\n서비스 이용(카드 추천, 소비패턴 분석 등)이 제한될 수 있어요',
              style: AppFonts.suit(color: AppColors.lightGrey, fontSize: 10, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10,),
            Text('생년월일: $date',
              style: AppFonts.suit(color: AppColors.mainBlue, fontSize: 15, fontWeight: FontWeight.w600),
            ),
            Text('성별: $gender',
              style: AppFonts.suit(color: AppColors.mainBlue, fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
          ),
          child: const Text('다시 할래요', style: TextStyle(color: AppColors.subBlue),),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            // Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
          ),
          child: const Text('네', style: TextStyle(color: AppColors.subBlue),),
        ),
      ],
    );
  }
}
