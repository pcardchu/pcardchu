import 'package:flutter/cupertino.dart';
import 'package:frontend/card/models/calendar_model.dart';
import 'package:frontend/card/models/consumption_model.dart';
import 'package:frontend/card/models/recommend_model.dart';
import 'package:frontend/card/services/consumption_service.dart';

class ConsumptionProvider with ChangeNotifier {
  ConsumptionService consumptionService = ConsumptionService();

  /// 내 소비 내역 정보
  late ConsumptionModel? myConsumption = null;

  /// 내 추천 카드 정보
  late RecommendModel? myRecommend = null;

  /// 로딩 상태 관리
  bool loading = false;

  /// 내 소비 내역 정보 로드 상태
  /// 참이면 배열에 이미 데이터가 있는 상태 >> Get할 필요 없음
  bool loadMyConsumption = false;

  /// 내 추천 카드 정보 로드 상태
  /// 참이면 배열에 이미 데이터가 있는 상태 >> Get할 필요 없음
  bool loadMyRecommend = false;

  /// 내 소비 패턴에서 가장 최대 소비 top5 날짜의 인덱스를 가지는 배열 만들기
  List<String> getTop5(List<CalendarModel> calendar) {
    // 내림차순 정렬
    List<CalendarModel> sortedCalendar = List<CalendarModel>.from(calendar)
      ..sort((a, b) => b.amount.compareTo(a.amount));

    // 상위 5개 항목의 date 추출
    List<String> top5Dates = sortedCalendar.take(5).map((item) => item.date).toList();

    return top5Dates;
  }

  /// 내 소비 내역 정보 GET 요청
  getMyConsumption(String id) async {
    loading = true;
    myConsumption = await consumptionService.getMyConsumption(id);
    loading = false;
    loadMyConsumption = true;

    notifyListeners();
  }

  /// 내 추천 카드 정보 GET 요청
  getMyRecommend(String id) async {
    loading = true;
    myRecommend = await consumptionService.getMyRecommend(id);
    loading = false;
    loadMyRecommend = true;

    notifyListeners();
  }
}
