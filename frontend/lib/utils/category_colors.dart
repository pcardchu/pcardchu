import 'package:flutter/material.dart';

/// 소비 패턴 화면에 사용되는 차트의 카테고리별 색상
class CategoryColors {
  final Map<String, Color> _categoryColors = {
    "의료, 건강, 피트니스" : Color(0xFFFE7ED2),
    "식비" : Color(0xFF5B98BA),
    "쇼핑" : Color(0xFFDF4643),
    "카페, 간식" : Color(0xFFF5E79D),
    "그 외 5개" : Color(0xFFD9D9D9),
  };

  Map<String, Color> get categoryColors => _categoryColors;
}