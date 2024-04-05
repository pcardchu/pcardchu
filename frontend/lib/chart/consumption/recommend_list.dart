import 'package:flutter/material.dart';
import 'package:frontend/chart/consumption/best_title.dart';
import 'package:frontend/providers/consumption_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:provider/provider.dart';

import 'recommend_card.dart';

/// 분야 리스트
class RecommendList extends StatelessWidget {
  const RecommendList({super.key});

  @override
  Widget build(BuildContext context) {
    /// 내 추천 카드 정보
    final data = context.watch<ConsumptionProvider>().myRecommend;

    // 분야 리스트
    return ListView.separated(
      //ListView가 차지하는 공간을 자식 크기에 맞춤
      shrinkWrap: true,
      // 부모 스크롤과 충돌 방지
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, categoryIndex) {
        // 해당 분야 추천카드 리스트
        return ListView.builder(
          //ListView가 차지하는 공간을 자식 크기에 맞춤
          shrinkWrap: true,
          // 부모 스크롤과 충돌 방지
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                // 카드 위젯
                RecommendCard(index: index, categoryIndex: categoryIndex,),
                SizedBox(height: 16),
              ],
            );
          },
          itemCount: data.discount![0].card!.length,
        );
      },
      separatorBuilder: (context, index) {
        return Column(
          children: [
            Container(
              height: 16,
              color: AppColors.bottomGrey,
            ),
            BestTitle(index: index+1),
            SizedBox(height: 34),
          ],
        );
      },
      itemCount: data!.discount!.length,
    );
  }
}
