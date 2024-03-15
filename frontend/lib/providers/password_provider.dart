import 'package:flutter/material.dart';
import 'package:frontend/user/services/password_service.dart';


class PasswordProvider with ChangeNotifier {
  String _inputValue = "";
  String tmpAnswer = "123456";

  String get inputValue => _inputValue;

  void addNumber(int number) {
    if (_inputValue.length < 6) { // 최대 6자리 숫자까지 입력 가능
      _inputValue += number.toString();
      notifyListeners(); // 상태가 변경되었음을 알림
    }
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

  bool checkPassword() {
    return _inputValue == tmpAnswer;
  }
}
