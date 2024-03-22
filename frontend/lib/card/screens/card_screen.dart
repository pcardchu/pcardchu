import 'package:flutter/material.dart';
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
    // TODO: implement initState
    super.initState();
    showInitialDialog(); // 조건에 따라 다이얼로그 호출
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainWhite,
      ),
      backgroundColor: AppColors.mainWhite,
      body: Center(child: Container()),
    );
  }

  void showInitialDialog() {
    if (widget.myCardFlag == 0) {
      // 조건 체크 후에
      WidgetsBinding.instance.addPostFrameCallback((_) => _showDialog());
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return const RegistrationModal();
      },
    );
  }
}
