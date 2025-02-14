import 'package:flutter/material.dart';
import 'package:frontend/providers/consumption_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// 전달 비교 정보 위젯
class Compare extends StatelessWidget {
  const Compare({super.key});

  @override
  Widget build(BuildContext context) {
    /// 내 소비 패턴 정보
    final data = context.watch<ConsumptionProvider>().myConsumption;

    return Column(
      children: [
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              NumberFormat('이번달 #,###원 썼어요', 'ko_KR')
                  .format(data!.thisMonthAmount),
              style: AppFonts.scDream(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Text(
              '지난달 보다 현재',
              style: AppFonts.suit(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.lightGrey,
              ),
            ),
            Text(
              data.amountGap > 0
                  ? NumberFormat(' #,###원 더', 'ko_KR').format(data.amountGap)
                  : NumberFormat(' #,###원 덜', 'ko_KR').format(data.amountGap.abs()),
              style: AppFonts.suit(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.emphasisBlue,
              ),
            ),
            Text(
              ' 썼어요',
              style: AppFonts.suit(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.lightGrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
