import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:frontend/card/screens/card_list.dart';

class ToListCard extends StatelessWidget {
  const ToListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil.h(20),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: Color(0xFFFFF7C5),
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '고객님!',
                    style: AppFonts.suit(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textBlack),
                  ),
                  Text(
                    '새 카드를 찾으시나요?',
                    style: AppFonts.suit(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textBlack),
                  ),
                  SizedBox(
                    height: ScreenUtil.h(2),
                  ),
                  Container(
                    width: ScreenUtil.w(53),
                    height: ScreenUtil.h(4),
                    margin: EdgeInsets.only(left: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CardList()));
                      },
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
                width: ScreenUtil.w(16),
                height: ScreenUtil.w(16),
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
