
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';

///앱의 테마를 지정하는 클래스
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.mainWhite, //기본 배경 색
      textTheme: TextTheme(
        bodyLarge: AppFonts.suit(fontSize: 16, fontWeight: FontWeight.normal).copyWith(color: AppColors.textBlack),
        bodyMedium: AppFonts.suit(fontSize: 14, fontWeight: FontWeight.normal).copyWith(color: AppColors.textBlack),
        displayLarge: AppFonts.suit(fontSize: 24, fontWeight: FontWeight.bold).copyWith(color: AppColors.textBlack),
        displayMedium: AppFonts.suit(fontSize: 22, fontWeight: FontWeight.bold).copyWith(color: AppColors.textBlack),
        // 추가적으로 필요한 텍스트 스타일을 여기에 정의할 수 있습니다.
      ),

      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(
          color: AppColors.mainBlue, // AppBar 아이콘 색상
        ),
        actionsIconTheme: IconThemeData(
          // color: AppColors.mainBlue, // AppBar 액션 버튼 아이콘 색상
        ),
        // AppBar 배경 색상을 투명으로 설정
        color: AppColors.mainWhite,

        elevation: 0, // AppBar의 그림자를 없애기
      ),
      //textButton
      textButtonTheme: TextButtonThemeData(
        style: _commonButtonStyle(),
      ),

      //elevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _commonButtonStyle(),
      ),

      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.mainBlue,
        selectionColor: AppColors.mainBlue
      ),

      //input 박스
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.mainBlue, width: 2.0),
        ),
        labelStyle: AppFonts.suit(color: AppColors.lightGrey),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightGrey),
        ),
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
    foregroundColor: MaterialStateProperty.all(AppColors.mainWhite),
    textStyle: MaterialStateProperty.all<TextStyle>(
        AppFonts.suit(fontSize: 16, fontWeight: FontWeight.w600)
    ),
    // 배경색 (투명)
    backgroundColor: MaterialStateProperty.all(AppColors.mainBlue),
    overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return AppColors.lightGrey; // 스플래시 색상 설정
        }
        return null; // 기본값 사용
      },
    ),
  );
}
