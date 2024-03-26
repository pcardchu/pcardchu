import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';

class ConsumeDifferCard extends StatelessWidget {
  const ConsumeDifferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil.h(26),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: Color(0xFFC2F4D8),
        child: Center(
          child: Container(
            width: ScreenUtil.w(83),
            height: ScreenUtil.h(26),
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
                          '내 또래의 여성들은',
                          style: AppFonts.suit(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textBlack),
                        ),
                        Text(
                          '2월에 얼마나 썼을까?',
                          style: AppFonts.suit(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textBlack),
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/images/card_graph_icon.png',
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
                          '박설연님은 20대 여성에 비해',
                          style: AppFonts.suit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF61806F)),
                        ),
                        Text(
                          '평균 xx% 적게 소비하고 있어요.',
                          style: AppFonts.suit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF61806F)),
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
