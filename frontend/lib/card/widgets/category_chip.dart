import 'package:flutter/material.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:provider/provider.dart';

/// 카테고리 칩
class CategoryChip extends StatelessWidget {
  final String title;

  /// 카테고리 인덱스
  final int categoryIndex;

  /// 어떤 카테고리를 선택했는지 확인하는 인덱스
  final int selectedChoiceIndex;

  /// 카테고리를 선택했을때 인덱스 저장하는 함수
  final Function(int) selectedChip;

  const CategoryChip({
    super.key,
    required this.title,
    required this.selectedChoiceIndex,
    required this.selectedChip,
    required this.categoryIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        title,
        style: AppFonts.suit(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: selectedChoiceIndex == categoryIndex
              ? Color(0xFFFEF7FF)
              : Color(0xFF8F99A5),
        ),
      ),
      selected: selectedChoiceIndex == categoryIndex,
      onSelected: (selected) {
        selectedChip(categoryIndex);
        context.read<CardProvider>().changeCategory(categoryIndex);
      },
      backgroundColor: Color(0xFFECECEC),
      /// 선택했을때 색 다르게
      selectedColor: Color(0xFF051D40),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Color(0xFFD8D8D8),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      /// 선택시 체크 버튼 삭제
      showCheckmark: false,
    );
  }
}
