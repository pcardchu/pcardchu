import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';

class CardCompany extends StatelessWidget {
  const CardCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Color(0xFFF5F5F5),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context); // 이전 페이지로 이동
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Color(0xFFF5F5F5),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '카드사를 선택해주세요',
                      style: AppFonts.suit(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBlack,
                      ),
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
