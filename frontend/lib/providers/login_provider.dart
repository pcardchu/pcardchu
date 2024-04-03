import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/animations/slide_transition_page_route.dart';
import 'package:frontend/user/models/jwt_token.dart';
import 'package:frontend/user/models/login_response.dart';
import 'package:frontend/user/models/second_jwt_response.dart';
import 'package:frontend/user/screens/login_screen.dart';
import 'package:frontend/user/services/kakao_login_service.dart';
import 'package:frontend/user/services/token_service.dart';
import 'package:frontend/utils/crypto_util.dart';
import 'package:frontend/utils/dio_util.dart';
import 'package:frontend/utils/first_dio_util.dart';
import 'package:frontend/utils/logout_util.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class LoginProvider with ChangeNotifier {
  final KakaoLoginService _kakaoLoginService = KakaoLoginService();
  final TokenService _tokenService = TokenService();

  String _profileImageUrl = '';
  String _userEmail = '';
  int _userId = 0;

  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;
  bool _isFirst = false;

  JwtToken? _firstJwt;
  JwtToken? _secondJwt;
  OAuthToken? _kakaoToken;

  String get userEmail => _userEmail;
  String get profileImageUrl => _profileImageUrl;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  bool get isFirst => _isFirst;
  int get userId => _userId;

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
      _userId = CryptoUtil.extractIdFromAccessToken(_firstJwt!.accessToken!)!;
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

  Future<void> loadUserProfile() async {
    try {
      // 카카오 사용자 API 호출
      User user = await UserApi.instance.me();
      // 프로필 이미지 URL을 상태 변수에 저장
      _profileImageUrl = user.kakaoAccount?.profile?.thumbnailImageUrl ?? '';
      _userEmail = user.kakaoAccount!.email!;
      // 상태 변경 알림
      notifyListeners();
    } catch (error) {
      // 에러 처리
      print("프로필 이미지 로드 실패: $error");
      _profileImageUrl = '';
      notifyListeners();
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
    SecondJwtResponse responseData = await _tokenService.secondJwtRequestWithPassword(digest);

    return responseData;
  }

  Future<bool> loginWithBiometric() async {
    JwtToken result = await _tokenService.secondJwtRequestWithBiometric();

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

      FirstDioUtil().setAccessToken(_firstJwt!.accessToken!);

      _userId = CryptoUtil.extractIdFromAccessToken(_firstJwt!.accessToken!)!;

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

  Future<bool> resetPassword() async {
    Dio firstDio = FirstDioUtil().dio;

    print('비밀번호 초기화 시도 : $_userEmail');

    try {
      await firstDio.get('/user/login/temp');

      return true;
    } catch(e) {
      print('비밀번호 초기화 오류 : $e');
      return false;
    }
  }

  Future logout(BuildContext context) async{
    try{
      LogoutUtil.resetAllProviders(context);

      print("로그아웃");
    } catch (e) {
      print("로그아웃 실패 : ${e}");
    }

    notifyListeners();
    Navigator.pushAndRemoveUntil(
        context,
        SlideTransitionPageRoute(page: LoginScreen(), beginOffset: const Offset(-1, 0)),
        (Route<dynamic> route) => false,
    );
  }

  Future<bool> changePW(String pw) async {
    Dio _dio = DioUtil().dio;

    try {
      _dio.patch('/user/short-pw',
          data: {"password" : pw}
      );
      print('비밀번호 변경 성공');
      return true;
    } catch(e) {
      print('비밀번호 변경 오류 : $e');
    }

    return false;
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

  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _isLoggedIn = false;
    _isFirst = false;
    _firstJwt = null;
    _secondJwt = null;
    _kakaoToken = null;
    UserApi.instance.logout();
  }
}
