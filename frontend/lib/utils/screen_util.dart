import 'package:flutter/widgets.dart';

/// ScreenUtil은 화면 크기 관련 기능을 제공하는 유틸리티 클래스입니다.
///
/// 이 클래스는 화면의 크기를 쉽게 얻을 수 있으며, 화면 크기에 따른 상대적인 크기 계산을
/// 용이하게 하여 반응형 디자인 구현을 돕습니다.
class ScreenUtil {
  /// 화면 정보를 저장하는 MediaQueryData.
  static late MediaQueryData _mediaQueryData;

  /// 논리 픽셀 단위의 화면 너비.
  static late double screenWidth;

  /// 논리 픽셀 단위의 화면 높이.
  static late double screenHeight;

  /// 상대적 크기 계산을 위한 화면 너비의 1% 값.
  static late double blockWidth;

  /// 상대적 크기 계산을 위한 화면 높이의 1% 값.
  static late double blockHeight;

  /// context를 이용해 ScreenUtil을 초기화하여 화면의 크기를 얻습니다.
  ///
  /// 이 메소드는 MediaQuery의 조상을 가진 BuildContext와 함께 호출되어야 합니다.
  /// 일반적으로 앱이나 화면의 빌드 메소드 시작 시 호출됩니다.
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    // 화면 너비와 높이를 100으로 나누어 1%의 블록 크기를 구합니다.
    blockWidth = screenWidth / 100;
    blockHeight = screenHeight / 100;
  }

  /// 화면 너비의 일정 비율로 너비를 반환합니다.
  ///
  /// [width]는 비율 값이며, `w(50)`은 화면 너비의 절반을 반환합니다.
  static double w(double width) {
    return blockWidth * width;
  }

  /// 화면 높이의 일정 비율로 높이를 반환합니다.
  ///
  /// [height]는 비율 값이며, `h(50)`은 화면 높이의 절반을 반환합니다.
  static double h(double height) {
    return blockHeight * height;
  }

  /// 화면 너비에 비례하여 텍스트 크기를 반환합니다, 반응형 텍스트 크기를 용이하게 합니다.
  ///
  /// [textSize]는 화면 너비를 기준으로 한 비율 값으로, 텍스트 크기를 반응형으로 만듭니다.
  static double text(double textSize) {
    return textSize * (screenWidth / 3) / 100;
  }
}
