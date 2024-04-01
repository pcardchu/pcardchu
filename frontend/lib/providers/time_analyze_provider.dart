import 'package:flutter/material.dart';
import '../home/models/time_analyze_model.dart';
import '../home/services/time_analyze_service.dart';

class TimeAnalyzeProvider with ChangeNotifier {
  /// 집단과의 소비차이를 받아야합니다.
  late TimeAnalyzeModel _ages = TimeAnalyzeModel();
  /// 상태 관리용
  bool _loading = false;
  String _errorMessage = "";

  /// 카드 리스트 반환하는 서비스
  final TimeAnalyzeService _timeAnalyzeService = TimeAnalyzeService();

  TimeAnalyzeModel get ages => _ages;
  bool get loading => _loading;
  String get errorMessage => _errorMessage;

  getTimeAnalyze() async {
    _setLoading(true);
    try {
      _ages = await _timeAnalyzeService.getTimeAnalyze();

      _setLoading(false);
    } catch (e) {
      /// ui ux 부분에서 에러핸들링을 하기 위해서 추가한 로직 -> 사용자에게 알리기 위함
      _setError(e.toString());
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}