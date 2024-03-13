import 'package:flutter/material.dart';

/// 카드 등록 메인 바디 위젯입니다.
class CardRegistrationMain extends StatelessWidget {
  const CardRegistrationMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 45.0),
          Text(
            '아아 여기는 카드등록창 !',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 11.0),
          Text(
            '디자인이 어떻게 될지 몰라서 임시로',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: Color(0xff8F99A5),
            ),
          ),
        ],
      ),
    );
  }
}
