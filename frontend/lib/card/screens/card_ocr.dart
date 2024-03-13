import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:flutter/material.dart';
import 'package:frontend/card/screens/card_number_check.dart';
import 'package:frontend/card/widgets/next_btn.dart';

class CardOcr extends StatefulWidget {
  const CardOcr({super.key});

  @override
  State<CardOcr> createState() => _CardOcrState();
}

class _CardOcrState extends State<CardOcr> {
  /// 스캔한 카드 정보
  CardDetails? _cardDetails;

  /// 카드 정보 입력 Form Key
  final GlobalKey<FormState> formKey = GlobalKey();

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
              children: [
                Expanded(
                  child: SizedBox(),
                ),
                NextBtn(
                  title: '스캔하기',
                  onPressed: scan,
                ),
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
    /// 정상 동작이면 카드 스캔 정보 저장
    if (!mounted || cardDetails == null) return;
    setState(() {
      _cardDetails = cardDetails;
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CardNumberCheck(
          scanNumber: _cardDetails!.cardNumber,
        ),
      ),
    );
  }

  /// 카드 스캔 함수
  void scan() async {
    scanCard();
  }
}
