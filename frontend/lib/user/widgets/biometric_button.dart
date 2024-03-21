import 'package:flutter/material.dart';
import 'package:frontend/providers/password_provider.dart';
import 'package:frontend/user/services/local_auth_service.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:provider/provider.dart';

class BiometricButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localAuthService = LocalAuthService();
    final provider = Provider.of<PasswordProvider>(context, listen: false);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        if(await localAuthService.isBiometricSupported()) {
          final authenticated = await localAuthService.authenticateWithBiometrics('로그인을 위해 생체인증을 진행해 주세요.');
          if (authenticated) {
            // 생체인증에 성공한 경우, 다음 화면으로 이동
            provider.changeAuthenticated(true);
            provider.notifyListeners();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("생체인증을 사용할 수 없습니다.")));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent, // 배경색
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.fingerprint, color: AppColors.mainBlue, size: 18,),
            SizedBox(width: 5.0), // 아이콘과 텍스트 사이 간격
            Text(
              "생체인증",
              style: AppFonts.suit(fontWeight: FontWeight.w500, color: AppColors.mainBlue, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
