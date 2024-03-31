import 'package:flutter/material.dart';
import 'package:frontend/animations/slide_transition_page_route.dart';
import 'package:frontend/user/models/jwt_token.dart';
import 'package:frontend/user/models/login_response.dart';
import 'package:frontend/user/models/second_jwt_response.dart';
import 'package:frontend/user/screens/login_screen.dart';
import 'package:frontend/user/services/kakao_login_service.dart';
import 'package:frontend/user/services/token_service.dart';
import 'package:frontend/utils/dio_util.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class LoginProvider with ChangeNotifier {
  final KakaoLoginService _kakaoLoginService = KakaoLoginService();
  final TokenService _tokenService = TokenService();

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

  set isFirst(bool newValue) {
    _isFirst = newValue;
    notifyListeners();
  }

  set secondJwt(JwtToken newValue) {
    _secondJwt = newValue;
    DioUtil().setAccessToken(_secondJwt!.accessToken!);
    notifyListeners();
  }

  Future<void> saveFirstJwt() async {
    _tokenService.saveFirstToken(_firstJwt!);
  }

  Future<void> saveSecondJwt() async {
    await _tokenService.saveSecondToken(_secondJwt!);
  }

  Future<bool> getFirstJwt() async {
    _firstJwt = await _tokenService.getFirstToken();

    if (_firstJwt == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> getSecondJwt() async {
    _secondJwt = await _tokenService.getSecondToken();

    if (_secondJwt == null) {
      return false;
    } else {
      return true;
    }
  }

  deleteFirstJwt() {
    _tokenService.deleteFirstToken();
    _firstJwt = null;
  }

  deleteSecondJwt() {
    _tokenService.deleteSecondToken();
    _secondJwt = null;
  }

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

  Future<SecondJwtResponse?> checkPassword(String digest) async {
    SecondJwtResponse responseData = await _tokenService.secondJwtRequestWithPassword(digest, _firstJwt!);

    return responseData;
  }

  Future<bool> loginWithBiometric() async {
    JwtToken result = await _tokenService.secondJwtRequestWithBiometric(_firstJwt!);

    if(result.accessToken != null){
      secondJwt = result;
      return true;
    }

    return false;
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

      if(!_isFirst) { //첫 로그인이 아니라면 바로 토큰 로컬에 저장
        saveFirstJwt();
      } else {

      }

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
      //토큰 삭제
      await UserApi.instance.logout();
      deleteFirstJwt();
      deleteSecondJwt();

      print("카카오 로그아웃");
    } catch (e) {
      print("카카오 로그아웃 실패 : ${e}");
    }

    notifyListeners();
    Navigator.pushReplacement(context, SlideTransitionPageRoute(page: LoginScreen(), beginOffset: const Offset(-1, 0)));
  }

  Future<String> registration(var data) async {
    String? result;
    try {
      print(data);
      print(_firstJwt?.accessToken);
      result = await _tokenService.registrationRequest(_firstJwt!, data['gender'], data['shortPw'], data['birth']);

      return result!;
    } catch(e) {
      print("회원가입 실패 : $e");
      return result!;
    } finally {
      print("회원가입 end");
    }
  }

  Future<bool> updateBiometricToServer(bool value) async {
    if(await _tokenService.updateBiometricToServer(value, _secondJwt!)) {
      return true;
    } else {
      return false;
    }
  }
}
