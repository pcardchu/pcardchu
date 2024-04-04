import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/card_detail/detail_tag.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/card_model.dart';

class DetailTop extends StatelessWidget {
  const DetailTop({super.key});

  @override
  Widget build(BuildContext context) {
    // 카드 디테일 정보 가져오기
    CardModel? card = context.watch<CardProvider>().cardDetail;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      // 상단 부분 컬럼
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 카드 사진
          SizedBox(
            height: 180,
            width: 300,
            child: Image.network(card!.cardImage!),
          ),
          SizedBox(height: 20),
          // 카드 이름
          Text(
            card.cardName!,
            style: AppFonts.scDream(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF26282B),
            ),
          ),
          SizedBox(height: 6),
          // 카드사
          Text(
            card.company!,
            style: AppFonts.suit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8F99A5),
            ),
          ),
          SizedBox(height: 12),
          // 태그
          Wrap(
            spacing: 7,
            runSpacing: 12,
            children: card.tag!
                .asMap()
                .entries
                .map((e) => DetailTag(
                      index: e.key,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
