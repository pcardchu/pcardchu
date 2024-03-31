import 'package:flutter/material.dart';
import 'package:frontend/providers/password_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:provider/provider.dart';

class BiometricSwitch extends StatefulWidget {
  @override
  _BiometricSwitchState createState() => _BiometricSwitchState();
}

class _BiometricSwitchState extends State<BiometricSwitch> {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PasswordProvider>(context);

    return
      InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: provider.isBiometricSupported ? () async {
          // 생체인증 지원시 토글
          provider.toggleBiometricSwitch();
        } : null, // 생체인증 미지원시 onTap 비활성화
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.transparent, // 배경색
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                provider.isBiometricEnableChecked ? Icons.check_box_outlined : Icons.check_box_outline_blank,
                color: provider.isBiometricSupported ? AppColors.mainBlue : AppColors.amazingGrey,
                size: 18,),
              const SizedBox(width: 5.0), // 아이콘과 텍스트 사이 간격
              Text(
                "생체인증 사용",
                style: AppFonts.suit(
                    fontWeight: FontWeight.w500,
                    color: provider.isBiometricSupported ? AppColors.mainBlue : AppColors.amazingGrey,
                    fontSize: 13),
              ),
            ],
          ),
        ),
      );

    //   ListTile(
    //   leading: Icon(_isBiometricEnabled ? Icons.check_circle : Icons.cancel, color: Colors.blue),
    //   title: const Text('생체인증 사용', style: TextStyle(fontSize: 20)),
    //   trailing: Switch(
    //     value: _isBiometricEnabled,
    //     onChanged: (value) {
    //       setState(() {
    //         _isBiometricEnabled = value;
    //         // 여기서 생체인증 사용 설정을 저장하는 로직을 추가하세요.
    //         // 예를 들어, SharedPreferences를 사용하여 설정을 저장할 수 있습니다.
    //       });
    //     },
    //   ),
    //   onTap: () {
    //     setState(() {
    //       _isBiometricEnabled = !_isBiometricEnabled;
    //       // 생체인증 사용 설정을 변경하는 로직을 추가하세요.
    //     });
    //   },
    // );
  }
}
