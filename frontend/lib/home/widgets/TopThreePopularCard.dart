import 'package:flutter/material.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/screen_util.dart';

class TopThreePopularCard extends StatelessWidget {
  const TopThreePopularCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil.h(26),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: const Color(0xFFF7D6F0),
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '30대 남성이 선호하는 카드',
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      Text(
                        '1. 신한 xx 카드',
                        style: AppFonts.suit(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFA0478B)),
                      ),
                      Text(
                        '2. 신한 xx 카드',
                        style: AppFonts.suit(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFA0478B)),
                      ),
                      Text(
                        '3. 신한 xx 카드',
                        style: AppFonts.suit(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFA0478B)),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/medal_icon.png',
                  width: ScreenUtil.w(21),
                  height: ScreenUtil.w(21),
                  fit: BoxFit.contain,
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
