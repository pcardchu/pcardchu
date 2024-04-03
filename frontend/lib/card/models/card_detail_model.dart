class CardDetailModel {
  final String cardImage;
  final String cardName;
  final String cardCompany;
  final int useMoneyMonth;
  final List<UsageHistory> todayUseHistory;
  final Map<String, int> useBenefit;

  CardDetailModel({
    required this.cardImage,
    required this.cardName,
    required this.cardCompany,
    required this.useMoneyMonth,
    required this.todayUseHistory,
    required this.useBenefit,
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
