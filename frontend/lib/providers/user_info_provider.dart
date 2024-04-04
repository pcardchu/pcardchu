import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/user/models/user_info.dart';
import 'package:frontend/user/services/user_service.dart';
import 'package:frontend/utils/crypto_util.dart';

class UserInfoProvider with ChangeNotifier {
  final UserService _userService = UserService();

  final isNumeric = RegExp(r'^[0-9]+$');

  String _newUserName = '';
  DateTime _newBirthDay = DateTime.now(); // DateTime 타입으로 선언
  bool _newBio = false; // bool 타입으로 선언
  String _newGender = '';

  String _userName = '';
  String _birthDay = '';
  bool _isBiometric = false;

  String _year = '';
  String _month = '';
  String _day = '';
  String _gender = '';
  bool _isWrongDate = false;
  bool _isSix = false;

  String _password = '';
  String _passwordSubmit = '';

  bool get isBiometric => _isBiometric;
  String get userName => _userName;
  String get birthDay => _birthDay;
  String get year => _year;
  String get month => _month;
  String get day => _day;
  String get gender => _gender;
  bool get isWrongDate => _isWrongDate;

  String get password => _password;
  String get passwordSubmit => _passwordSubmit;
  bool get isSix => _isSix;

  String get newUserName => _newUserName;
  set newUserName(String value) {
    _newUserName = value;
    notifyListeners();
  }

  DateTime get newBirthDay => _newBirthDay;
  set newBirthDay(DateTime value) {
    _newBirthDay = value;
    notifyListeners();
  }

  bool get newBio => _newBio;
  set newBio(bool value) {
    _newBio = value;
    notifyListeners();
  }

  String get newGender => _newGender;
  set newGender(String value) {
    _newGender = value;
    notifyListeners();
  }

  set isBiometric(bool newValue) {
    _isBiometric = newValue;
    notifyListeners();
  }

  set birthDay(String newValue) {
    _birthDay = newValue;
    notifyListeners();
  }

  set userName(String newValue) {
    _userName = newValue;
    notifyListeners();
  }

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

  set password(String newValue) {
    _password = newValue;
    notifyListeners();
  }

  set passwordSubmit(String newValue) {
    _passwordSubmit = newValue;
    notifyListeners();
  }

  set isSix(bool newValue) {
    _isSix = newValue;
    notifyListeners();
  }

  bool get isAllFieldsFilled =>
      _year.isNotEmpty && _month.isNotEmpty && _day.isNotEmpty && _gender.isNotEmpty;

  bool get isAllBirthdayFilled =>
      _year.isNotEmpty && _month.isNotEmpty && _day.isNotEmpty;

  void assignNewData() {
    _newUserName = _userName;
    _newBirthDay = DateTime.tryParse(_birthDay) ?? DateTime.now();
    _newBio = _isBiometric;
    _newGender = _gender;
    notifyListeners();
  }

  // 예를 들어, "1997-10-10" 형식의 문자열을 DateTime으로 변환
  void updateBirthDayFromString(String dateStr) {
    _newBirthDay = DateTime.tryParse(dateStr) ?? DateTime.now();
    notifyListeners();
  }

  // // _newBirthDay를 "yyyy-MM-dd" 형식의 문자열로 변환
  // String getFormattedNewBirthDay() {
  //   return "${_newBirthDay.year.toString().padLeft(4, '0')}-${_newBirthDay.month.toString().padLeft(2, '0')}-${_newBirthDay.day.toString().padLeft(2, '0')}";
  // }


  bool isValidDate() {
    final int y = int.parse(_year);
    final int m = int.parse(_month);
    final int d = int.parse(_day);
    final DateTime date = DateTime(y, m, d);

    if (!date.isAfter(DateTime.now()) && date.year == y && date.month == m && date.day == d) {
      print("날짜 : ${date}");
      _isWrongDate = false;
      notifyListeners();
      return true; // 입력한 날짜가 유효함
    }


    _isWrongDate = true;
    notifyListeners();
    return false; // 입력한 날짜가 유효하지 않음
  }

  bool isPasswordMatch() => _password == _passwordSubmit;

  bool isPasswordCorrect() => isNumeric.hasMatch(_password);

  void initPasswordSubmit() {
    _password = '';
    _passwordSubmit = '';
    _isSix = false;
    notifyListeners();
  }

  String formatDate() {
    String formattedMonth = _month.padLeft(2, '0');
    String formattedDay = _day.padLeft(2, '0');

    // 'YYYY-MM-DD' 형식으로 날짜 문자열을 구성
    return "$_year-$formattedMonth-$formattedDay";
  }

  Map<String, dynamic> getRegistrationData(int id) {
    String shortPw = CryptoUtil.hashPassword(_password, id);
    return {
      "gender" : _gender,
      "birth" : formatDate(),
      "shortPw" : shortPw,
    };
  }

  Future<void> getUserInfo() async {
    UserInfo user = await _userService.getUserInfo();

    if(user.nickname != '') {
      _userName = user.nickname;
      _birthDay = user.birth;
      _gender = user.gender;
      _isBiometric = user.flagBiometrics;
    }
  }

  void reset() {
    _userName = '';
    _birthDay = '';
    _isBiometric = false;

    _year = '';
    _month = '';
    _day = '';
    _gender = '';
    _isWrongDate = false;
    _isSix = false;

    _password = '';
    _passwordSubmit = '';
  }
}
