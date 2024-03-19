import 'dart:async';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

///생체인증 관리 서비스
class LocalAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  // 장치가 생체 인증을 지원하는지 확인
  Future<bool> isBiometricSupported() async {
    return await _auth.isDeviceSupported();
  }

  // 사용자의 생체 인증 로그인 설정을 로드
  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('biometric_login') ?? false;
  }

  // 사용자의 생체 인증 로그인 설정을 저장
  Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_login', enabled);
  }

  // 생체 인증을 사용하여 인증 시도
  Future<bool> authenticateWithBiometrics(String localizedReason) async {
    print("생체인증 시도");
    try {
      return await _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } on PlatformException {
      return false;
    }
  }
}
