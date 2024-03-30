import 'package:frontend/card/models/card_model.dart';

class DiscountModel {
  /// 소비 분야 이름
  String? category;

  /// 해당 소비 분야 총 지출 금액
  int? total;

  /// 추천 카드 리스트
  List<CardModel>? card;

  DiscountModel({
    this.category,
    this.total,
    this.card,
  });

  /// 객체 형태로 변환
  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      category: json['category'],
      total: json['total'],
      card: List<CardModel>.from(json['card'].map((x) => CardModel.fromJson(x))),
    );
  }
}
