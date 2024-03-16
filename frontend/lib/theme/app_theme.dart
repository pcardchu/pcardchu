
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';

///앱의 테마를 지정하는 클래스
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      textTheme: TextTheme(
        bodyLarge: AppFonts.suit(fontSize: 16, fontWeight: FontWeight.normal).copyWith(color: AppColors.textBlack),
        bodyMedium: AppFonts.suit(fontSize: 14, fontWeight: FontWeight.normal).copyWith(color: AppColors.textBlack),
        displayLarge: AppFonts.suit(fontSize: 24, fontWeight: FontWeight.bold).copyWith(color: AppColors.textBlack),
        displayMedium: AppFonts.suit(fontSize: 22, fontWeight: FontWeight.bold).copyWith(color: AppColors.textBlack),
        // 추가적으로 필요한 텍스트 스타일을 여기에 정의할 수 있습니다.
      ),


      //textButton
      textButtonTheme: TextButtonThemeData(
        style: _commonButtonStyle(),
      ),
      //iconButton
      iconButtonTheme: IconButtonThemeData(
        style: _commonButtonStyle(),
      ),

      //elevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _commonButtonStyle(),
      ),

    );
  }

  static ThemeData get darkTheme {
    return ThemeData();
  }

}

//공통적인 버튼의 스타일
ButtonStyle _commonButtonStyle() {
  return ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    //글자색
    foregroundColor: MaterialStateProperty.all(AppColors.mainBlue),
    textStyle: MaterialStateProperty.all<TextStyle>(
        AppFonts.suit(fontSize: 16, fontWeight: FontWeight.w600)
    ),
    // 배경색 (투명)
    backgroundColor: MaterialStateProperty.all(Colors.transparent),
    overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return AppColors.splashBlue; // 스플래시 색상 설정
        }
        return null; // 기본값 사용
      },
    ),
  );
}
