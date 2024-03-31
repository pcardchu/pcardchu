import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/consumption/best_title.dart';
import 'package:frontend/card/widgets/consumption/recommend_list.dart';
import 'package:frontend/providers/consumption_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:provider/provider.dart';

/// 소비패턴 - 카드 추천 탭 화면
class ConsumptionTab2 extends StatelessWidget {
  const ConsumptionTab2({super.key});

  @override
  Widget build(BuildContext context) {
    /// 내 추천 카드 정보
    final data = context.watch<ConsumptionProvider>().myRecommend;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${data!.name}님이 많이 쓴 곳에서\n받을 수 있는 혜택',
                  style: AppFonts.suit(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textBlack,
                  ),
                ),
              ],
            ),
          ),
          BestTitle(index: 0),
          SizedBox(height: 34),
          // 추천 카드 리스트를 보여준다.
          RecommendList(),
        ],
      ),
    );
  }
}
