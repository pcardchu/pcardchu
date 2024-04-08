import 'package:frontend/card/models/calendar_model.dart';
import 'package:frontend/card/models/main_consumption_model.dart';

class ConsumptionModel {
  // 소비 분야 이름
  final String userName;

  // 소비 금액
  final int totalAmount;

  // 주 소비분야 5개의 소비 금액
  final List<MainConsumptionModel> mainConsumption;

  // 비교1
  final int thisMonthAmount;

  // 비교2
  final int amountGap;

  // 한달간 소비 금액
  final List<CalendarModel> calendar;

  ConsumptionModel({
    required this.userName,
    required this.totalAmount,
    required this.mainConsumption,
    required this.thisMonthAmount,
    required this.amountGap,
    required this.calendar,
  });

  /// 객체 형태로 변환
  factory ConsumptionModel.fromJson(Map<String, dynamic> json) {
    var mainConsumptionJson = json['mainConsumption'] as List<dynamic>;
    List<MainConsumptionModel> mainConsumptionList = mainConsumptionJson.map((item) {
      return MainConsumptionModel.fromJson(item);
    }).toList();

    return ConsumptionModel(
      userName: json['userName'],
      totalAmount: json['totalAmount'],
      mainConsumption: mainConsumptionList,
      thisMonthAmount: json['thisMonthAmount'],
      amountGap: json['amountGap'],
      calendar:
      (json['calendar'] as List).map((e) => CalendarModel.fromJson(e)).toList(),
    );
  }
}
