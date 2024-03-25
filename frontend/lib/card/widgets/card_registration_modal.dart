import 'package:flutter/material.dart';
import 'package:frontend/card/screens/card_registration.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';

// 카드 등록시 입력 정보가 잘못된 경우 보여주는 모달
class CardRegistrationModal extends StatelessWidget {
  const CardRegistrationModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // 배경색
      backgroundColor: AppColors.mainWhite,
      // 모양 설정
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 15),
          SizedBox(
              height: 30,
              width: 30,
              child: Image.asset('assets/images/xox_logo.png')),
          SizedBox(height: 8),
          Text(
            '등록된 고객정보가 존재하지 않아요',
            style: AppFonts.suit(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 5),
          Text(
            '다시 입력해주세요',
            style: AppFonts.suit(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.lightGrey,
            ),
          ),
          SizedBox(height: 5),
          // 카드 등록 버튼
          SizedBox(
            width: 150,
            child: ElevatedButton(
              // 모달 끄기
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
