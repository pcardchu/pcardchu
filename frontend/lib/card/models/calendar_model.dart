class CalendarModel {
  final String date;
  final int amount;

  CalendarModel({
    required this.date,
    required this.amount,
  });

  factory CalendarModel.fromJson(Map<String, dynamic> json) {
    return CalendarModel(
      date: json['date'],
      amount: json['amount'],
    );
  }
}
