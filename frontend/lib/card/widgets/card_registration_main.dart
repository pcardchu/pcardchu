import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';

/// 카드 등록 메인 바디 위젯입니다.
class CardRegistrationMain extends StatelessWidget {
  const CardRegistrationMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '등록할 카드를 스캔해주세요',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textBlack,
                ),
              ),
            ],
          ),
          // 중앙 이미지
          SizedBox(
              height: 600,
              width: 600,
              child: Image.asset('assets/images/registration_card.png')),
        ],
      ),
    );
  }
}
