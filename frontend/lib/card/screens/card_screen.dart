import 'package:flutter/material.dart';
import 'package:frontend/card/screens/card_storage.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/card/widgets/registration_modal.dart';

class CardScreen extends StatefulWidget {
  final int? myCardFlag;

  const CardScreen({super.key, required this.myCardFlag});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 초기화 시 다이얼로그 조건 체크
    if (widget.myCardFlag == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showDialog());
    }
  }

  @override
  Widget build(BuildContext context) {
    // myCardFlag 값에 따라 화면에 보여줄 내용 결정
    Widget content = widget.myCardFlag == 1
        ? const CardStorage()
        : Center(child: Container()); // myCardFlag가 0일 경우, 다이얼로그가 띄워집니다.

    return Scaffold(
      // 앱바 없애놓기
      backgroundColor: AppColors.mainWhite,
      body: content,
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const RegistrationModal(),
    ).then((_) {
      // 다이얼로그가 닫히고 나면 상태 업데이트를 위해 setState 호출
      setState(() {});
    });
  }
}
