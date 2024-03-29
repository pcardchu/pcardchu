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
      name: json['data']['name'],
      discount: List<DiscountModel>.from(json['data']['discount'].map((x) => DiscountModel.fromJson(x))),
    );
  }
}
