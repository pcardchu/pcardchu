import 'package:flutter/material.dart';
import 'package:frontend/home/models/top_three_consume_model.dart';
import 'package:frontend/home/services/top_three_consume_service.dart';

class TopThreeConsumeProvider with ChangeNotifier {
  ///  집단 별 소비 리스트
  late List<TopThreeConsumeModel> _consumeList = [];
  /// 상태 관리용
  bool _loading = false;
  String _errorMessage = "";
  bool _loadConsumeList = false;

  /// 소비 리스트 반환하는 서비스
  final TopThreeConsumeService _topThreeConsumeService = TopThreeConsumeService();

  List<TopThreeConsumeModel> get consumeList => _consumeList;
  bool get loading => _loading;
  String get errorMessage => _errorMessage;

  /// 참이면 소비리스트에 이미 데이터가 있는 상태 >> Get할 필요 없음
  bool get loadConsumeList => _loadConsumeList;


  getTopThreeCategory() async {
    _setLoading(true);
    try {
     _consumeList = await _topThreeConsumeService.getTopThreeCategory();
     _setLoadConsumeList(true);
      _setLoading(false);
    } catch (e) {
      /// ui ux 부분에서 에러핸들링을 하기 위해서 추가한 로직 -> 사용자에게 알리기 위함
      _setError(e.toString());
      _setLoadConsumeList(false);
      _setLoading(false);
    }
  }

  void _setLoadConsumeList(bool value) {
    _loadConsumeList = value;
    notifyListeners();
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