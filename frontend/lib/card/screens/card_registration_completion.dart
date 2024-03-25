import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/home/screens/home_screen.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';

/// 카드 등록 완료 화면입니다.
class CardRegistrationCompletion extends StatelessWidget {
  const CardRegistrationCompletion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: AppColors.mainWhite,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context); // 이전 페이지로 이동
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          color: AppColors.mainWhite,
          child: Center(
            child: Container(
              color: AppColors.mainWhite,
              width: ScreenUtil.w(85),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 185,
                          height: 185,
                          child: Image.asset('assets/images/complete.png'),
                        ),
                        const SizedBox(height: 45),
                        Text(
                          '카드 등록이 완료되었어요 !',
                          style: AppFonts.scDream(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlack,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  // 확인 버튼
                  // 눌렀을떄 홈화면으로 돌아가기
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => HomeScreen(),
                                ),
                                (route) => false);
                          },
                          child: const Text('확인'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
