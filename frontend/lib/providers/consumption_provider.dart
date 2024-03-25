import 'package:flutter/cupertino.dart';
import 'package:frontend/card/models/consumption_model.dart';
import 'package:frontend/card/services/consumption_service.dart';

class ConsumptionProvider with ChangeNotifier {
  ConsumptionService consumptionService = ConsumptionService();

  /// 내 소비 내역 정보
  late ConsumptionModel? myConsumption = null;
  /// 로딩 상태 관리
  bool loading = false;
  /// 내 소비 내역 정보 로드 상태
  /// 참이면 배열에 이미 데이터가 있는 상태 >> Get할 필요 없음
  bool loadMyConsumption = false;

  /// 내 소비 내역 정보 GET 요청
  getMyConsumption(String id) async {
    loading = true;
    myConsumption = await consumptionService.getMyConsumption(id);
    loading = false;
    loadMyConsumption = true;

    notifyListeners();
  }
}