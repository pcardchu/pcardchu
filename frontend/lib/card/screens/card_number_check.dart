import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/card_form.dart';

class CardNumberCheck extends StatefulWidget {
  /// 카드 스캔 번호
  final String scanNumber;

  const CardNumberCheck({
    super.key,
    required this.scanNumber,
  });

  @override
  State<CardNumberCheck> createState() => _CardNumberCheckState();
}

class _CardNumberCheckState extends State<CardNumberCheck> {
  /// 카드 정보 입력 Form Key
  final GlobalKey<FormState> formKey = GlobalKey();

  /// 카드 번호 텍스트창 값
  String? cardInputNumber;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'SUIT',
      ),
      home: Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CardForm(
                    formKey: formKey,
                    onCardNumSaved: onCardNumSaved,
                    scanNumber: widget.scanNumber,
                    cardInputNumber: cardInputNumber,
                  ),
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
}
