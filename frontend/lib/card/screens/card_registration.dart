import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:flutter/material.dart';
import 'package:frontend/card/screens/card_number_check.dart';
import 'package:frontend/card/widgets/card_registration/card_registration_main.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:provider/provider.dart';

import 'package:frontend/home/screens/bottom_nav_screen.dart';

class CardRegistration extends StatefulWidget {
  final bool fromDialog;

  const CardRegistration({super.key, this.fromDialog = false});

  @override
  State<CardRegistration> createState() => _CardRegistrationState();
}

class _CardRegistrationState extends State<CardRegistration> {
  // 카드 정보 입력 Form Key
  final GlobalKey<FormState> formKey = GlobalKey();

  // 카드 번호 값
  String? inputNumber;

  // 스캔값 자동 입력을 위한 컨트롤러
  var numCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: AppColors.mainWhite,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            if(widget.fromDialog){
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => BottomNavScreen()),
                    (Route<dynamic> route) => false, // 모든 이전 라우트를 제거할 때 사용
              );
            }else {
              Navigator.of(context).pop();
            }
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
                  // 메인 바디 위젯
                  CardRegistrationMain(),
                  // 다음 버튼 위젯
                  Row(
                    children: [
                      Expanded(
                        // 스캔하기 버튼
                        // 누르면 Ocr로 이동
                        child: ElevatedButton(
                          onPressed: scan,
                          child: Text('스캔하기'),
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
    // 스캔한 카드 정보의 모음
    final CardDetails? cardDetails =
        await CardScanner.scanCard(scanOptions: scanOptions);

    // 정상 동작이면 카드 스캔 정보 저장
    if (!mounted || cardDetails == null) return;

    // 0000-0000-0000-0000 형식으로 만들기
    String cardNumber = cardDetails.cardNumber
        .replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)}-");

    // 마지막 '-' 제거
    cardNumber = cardNumber.substring(0, cardNumber.length - 1);

    // 프로바이더 카드 스캔 넘버 갱신
    context.read<CardProvider>().setScanNumber(cardNumber);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CardNumberCheck(
          scan: scan,
        ),
      ),
    );
  }

  /// 카드 스캔 함수
  void scan() async {
    scanCard();
  }
}
