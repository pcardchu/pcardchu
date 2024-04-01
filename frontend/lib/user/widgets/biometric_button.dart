import 'package:flutter/material.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:frontend/providers/password_provider.dart';
import 'package:frontend/user/services/local_auth_service.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:provider/provider.dart';

class BiometricButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final passwordProvider = Provider.of<PasswordProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);

    return IconButton(
      icon: const Icon(Icons.fingerprint,),
      onPressed: () async {
        if(passwordProvider.isBiometricEnabled && passwordProvider.isBiometricSupported) {
          // final authenticated = await localAuthService.authenticateWithBiometrics('로그인을 위해 생체인증을 진행해 주세요.');
          // provider.authenticateWithBiometrics();
          if (await passwordProvider.authenticateWithBiometrics()) {
            if(await loginProvider.loginWithBiometric()){
              passwordProvider.isAuthenticated = true;
            } else {
              loginProvider.logout(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("다시 로그인해 주세요")));
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("생체인증을 사용할 수 없습니다."),
                duration: Duration(milliseconds: 500),
              )
          );
        }
      },
      style: TextButton.styleFrom(
          foregroundColor: AppColors.mainBlue,
          textStyle: AppFonts.suit(fontSize: 20, fontWeight: FontWeight.w600),
          backgroundColor: Colors.transparent
      ),
    );
  }
}
