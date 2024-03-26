import 'package:frontend/card/models/discount_model.dart';

/// 추천 카드 모델
class RecommendModel {
  /// 유저 이름
  String? name;

  /// 할인 객체 리스트
  List<DiscountModel>? discount;

  RecommendModel({
    this.name,
    this.discount,
  });

  /// 객체 형태로 변환
  factory RecommendModel.fromJson(Map<String, dynamic> json){
    return RecommendModel(
      name: json['name'],
      discount: json['discount'] != null ?
      (json['discount'] as List).map(
          (e) => DiscountModel.fromJson(e as Map<String, dynamic>)
      ).toList() : [],
    );
  }
}
