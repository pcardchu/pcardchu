import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/card_registration_bottom.dart';
import 'package:frontend/card/widgets/card_registration_main.dart';
import 'package:frontend/card/widgets/next_btn.dart';

class CardRegistration extends StatefulWidget {
  const CardRegistration({super.key});

  @override
  State<CardRegistration> createState() => _CardRegistrationState();
}

class _CardRegistrationState extends State<CardRegistration> {
  // 스캔한 카드 정보
  CardDetails? _cardDetails;

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
        leading: IconButton(
          icon: Image.asset('assets/images/back_icon.png'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 메인 바디 위젯
              CardRegistrationMain(),
              // 다음 버튼 위젯
              NextBtn(
                title: '등록하기',
                onPressed: btnOnPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 바텀시트를 호출하는 함수입니다.
  btnOnPressed() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) {
        return CardRegistrationBottom();
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }
}
