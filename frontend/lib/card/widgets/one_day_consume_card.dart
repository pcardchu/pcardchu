import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/card_detail_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/category_colors.dart';

class OneDayConsumeCard extends StatelessWidget {
  final int index;

  const OneDayConsumeCard({super.key,
    required this.index,});

  @override
  Widget build(BuildContext context) {
    final cardDetailProvider = Provider.of<CardDetailProvider>(context);
    // final loading = cardDetailProvider.loading;
    final data = cardDetailProvider.cardDetailModel.todayUseHistory;

    /// 소비 패턴 분류별 색상
    CategoryColors categoryColors = CategoryColors();
    List<Color> colorList = categoryColors.categoryColors;




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
                NumberFormat('#,###원', 'ko_KR')
                    .format(
                  //100000000
                data![index].amount
                ),
                style: AppFonts.suit(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textBlack,
                ),
              ),
              // 퍼센트
              Text(
                //'쉼터',
                '${data![index].category}',
                style: AppFonts.suit(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }
}
