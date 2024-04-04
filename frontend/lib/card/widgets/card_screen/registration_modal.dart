import 'package:flutter/material.dart';
import 'package:frontend/card/screens/card_registration.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';

class RegistrationModal extends StatefulWidget {
  const RegistrationModal({super.key});

  @override
  State<RegistrationModal> createState() => _RegistrationModalState();
}

class _RegistrationModalState extends State<RegistrationModal> {
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
          SizedBox(height: 19),
          SizedBox(
              height: 30,
              width: 30,
              child: Image.asset('assets/images/registration_icon.png')),
          SizedBox(height: 8),
          Text(
            '카드를 등록하지 않으셨네요!',
            style: AppFonts.suit(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '등록하시면 더 많은 기능을 이용할 수 있어요',
            style: AppFonts.suit(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.lightGrey,
            ),
          ),
          SizedBox(height: 27),
          // 카드 등록 버튼
          ElevatedButton(
            // 카드 등록 화면으로 이동
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CardRegistration(fromDialog: true,),
                ),
              );
            },
            child: Text('카드 등록하러 가기'),
          ),
          SizedBox(height: 22),
        ],
      ),
    );
  }
}
