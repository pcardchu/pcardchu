import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';

import 'self_card_number.dart';

/// 카드 등록 메인 바디 위젯입니다.
class CardRegistrationMain extends StatelessWidget {
  // 스캔 화면을 호출하는 함수
  final Function scan;
  const CardRegistrationMain({super.key, required this.scan});

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
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SelfCardNumber(scan: scan,),
            ],
          ),
          // 중앙 이미지
          SizedBox(
              height: 500,
              width: 500,
              child: Image.asset('assets/images/registration_card.png')),
        ],
      ),
    );
  }
}
