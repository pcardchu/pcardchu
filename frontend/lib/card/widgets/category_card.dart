import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/card/screens/card_detail.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:provider/provider.dart';

/// 카테고리에 해당하는 카드 위젯입니다.
class CategoryCard extends StatelessWidget {
  final int index;

  const CategoryCard({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // 카테고리 아이디
    final categoryId = context.watch<CardProvider>().categoryId;
    // 해당 카테고리 카드 리스트
    final cards = context.watch<CardProvider>().categoryCards;

    return GestureDetector(
      child: SizedBox(
        height: 100,
        child: Row(
          children: [
            // 카드 이미지
            SizedBox(
              height: 100,
              width: 60,
              child: Image.network(
                cards[categoryId][index].cardImage!,
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
                  // 카드 간단 설명
                  Text(
                    cards[categoryId][index].cardContent!,
                    style: AppFonts.suit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textBlack,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: 11),
                  // 카드 이름
                  Text(
                    cards[categoryId][index].cardName!,
                    style: AppFonts.suit(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textBlack,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // 터치했을때 카드 디테일 정보 페이지로 넘어갑니다.
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CardDetail(
              // 해당 카드 아이디를 넘겨줍니다.
              cardId: cards[categoryId][index].cardId.toString(),
            ),
          ),
        );
      },
    );
  }
}
