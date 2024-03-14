class PasswordService {
  String _inputValue = "";

  String get inputValue => _inputValue;

  void addNumber(int number) {
    _inputValue += "$number";
  }

  void deleteLast() {
    if (_inputValue.isNotEmpty) {
      _inputValue = _inputValue.substring(0, _inputValue.length - 1);
    }
  }
}
