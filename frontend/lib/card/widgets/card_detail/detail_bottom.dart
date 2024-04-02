import 'package:flutter/material.dart';
import 'package:frontend/card/models/card_model.dart';
import 'package:frontend/card/widgets/card_detail/detail_benefit.dart';
import 'package:frontend/card/widgets/card_detail/detail_terms.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:provider/provider.dart';

class DetailBottom extends StatelessWidget {
  const DetailBottom({super.key});

  @override
  Widget build(BuildContext context) {
    // 카드 디테일 정보 가져오기
    CardModel? card = context.watch<CardProvider>().cardDetail;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "혜택",
            style: AppFonts.suit(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 19),
          // 혜택 위젯 리스트
          ListView.builder(
            // 스크롤 기능 없애기
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: card!.benefits!.length,
            itemBuilder: (BuildContext context, int index) {
              return DetailBenefit(
                index: index,
              );
            },
          ),
          SizedBox(height: 20),
          // 약관 텍스트 위젯
          DetailTerms(),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
