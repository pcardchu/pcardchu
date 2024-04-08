class ConsumeDifferModel {
  String ageGroup;
  String gender;
  int lastMonth;
  int percent;

  ConsumeDifferModel({
    this.ageGroup = '',
    this.gender = '',
    this.lastMonth = 0,
    this.percent = 0,
  });

  factory ConsumeDifferModel.fromJson(Map<String, dynamic> json) {
    return ConsumeDifferModel(
      ageGroup: json['ageGroup'] as String,
      gender: json['gender'] as String,
      lastMonth: json['lastMonth'] as int,
      percent: json['percent'] as int,
    );
  }
}