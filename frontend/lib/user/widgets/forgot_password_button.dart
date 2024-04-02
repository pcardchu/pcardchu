import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/crypto_util.dart';
import 'package:provider/provider.dart';

class ForgotPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        // 마스킹 처리된 이메일 주소
        final maskedEmail = CryptoUtil.maskEmail(loginProvider.userEmail);

        // 다이얼로그 띄우기
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppColors.mainWhite,
              title: const Text('비밀번호 초기화'),
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
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Text('아니오', style: TextStyle(color: AppColors.subBlue),),
                ),
                TextButton(
                  onPressed: () async {

                    loginProvider.logout(context);
                    if(await loginProvider.resetPassword()) {
                      print('비밀번호 초기화 성공');
                      const SnackBar(content: Text("메일을 보냈어요!", textAlign: TextAlign.center,));
                    } else {
                      print('비밀번호 초기화 실패');
                      const SnackBar(content: Text("잠시 후 다시 시도해 주세요", textAlign: TextAlign.center,));
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Text('네', style: TextStyle(color: AppColors.subBlue),),
                ),
              ],
            );
          },
        );

      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent, // 배경색
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 8.0), // 아이콘과 텍스트 사이 간격
            Text(
              "비밀번호를 몰라요",
              style: AppFonts.suit(fontWeight: FontWeight.w500, color: AppColors.mainBlue, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
