import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/category_chip.dart';

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
          CategoryChip(
            title: '전체',
            selectedChoiceIndex: selectedChoiceIndex,
            selectedChip: selectedChip,
            categoryIndex: 0,
          ),
          SizedBox(width: 15),
          CategoryChip(
            title: '교통',
            selectedChoiceIndex: selectedChoiceIndex,
            selectedChip: selectedChip,
            categoryIndex: 1,
          ),
          SizedBox(width: 15),
          CategoryChip(
            title: '카페',
            selectedChoiceIndex: selectedChoiceIndex,
            selectedChip: selectedChip,
            categoryIndex: 2,
          ),
          SizedBox(width: 15),
          CategoryChip(
            title: '배달',
            selectedChoiceIndex: selectedChoiceIndex,
            selectedChip: selectedChip,
            categoryIndex: 3,
          ),
          SizedBox(width: 15),
          CategoryChip(
            title: '영화 / 문화',
            selectedChoiceIndex: selectedChoiceIndex,
            selectedChip: selectedChip,
            categoryIndex: 4,
          ),
        ],
      ),
    );
  }
}
