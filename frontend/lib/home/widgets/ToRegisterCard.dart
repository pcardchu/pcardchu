import 'package:flutter/material.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:frontend/card/screens/card_registration.dart';

class ToRegisterCard extends StatelessWidget {
  const ToRegisterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil.h(16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: Color(0xFFFCDABC),
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  '카드를 등록해주세요',
                  style: AppFonts.suit(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textBlack),
                ),
              ),

              Text(
                '카드를 등록하시면 더 많은 정보를 알 수 있어요',
                style: AppFonts.suit(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFCA9059)),
              ),
              SizedBox(height: ScreenUtil.h(2),),
              Container(
                width: ScreenUtil.w(56),
                height: ScreenUtil.h(4),
                margin: EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CardRegistration()));
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
                        '카드 등록하러 가기', // 텍스트
                        style: AppFonts.suit(
                          color: AppColors.mainGreen,
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
        ),
      ),
    );
  }
}
