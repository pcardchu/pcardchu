import 'package:flutter/material.dart';
import 'package:frontend/card/screens/card_company_info.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/card/screens/card_company.dart';

/// 카드 번호 스캔 없이 직접 입력
class SelfCardNumber extends StatefulWidget {
  const SelfCardNumber({super.key});

  @override
  State<SelfCardNumber> createState() => _SelfCardNumberState();
}

class _SelfCardNumberState extends State<SelfCardNumber> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.bottomGrey,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        minimumSize: const Size(100, 30),
      ),
      // 버튼을 눌렀을때
      // 카드 등록 정보를 확인한다
      onPressed: onPressed,
      child: Row(
        children: [
          Text(
            '카드번호 직접 입력하기',
            style: AppFonts.suit(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(width: 5),
          const Icon(
            Icons.arrow_forward_ios_outlined,
            color: AppColors.textBlack,
            size: 16,
          ),
        ],
      ),
    );
  }

  void onPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CardCompanyInfo())
    );
  }
}
