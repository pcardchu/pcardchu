import 'package:flutter/material.dart';
import 'package:frontend/user/services/password_service.dart';
import 'package:frontend/utils/crypto_util.dart';


class PasswordProvider with ChangeNotifier {
  String _inputValue = "";
  int _wrongCount = 0;
  String tmpAnswer = "123456";
  List _nums = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  String get inputValue => _inputValue;
  int get wrongCount => _wrongCount;
  List get nums => _nums;

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
          print("비밀번호가 정확합니다.");
          // 정확한 비밀번호 입력 후의 동작
        }
      }

    }
  }

  void shuffleNums(){
    _nums.shuffle();
  }

  void deleteLast() {
    if (_inputValue.isNotEmpty) {
      _inputValue = _inputValue.substring(0, _inputValue.length - 1);
      notifyListeners(); // 상태가 변경되었음을 알림
    }
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
