import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/card/screens/card_detail.dart';
import 'package:frontend/providers/consumption_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:provider/provider.dart';

/// 소비 - 카드 추천 탭의 카드 위젯
class RecommendCard extends StatelessWidget {
  // 카테고리 인덱스
  final int categoryIndex;

  // 카드 리스트 인덱스
  final int index;

  const RecommendCard({
    super.key,
    required this.index,
    required this.categoryIndex,
  });

  @override
  Widget build(BuildContext context) {
    /// 내 추천 카드 정보
    final data = context.watch<ConsumptionProvider>().myRecommend;

    /// 내 추천 카드 정보
    final card = data!.discount![categoryIndex].card![index];

    return GestureDetector(
      child: SizedBox(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 카드 이미지
              SizedBox(
                height: 80,
                width: 60,
                child: Image.network(
                  card.cardImage!,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    // 이미지 네트워크 로딩중이면 로딩 표시
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return SizedBox(
                        height: 60,
                        width: 60,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
              ),
              // 텍스트 부분
              SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 카드 이름
                    Text(
                      card.cardName!,
                      style: AppFonts.suit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(height: 11),
                    // 카드 간단 설명
                    Text(
                      card.cardContent!,
                      style: AppFonts.suit(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textBlack,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // 터치했을때 카드 디테일 정보 페이지로 넘어갑니다.
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CardDetail(
              // 해당 카드 아이디를 넘겨줍니다.
              cardId: card.cardId.toString(),
            ),
          ),
        );
      },
    );
  }
}
