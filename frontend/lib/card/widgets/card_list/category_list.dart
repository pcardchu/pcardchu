import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/card_list/category_chip.dart';

/// 카테고리 스크롤뷰
class CategoryList extends StatelessWidget {
  // 어떤 카테고리를 선택했는지 확인하는 인덱스
  final int selectedChoiceIndex;
  // 카테고리를 선택했을때 인덱스 저장하는 함수
  final Function(int) selectedChip;

  const CategoryList({
    super.key,
    required this.selectedChoiceIndex,
    required this.selectedChip,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        children: [
          SizedBox(width: 39),
          ...['전체', '푸드', '교통', '쇼핑', '의료', '통신', '여행', '할인', '문화/생활', '카페', '온라인결제', '마트/편의점', '기타']
              .asMap()
              .entries
              .map((entry) {
            int idx = entry.key;
            String title = entry.value;
            return Row(
              children: [
                CategoryChip(
                  title: title,
                  selectedChoiceIndex: selectedChoiceIndex,
                  selectedChip: selectedChip,
                  categoryIndex: idx,
                ),
                SizedBox(width: idx < 12 ? 15 : 0),
              ],
            );
          }),
        ],
      ),
    );
  }
}
