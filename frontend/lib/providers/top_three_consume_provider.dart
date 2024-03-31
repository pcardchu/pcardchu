import 'package:flutter/material.dart';
import 'package:frontend/home/models/top_three_consume_model.dart';
import 'package:frontend/home/services/top_three_consume_service.dart';

class TopThreeConsumeProvider with ChangeNotifier {
  /// 등록한 카드 리스트
  late List<TopThreeConsumeModel> _consumeList = [];
  /// 상태 관리용
  bool _loading = false;
  String _errorMessage = "";

  /// 카드 리스트 반환하는 서비스
  final TopThreeConsumeService _topThreeConsumeService = TopThreeConsumeService();

  List<TopThreeConsumeModel> get consumeList => _consumeList;
  bool get loading => _loading;
  String get errorMessage => _errorMessage;

  getTopThreeCategory() async {
    _setLoading(true);
    try {
     _consumeList = await _topThreeConsumeService.getTopThreeCategory();
     print(_consumeList);

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