import 'package:flutter/material.dart';
import 'package:frontend/home/models/consume_differ_model.dart';
import 'package:frontend/home/models/top_three_consume_model.dart';
import 'package:frontend/home/services/top_three_consume_service.dart';

import '../home/services/consume_differ_service.dart';

class ConsumeDifferProvider with ChangeNotifier {
  /// 집단과의 소비차이를 받아야합니다.
  late ConsumeDifferModel _diff = ConsumeDifferModel();
  /// 상태 관리용
  bool _loading = false;
  String _errorMessage = "";

  /// 카드 리스트 반환하는 서비스
  final ConsumeDifferService _consumeDifferService = ConsumeDifferService();

  ConsumeDifferModel get diff => _diff;
  bool get loading => _loading;
  String get errorMessage => _errorMessage;

  getConsumeDiffer() async {
    _setLoading(true);
    try {
      _diff = await _consumeDifferService.getConsumeDiffer();

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