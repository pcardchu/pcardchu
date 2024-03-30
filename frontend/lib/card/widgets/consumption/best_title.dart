import 'package:flutter/material.dart';
import 'package:frontend/providers/consumption_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// 소비패턴 - 카드추천 - 카테고리 배스트 타이틀 위젯
class BestTitle extends StatelessWidget {
  /// 카드 리스트 인덱스
  final int index;

  const BestTitle({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    /// 내 추천 카드 정보
    final data = context.watch<ConsumptionProvider>().myRecommend;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          const SizedBox(height: 34),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 카테고리
                  Text(
                    '${data!.discount![index].category} 할인 BEST',
                    style: AppFonts.suit(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textBlack,
                    ),
                  ),
                  SizedBox(height: 8),
                  // 사용 금액
                  Text(
                    NumberFormat('총 #,###원 사용했어요', 'ko_KR')
                        .format(data.discount![index].total),
                    style: AppFonts.suit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightGrey,
                    ),
                  ),
                ],
              ),
              Spacer(),
              // 카테고리 이미지 (지금은 임시 사진)
              SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.asset('assets/images/smile_logo.png'))
            ],
          ),
        ],
      ),
    );
  }
}
