class MainConsumptionModel {
  final String categoryName;
  final int amount;

  MainConsumptionModel({
    required this.categoryName,
    required this.amount,
  });

  factory MainConsumptionModel.fromJson(Map<String, dynamic> json) {
    return MainConsumptionModel(
      categoryName: json['categoryName'],
      amount: json['amount'],
    );
  }
}
