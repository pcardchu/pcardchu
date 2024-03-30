import 'package:flutter/material.dart';
import 'package:frontend/card/models/card_model.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:provider/provider.dart';

// 카드 디테일 화면 태그 위젯입니다.
class DetailTag extends StatelessWidget {
  // 카드 디테일 태그 인덱스
  final int index;

  const DetailTag({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    // 카드 디테일 정보 가져오기
    CardModel? card = context.watch<CardProvider>().cardDetail;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.gray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        card!.tag![index],
        style: AppFonts.suit(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.grey,
        ),
      ),
    );
  }
}