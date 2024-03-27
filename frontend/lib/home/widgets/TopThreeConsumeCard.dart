import 'package:flutter/material.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/screen_util.dart';

class TopThreeConsumeCard extends StatelessWidget {
  const TopThreeConsumeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil.h(26),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: const Color(0xFFC5D8FC),
        child: Center(
          child: Container(
            width: ScreenUtil.w(83),
            height: ScreenUtil.h(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '20대 여성이 가장 많이 한 소비',
                  style: AppFonts.suit(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textBlack),
                ),
                Text(
                  'BEST 3',
                  style: AppFonts.suit(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textBlack),
                ),
                Row(children: [
                  Column(
                    children: [
                      SizedBox(width: ScreenUtil.w(24),),
                      Text(
                        '1. 쇼핑',
                        style: AppFonts.suit(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF365592)),
                      ),
                      Text(
                        '2. 쇼핑',
                        style: AppFonts.suit(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF365592)),
                      ),
                      Text(
                        '3. 쇼핑',
                        style: AppFonts.suit(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF365592)),
                      ),
                    ],
                  ),
                  SizedBox(width: ScreenUtil.w(34),),
                  Image.asset(
                    'assets/images/donut_chart_icon.png',
                    width: ScreenUtil.w(24),
                    height: ScreenUtil.w(24),
                    fit: BoxFit.contain,
                  )
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}