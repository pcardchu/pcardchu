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

    // 분야별 이미지 아이콘
    Map categoryDic = {
      '푸드': 'assets/images/category_1.png',
      '교통': 'assets/images/category_2.png',
      '쇼핑': 'assets/images/category_3.png',
      '의료': 'assets/images/category_4.png',
      '통신': 'assets/images/category_5.png',
      '여행': 'assets/images/category_6.png',
      '할인': 'assets/images/category_7.png',
      '문화/생활': 'assets/images/category_8.png',
      '카페': 'assets/images/category_9.png',
      '온라인결제': 'assets/images/category_10.png',
      '마트/편의점': 'assets/images/category_11.png',
      '기타': 'assets/images/category_12.png',
    };

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
                height: 50,
                width: 50,
                child: categoryDic[data.discount![index].category] == null
                    ? Image.asset('assets/images/smile_logo.png', fit: BoxFit.fitWidth)
                    : Image.asset(categoryDic[data.discount![index].category], fit: BoxFit.fitWidth),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
