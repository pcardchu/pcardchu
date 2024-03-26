import 'package:flutter/material.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/screen_util.dart';

class TimeAnalyzeCard extends StatelessWidget {
  const TimeAnalyzeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil.h(24),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: Color(0xFFFAD7D7),
        child: Center(
          child: Container(
            width: ScreenUtil.w(83),
            height: ScreenUtil.h(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '피카추에서만 알 수 있는',
                          style: AppFonts.suit(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textBlack),
                        ),
                        Text(
                          '새로운 사실',
                          style: AppFonts.suit(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textBlack),
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/images/questionmark_icon.png',
                      width: ScreenUtil.w(20),

                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil.h(4),
                ),
                Row(
                  children: [
                    SizedBox(width: ScreenUtil.w(4),),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '지금 시간에는 70대의 소비가 ',
                          style: AppFonts.suit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFA7878)),
                        ),
                        Text(
                          '가장 두드러졌어요.',
                          style: AppFonts.suit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFA7878)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
