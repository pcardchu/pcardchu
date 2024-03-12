import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/card_form.dart';

class CardRegistration extends StatefulWidget {
  const CardRegistration({super.key});

  @override
  State<CardRegistration> createState() => _CardRegistrationState();
}

class _CardRegistrationState extends State<CardRegistration> {
  /// 스캔한 카드 정보
  CardDetails? _cardDetails;

  /// 카드 정보 입력 Form Key
  final GlobalKey<FormState> formKey = GlobalKey();

  /// 카드 번호 값
  String? inputNumber;

  /// 스캔값 자동 입력을 위한 컨트롤러
  var numCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// 카드 정보 입력 Form
                CardForm(
                  numCtrl: numCtrl,
                  formKey: formKey,
                  onCardNumSaved: onCardNumSaved,
                ),

                /// 카드 스캔 버튼
                MaterialButton(
                  color: Colors.blue,
                  onPressed: scan,
                  child: const Text('카드 스캔'),
                ),

                /// 스캔 결과 확인용
                Text('스캔 결과 : $_cardDetails'),

                /// 제출 결과 확인용
                Text('제출 결과 : $inputNumber'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 카드 스캔 설정 함수
  /// 지금은 기본 설정
  CardScanOptions scanOptions = const CardScanOptions(
    scanCardHolderName: true,
    validCardsToScanBeforeFinishingScan: 5,
    possibleCardHolderNamePositions: [
      CardHolderNameScanPosition.aboveCardNumber,
    ],
  );

  /// 스캐너 함수
  Future<void> scanCard() async {
    final CardDetails? cardDetails =
        await CardScanner.scanCard(scanOptions: scanOptions);
    if (!mounted || cardDetails == null) return;
    setState(() {
      _cardDetails = cardDetails;
      numCtrl.text = _cardDetails!.cardNumber;
    });
  }

  /// 카드 스캔 함수
  void scan() async {
    scanCard();
  }

  /// 제출 버튼이 눌렸을떄 카드 번호 텍스트창 값을 저장하는 함수
  void onCardNumSaved(String? val) {
    setState(() {
      inputNumber = val;
    });
  }
}
