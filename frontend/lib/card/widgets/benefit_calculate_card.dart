import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/card_detail_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/screen_util.dart';

class BenefitCalculateCard extends StatelessWidget {
  final String benefitType;
  final int benefitAmount;

  const BenefitCalculateCard({
    super.key,
    required this.benefitType,
    required this.benefitAmount,
  });

  @override
  Widget build(BuildContext context) {
    final cardDetailProvider = Provider.of<CardDetailProvider>(context);
    // final loading = cardDetailProvider.loading;
    final data = cardDetailProvider.cardDetailModel.useBenefit;

    // 혜택별 이미지 아이콘
    Map benefitsDic = {
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
      '유의사항': 'assets/images/category_13.png',
      '선택형1': 'assets/images/category_14.png',
      '선택형2': 'assets/images/category_14.png',
      '선택형3': 'assets/images/category_14.png',
      '주유': 'assets/images/category_15.png',
    };


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Row(
        children: [
          // 혜택 이미지
          SizedBox(
            height: 46,
            width: 46,
            child: SizedBox(child: Image.asset(benefitsDic[benefitType])),
          ),
          SizedBox(width: 25),
          Container(
            width: ScreenUtil.w(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 혜택 종류
                Text(
                  benefitType,
                  style: AppFonts.suit(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey),
                ),
                // 혜택 정보
                Text(
                  NumberFormat('#,###원 할인', 'ko_KR').format(benefitAmount),
                  style: AppFonts.suit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
