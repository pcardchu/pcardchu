import 'package:flutter/material.dart';
import 'package:frontend/user/services/kakao_login_service.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;
  OAuthToken? _kakaoToken;


  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  final KakaoLoginService _kakaoLoginService = KakaoLoginService();

  Future<void> login() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _kakaoToken = await _kakaoLoginService.signInWithKakao();
      _isLoggedIn = true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _kakaoToken = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
