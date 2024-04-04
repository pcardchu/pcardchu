class CardDetailModel {
  String? cardImage;
  String? cardName;
  String? cardCompany;
  int? useMoneyMonth;
  List<UsageHistory>? todayUseHistory;
  Map<String, int>? useBenefit;

  CardDetailModel({
    this.cardImage,
    this.cardName,
    this.cardCompany,
    this.useMoneyMonth,
    this.todayUseHistory,
    this.useBenefit,
  });

  factory CardDetailModel.fromJson(Map<String, dynamic> json) {
    return CardDetailModel(
      cardImage: json['cardImage'],
      cardName: json['cardName'],
      cardCompany: json['cardCompany'],
      useMoneyMonth: json['useMoneyMonth'],
      todayUseHistory: List<UsageHistory>.from(json['todayUseHistory'].map((x) => UsageHistory.fromJson(x))),
      useBenefit: Map.from(json['useBenefit']).map((k, v) => MapEntry<String, int>(k, v)),
    );
  }
}

class UsageHistory {
  final String category;
  final int amount;
  final String date;
  final int time;

  UsageHistory({
    required this.category,
    required this.amount,
    required this.date,
    required this.time,
  });

  factory UsageHistory.fromJson(Map<String, dynamic> json) {
    return UsageHistory(
      category: json['category'],
      amount: json['amount'],
      date: json['date'],
      time: json['time'],
    );
  }
}
