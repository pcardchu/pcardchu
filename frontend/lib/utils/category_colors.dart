import 'package:flutter/material.dart';

/// 소비 패턴 화면에 사용되는 차트의 카테고리별 색상
class CategoryColors {
  final List<Color> _categoryColors = [
    Color(0xFFFE7ED2),
    Color(0xFF5B98BA),
    Color(0xFFDF4643),
    Color(0xFFF5E79D),
    Color(0xFFD9D9D9),
  ];

  List<Color> get categoryColors => _categoryColors;
}