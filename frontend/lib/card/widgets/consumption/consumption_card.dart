import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/consumption_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/category_colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConsumptionCard extends StatelessWidget {
  /// 배열 인덱스
  final int index;

  const ConsumptionCard({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    /// 내 소비 패턴 데이터
    final data = context.watch<ConsumptionProvider>().myConsumption;

    /// 소비 패턴 분류별 색상
    CategoryColors categoryColors = CategoryColors();
    List<Color> colorList = categoryColors.categoryColors;

    /// 퍼센트 계산
    final double percent = data!.mainConsumption![index].amount /
        data.mainConsumption!
            .map<int>((e) => e.amount as int)
            .reduce((a, c) => a + c) *
        100;

    return Container(
      child: Row(
        children: [
          // 색상 표시
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorList[index],
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 분야 이름
              Text(
                data.mainConsumption![index].categoryName,
                style: AppFonts.suit(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textBlack,
                ),
              ),
              // 퍼센트
              Text(
                '${percent.toStringAsFixed(2)} %',
                style: AppFonts.suit(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          Spacer(),
          // 소비 금액
          Text(
            NumberFormat('#,###원', 'ko_KR')
                .format(data.mainConsumption![index].amount),
            style: AppFonts.suit(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
