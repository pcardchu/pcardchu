import 'package:flutter/material.dart';
import 'package:frontend/user/screens/login_screen.dart';
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

  Future<void> checkToken() async {
    try {
      if(await _kakaoLoginService.checkKakaoSignIn()) {
        _isLoggedIn = true;
      }
    } catch(e) {
      _errorMessage = e.toString();
      print(e);
    }
  }

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

  Future logout(BuildContext context) async{
    _kakaoToken = null;
    _isLoggedIn = false;

    try{
      await UserApi.instance.logout();
      print("카카오 로그아웃");
    } catch (e) {
      print("카카오 로그아웃 실패 : ${e}");
    }

    notifyListeners();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
