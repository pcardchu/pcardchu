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
      '선택형': 'assets/images/benefit_1.png',
      '교통': 'assets/images/benefit_2.png',
      '통신': 'assets/images/benefit_3.png',
      '영화/문화': 'assets/images/benefit_4.png',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 혜택 이미지
          SizedBox(
              height: 46,
              width: 46,
              child: Image.asset(benefitsDic[card!.benefits![index][0]])),
          SizedBox(width: 10),
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
