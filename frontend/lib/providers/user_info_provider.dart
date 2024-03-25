import 'package:flutter/foundation.dart';

class UserInfoProvider with ChangeNotifier {
  String _year = '';
  String _month = '';
  String _day = '';
  String _gender = '';

  String get year => _year;
  String get month => _month;
  String get day => _day;
  String get gender => _gender;

  set year(String newValue) {
    _year = newValue;
    notifyListeners();
  }

  set month(String newValue) {
    _month = newValue;
    notifyListeners();
  }

  set day(String newValue) {
    _day = newValue;
    notifyListeners();
  }

  set gender(String newValue) {
    _gender = newValue;
    notifyListeners();
  }

  bool get isAllFieldsFilled =>
      _year.isNotEmpty && _month.isNotEmpty && _day.isNotEmpty && _gender.isNotEmpty;
}
