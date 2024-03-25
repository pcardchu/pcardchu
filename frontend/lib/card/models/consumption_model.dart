class ConsumptionModel {
  // 소비 분야 이름
  String? userName;

  // 소비 금액
  int? total;

  // 주 소비분야 5개의 소비 금액
  List<List<dynamic>>? mainConsumption;

  // 비교1
  int? compare1;

  // 비교2
  int? compare2;

  // 한달간 소비 금액
  List<int>? calender;

  ConsumptionModel({
    this.userName,
    this.total,
    this.mainConsumption,
    this.compare1,
    this.compare2,
    this.calender,
  });

  /// 객체 형태로 변환
  factory ConsumptionModel.fromJson(Map<String, dynamic> json) {
    return ConsumptionModel(
      userName: json['userName'],
      total: json['total'],
      mainConsumption: json['mainConsumption'] != null
          ? (json['mainConsumption'] as List<dynamic>)
              .map((list) => List<dynamic>.from(list))
              .toList()
          : null,
      compare1: json['compare1'],
      compare2: json['compare2'],
      calender:
          json['calender'] != null ? List<int>.from(json['calender']) : null,
    );
  }
}
