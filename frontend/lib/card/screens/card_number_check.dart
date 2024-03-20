import 'package:flutter/material.dart';
import 'package:frontend/card/screens/card_company.dart';
import 'package:frontend/card/widgets/card_form.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';

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
        backgroundColor: Color(0xFFF5F5F5),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 제출 버튼을 눌렀을때 카드 번호 입력 정보를 저장하는 콜백
  void onCardNumSaved(String? val) {
    setState(() {
      cardInputNumber = val;
    });
  }

  /// 제출 버튼 콜백함수
  void submitOnPressed() {
    /// 유효성 검증을 통과 하면
    /// TextFormField의 onSaved 수행
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // 다음 카드사 입력 페이지로 이동
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CardCompany(),
        ),
      );
    }
  }
}
