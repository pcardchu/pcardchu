import 'package:flutter/material.dart';
import 'package:frontend/animations/slide_transition_page_route.dart';
import 'package:frontend/user/models/jwt_token.dart';
import 'package:frontend/user/models/login_response.dart';
import 'package:frontend/user/screens/login_screen.dart';
import 'package:frontend/user/services/kakao_login_service.dart';
import 'package:frontend/user/services/token_service.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;
  bool _isFirst = false;

  JwtToken? _firstJwt;
  JwtToken? _secondJwt;
  OAuthToken? _kakaoToken;


  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  bool get isFirst => _isFirst;

  final KakaoLoginService _kakaoLoginService = KakaoLoginService();
  final TokenService _tokenService = TokenService();

  Future<void> checkToken() async {
    try {
      _firstJwt = await _tokenService.getFirstToken();

      if(await _kakaoLoginService.checkKakaoSignIn() && _firstJwt != null) {
        _isLoggedIn = true;
      }
    } catch(e) {
      _errorMessage = e.toString();
      print(e);
    }
  }

  Future<bool> login() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _kakaoToken = await _kakaoLoginService.signInWithKakao();
      _isLoggedIn = true;

      LoginResponse? loginResponse = await _tokenService.firstJwtRequest(_kakaoToken!!);
      _isFirst = loginResponse!.isFirst!;
      _firstJwt = JwtToken.fromLoginResponse(loginResponse, true);

      _tokenService.saveFirstToken(_firstJwt!);
    } catch (e) {
      _errorMessage = e.toString();
      _isLoggedIn = false;

      try {
        await UserApi.instance.logout();
        print("토큰 폐기됨");
      } catch (error) {
        print("로그아웃 실패: $error");
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return true;
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

  Future<bool> registration(var data) async {
    try {
      print(data);
      print(_firstJwt?.accessToken);
      bool? result = await _tokenService.registrationRequest(_firstJwt!, data['gender'], data['shortPw'], data['birth']);

      return result!;
    } catch(e) {
      print("회원가입 실패 : $e");
      return false;
    } finally {
      print("회원가입 end");
    }
  }
}
