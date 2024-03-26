import 'package:flutter/material.dart';
import 'package:frontend/animations/slide_transition_page_route.dart';
import 'package:frontend/user/models/login_response.dart';
import 'package:frontend/user/screens/login_screen.dart';
import 'package:frontend/user/services/kakao_login_service.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;
  OAuthToken? _kakaoToken;
  bool _isFirst = false;

  String? _firstJwt;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  bool get isFirst => _isFirst;

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

      LoginResponse? loginResponse = await _kakaoLoginService.sendFirstJwtRequest(_kakaoToken!!);
      _isFirst = loginResponse!.isFirst!;
      _firstJwt = loginResponse.token;

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
    Navigator.pushReplacement(context, SlideTransitionPageRoute(page: LoginScreen(), beginOffset: Offset(-1, 0)));
  }
}
