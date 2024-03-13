import 'package:flutter/material.dart';

/// 편리한 폰트 사용을 위한 util
///
/// ex)
/// Text(
///   '이것은 SUIT 폰트입니다.',
///   style: AppFonts.suit(fontSize: 16, fontWeight: FontWeight.w500),
/// )
///
///FontWeight.w100 ~ FontWeight.w900: 100에서 900까지 100 단위로 미리 정의된 굵기를 제공합니다. 여기서 FontWeight.w400은 normal 또는 일반 텍스트에 해당하며, FontWeight.w700은 bold에 해당합니다.
/// FontWeight.normal: 기본 텍스트의 굵기로, FontWeight.w400과 동일합니다.
/// FontWeight.bold: 굵은 텍스트에 사용되며, FontWeight.w700과 동일합니다.
class AppFonts {
  static const String suitFamily = 'SUIT';
  static const String scDreamFamily = 'SCDream';

  static TextStyle suit({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return TextStyle(
      fontFamily: suitFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle scDream({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return TextStyle(
      fontFamily: scDreamFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
