import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';

class ToListCard extends StatelessWidget {
  const ToListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil.h(16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: Color(0xFFFFF7C5),
        child: Center(
          child: Container(
            width: ScreenUtil.w(83),
            height: ScreenUtil.h(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        '고객님! 새 카드를 찾으시나요?',
                        style: AppFonts.suit(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textBlack),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil.h(1),
                    ),
                    Container(
                      width: ScreenUtil.w(54),
                      height: ScreenUtil.h(4),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '나에게 맞는 혜택별 알짜카드', // 텍스트
                              style: AppFonts.suit(
                                color: AppColors.subLightBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ), // 텍스트 색상
                            ),
                            Icon(
                              Icons.keyboard_arrow_right_rounded, // 아이콘
                              color: AppColors.mainBlue, // 아이콘 색상
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/images/heart_icon.png',
                  width: ScreenUtil.w(20),
                  height: ScreenUtil.w(20),
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
