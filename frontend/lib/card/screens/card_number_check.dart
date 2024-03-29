import 'package:flutter/material.dart';
import 'package:frontend/animations/slide_transition_page_route.dart';
import 'package:frontend/card/screens/card_company.dart';
import 'package:frontend/card/widgets/card_form.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:provider/provider.dart';

// 스캔한 번호가 맞는지 체크하는 화면
class CardNumberCheck extends StatefulWidget {
  // 스캔 화면을 호출하는 함수
  final Function scan;

  const CardNumberCheck({
    super.key,
    required this.scan,
  });

  @override
  State<CardNumberCheck> createState() => _CardNumberCheckState();
}

class _CardNumberCheckState extends State<CardNumberCheck> {
  // 카드 정보 입력 Form Key
  final GlobalKey<FormState> formKey = GlobalKey();

  // 카드 번호 텍스트창 값
  String? cardInputNumber;

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
            Navigator.pop(context); // 전전 페이지로 이동
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '카드 정보가 맞는지 확인해주세요',
                        style: AppFonts.suit(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: CardForm(
                      formKey: formKey,
                      onCardNumSaved: onCardNumSaved,
                      cardInputNumber: cardInputNumber,
                    ),
                  ),
                  // 스캔 화면으로 돌아가는 버튼
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainRed,
                          ),
                          onPressed: () {
                            widget.scan();
                          },
                          child: Text('카드 번호가 달라요'),
                        ),
                      ),
                    ],
                  ),
                  // 다음 페이지로 넘어가는 버튼
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: submitOnPressed,
                          child: Text('일치합니다'),
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

  /// 제출 버튼을 눌렀을때 텍스트창의 카드 번호 입력 정보를 저장하는 함수
  void onCardNumSaved(String? val) {
    context.read<CardProvider>().setScanNumber(val!);
    // 상태값이 남아있으면 나중에 들어갔을때 자동으로 선택되어있는 상황이 생기니 초기화
    context.read<CardProvider>().setCompanyIndex(-1);
  }

  /// 제출 버튼 콜백함수
  void submitOnPressed() {
    /// 유효성 검증을 통과 하면
    /// TextFormField의 onSaved 수행
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // 다음 카드사 입력 페이지로 이동
      Navigator.of(context).push(
          SlideTransitionPageRoute(
              page: const CardCompany(),
              beginOffset: const Offset(1, 0),
              transitionDuration: const Duration(milliseconds: 350),
              reverseTransitionDuration: const Duration(milliseconds: 350)
          )
        // MaterialPageRoute(
        //   builder: (_) => CardCompany(),
        // ),
      );
    }
  }
}
