import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';

import '../../utils/app_fonts.dart';

class ResetPasswordDialog extends StatelessWidget {
  final BuildContext context;
  final String maskedEmail;
  final Function onConfirm;

  const ResetPasswordDialog({
    Key? key,
    required this.context,
    required this.maskedEmail,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, // AppColors.mainWhite 대신 사용
      title: const Text('비밀번호가 초기화됩니다'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('비밀번호를 초기화하고',
              style: AppFonts.suit(color: AppColors.mainBlue, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 3,),
            Text('$maskedEmail',
              style: AppFonts.suit(color: AppColors.mainBlue, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 3,),
            Text('(으)로 전송하겠습니다.',
              style: AppFonts.suit(color: AppColors.mainBlue, fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: TextButton.styleFrom(backgroundColor: Colors.transparent),
          child: const Text('학인', style: TextStyle(color: Colors.blue)), // AppColors.subBlue 대신 사용
        ),
      ],
    );
  }

}
