import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/animations/slide_transition_page_route.dart';
import 'package:frontend/card/screens/card_company_info.dart';
import 'package:frontend/card/widgets/card_company/company_select.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';

// 카드 등록 - 카드사 선택 페이지
class CardCompany extends StatefulWidget {
  const CardCompany({super.key});

  @override
  State<CardCompany> createState() => _CardCompanyState();
}

class _CardCompanyState extends State<CardCompany> {
  // 카드사를 선택 했는지 체크
  bool isSelected = false;

  // 버튼에 들어갈 텍스트
  String btnText = '확인';

  // 버튼 눌렀을때 텍스트 색
  bool isBtnColor = true;

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
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                        SizedBox(height: 50),
                        // 카드사 선택 위젯
                        CompanySelect(
                          isSelected: isSelected,
                          onSelected: onSelected,
                        ),
                      ],
                    ),
                  ),
                  // 하단 확인 버튼
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isBtnColor
                                ? Color(0xff051D40)
                                : AppColors.mainRed,
                          ),
                          onPressed: onPressed,
                          child: Text(
                            btnText,
                            style: AppFonts.suit(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.mainWhite,
                            ),
                          ),
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

  // 카드 회원 정보 입력 페이지로 이동
  void onPressed() {
    // 카드사를 선택했을때만 다음 페이지로 넘어가게
    if (isSelected) {
      Navigator.of(context).push(
        SlideTransitionPageRoute(
          page: const CardCompanyInfo(),
          beginOffset: const Offset(1, 0),
          transitionDuration: const Duration(milliseconds: 350),
          reverseTransitionDuration: const Duration(milliseconds: 350),
        ),
      );
    }
    // 카드를 선택하지 않은 경우
    else {
      setState(() {
        btnText = '선택하세요 !';
        isBtnColor = false;
      });
      // 1초 동안만
      Timer(Duration(seconds: 1), () {
        setState(() {
          btnText = '확인';
          isBtnColor = true;
        });
      });
    }
  }

  // 카드사를 선택했는지 체크하는 변수
  void onSelected() {
    setState(() {
      // 하나라도 선택을 했으니 참
      isSelected = true;
    });
  }
}
