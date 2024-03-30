import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';

class NoCardNotice extends StatelessWidget {
  const NoCardNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/no_card_icon.png',),
            SizedBox(height: 40),
            Text('소비패턴을', style: AppFonts.scDream(fontWeight: FontWeight.w700, fontSize: 28, color: AppColors.textBlack),),
            Text('불러올 수 없습니다', style: AppFonts.scDream(fontWeight: FontWeight.w700, fontSize: 28, color: AppColors.textBlack),),
            SizedBox(height: 12),
            Text('카드를 등록하셨나요?', style: AppFonts.suit(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.lightGrey),),
            SizedBox(height: 60),

          ],
        ),
      ),
    );
  }
}
