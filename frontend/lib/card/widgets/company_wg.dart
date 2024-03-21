import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';

// 카드 등록 - 카드사 선택 - 각 카드사 위젯
class CompanyWg extends StatelessWidget {
  final Map company;
  final bool isSelected;
  final VoidCallback onTap;

  const CompanyWg({
    super.key,
    required this.company,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // 터치 됐을때 실행 함수
      onTap: onTap,
      // 카드 위젯을 기본으로 사용
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        // 터치 됐을때 확인용으로 배경 색상 변경
        color: isSelected ? AppColors.selected : AppColors.noSelected,
        child: Column(
          children: [
            // 카드사 로고
            Container(
              height: 70,
              width: 80,
              child: Image.asset(company['image']),
            ),
            // 카드사 이름
            Text(
              '${company['name']}카드',
              style: AppFonts.suit(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
