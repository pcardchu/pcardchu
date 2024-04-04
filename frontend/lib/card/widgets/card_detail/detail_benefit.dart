import 'package:flutter/material.dart';
import 'package:frontend/card/models/card_model.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:provider/provider.dart';

/// 카드 디테일 화면에서 혜택 배너 위젯
class DetailBenefit extends StatelessWidget {
  // 혜택 인덱스
  final int index;

  const DetailBenefit({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // 카드 디테일 정보 가져오기
    CardModel? card = context.read<CardProvider>().cardDetail;

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
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          // 혜택 이미지
          SizedBox(
            height: 46,
            width: 46,
            child: SizedBox(
              child: benefitsDic[card!.benefits![index][0]] == null
                  ? Image.asset('assets/images/category_12.png')
                  : Image.asset(benefitsDic[card.benefits![index][0]]),
            ),
          ),
          SizedBox(width: 25),
          Container(
            width: ScreenUtil.w(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 혜택 종류
                Text(
                  card!.benefits![index][0],
                  style: AppFonts.suit(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey),
                ),
                // 혜택 정보
                Text(
                  card.benefits![index][1],
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
