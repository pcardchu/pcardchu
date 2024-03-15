import 'package:flutter/material.dart';
import 'package:frontend/card/models/card_model.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:provider/provider.dart';

/// 카테고리에 해당하는 카드 위젯입니다.
class CategoryCard extends StatelessWidget {
  final List<CardModel> cards;
  final int index;

  const CategoryCard({
    super.key,
    required this.cards,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    /// 로딩 플래그, true면 로딩중
    final loading = Provider.of<CardProvider>(context).loading;

    return SizedBox(
      height: 100,
      child: loading ? null : Row(
        children: [
          /// 카드 이미지
          Image.network(cards[index].cardImg!),
          SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 카드 간단 설명
              Text(
                cards[index].cardContent!,
                style: AppFonts.suit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF26282B),
                ),
              ),
              SizedBox(height: 11),

              /// 카드 이름
              Text(
                cards[index].cardName!,
                style: AppFonts.suit(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF8F99A5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
