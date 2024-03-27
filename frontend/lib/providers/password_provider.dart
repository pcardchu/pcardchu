import 'package:flutter/material.dart';
import 'package:frontend/user/services/local_auth_service.dart';
import 'package:frontend/user/services/password_service.dart';
import 'package:frontend/utils/crypto_util.dart';

///비밀번호 처리 프로바이더
class PasswordProvider with ChangeNotifier {
  //생체인증 관련
  final LocalAuthService _localAuthService = LocalAuthService();
  bool _isBiometricEnabled = false;
  bool _isAuthenticated = false;
  bool _isNumpad = false;

  String _inputValue = "";
  int _wrongCount = 0;
  String tmpAnswer = "000000";
  List _nums = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  // 생체 인증 로그인이 활성화되어 있는지 확인하는 Getter
  bool get isBiometricEnabled => _isBiometricEnabled;
  // 사용자가 인증되었는지 확인하는 Getter
  bool get isAuthenticated => _isAuthenticated;
  // numpad 활성화 여부
  bool get isNumpad => _isNumpad;

  String get inputValue => _inputValue;
  int get wrongCount => _wrongCount;
  List get nums => _nums;

  // 생성자에서 사용자의 생체 인증 설정을 로드
  LoginProvider() {
    loadBiometricEnabled();
  }

  // 사용자의 생체 인증 로그인 설정을 로드
  Future<void> loadBiometricEnabled() async {
    _isBiometricEnabled = await _localAuthService.isBiometricEnabled();
    notifyListeners();
  }

  void changeAuthenticated(bool authentication){
    _isAuthenticated = authentication;
    // notifyListeners();
  }

  // 사용자의 생체 인증 로그인 설정을 업데이트
  Future<void> updateBiometricEnabled(bool enabled) async {
    await _localAuthService.setBiometricEnabled(enabled);
    _isBiometricEnabled = enabled;
    notifyListeners();
  }

  // 생체 인증을 사용하여 로그인 시도
  Future<void> authenticateWithBiometrics() async {
    if (await _localAuthService.isBiometricSupported()) {
      _isAuthenticated = await _localAuthService.authenticateWithBiometrics(
          '로그인을 위해 생체 인증을 사용하세요.');
      notifyListeners();
    }
  }

  void addNumber(int number) {
    if (_inputValue.length < 6) { // 최대 6자리 숫자까지 입력 가능
      _inputValue += number.toString();
      notifyListeners(); // 상태가 변경되었음을 알림

      // 비밀번호 길이가 6자리가 되었을 때의 로직
      if (_inputValue.length == 6) {
        // _inputValue
        String digest = CryptoUtil.hashPassword(_inputValue, "1234");
        // print("입력값 : ${_inputValue}, 해싱 : ${digest}");
        if (!checkPassword()) {
          _wrongCount++;
          notifyListeners();

          if (_wrongCount >= 5) {
            // wrongCount가 6이 되었을 때의 처리 로직
            // 예: 사용자에게 경고 메시지를 보여주기
            // 추가적인 사용자 조치를 여기서 취할 수 있습니다.
            print("비밀번호 입력 시도 횟수 초과");
            // clearInput(); // 비밀번호 입력 필드 초기화
            clearWrongCount(); // wrongCount 초기화
            // 필요한 경우, 사용자에게 경고 메시지를 보여주는 등의 UI 업데이트
          }
        } else {
          // 정확한 비밀번호 입력 후의 동작
          _isAuthenticated = true;
          print("비밀번호가 정확합니다.");
        }
      }
    }
  }

  void shuffleNums(){
    _nums.shuffle();
    notifyListeners();
  }

  void deleteLast() {
    if (_inputValue.isNotEmpty) {
      _inputValue = _inputValue.substring(0, _inputValue.length - 1);
      notifyListeners(); // 상태가 변경되었음을 알림
    }
  }

  void clearAll(){
    _inputValue = "";
    _wrongCount = 0;
  }

  void clearInput() {
    _inputValue = "";
    notifyListeners(); // 상태가 변경되었음을 알림
  }

  void clearWrongCount() {
    _wrongCount = 0;
    notifyListeners();
  }

  bool checkPassword() {
    return _inputValue == tmpAnswer;
  }



}