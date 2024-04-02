import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';

class NoMainConsumption extends StatelessWidget {
  const NoMainConsumption({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 50),
          SizedBox(
              height: 120,
              child: Image.asset('assets/images/xox_logo.png')),
          SizedBox(height: 20),
          Text('이번달 소비 내역이 없어요 !',
          style: AppFonts.scDream(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textBlack,
          ),),
        ],
      ),
    );
  }
}
