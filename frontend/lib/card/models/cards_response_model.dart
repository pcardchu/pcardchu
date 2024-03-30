import 'package:frontend/card/models/card_model.dart';

class CardsResponseModel {
  List<CardModel>? cardsRes;
  int? pageNumber;
  int? pageSize;
  bool? last;

  CardsResponseModel({
    this.cardsRes,
    this.pageNumber,
    this.pageSize,
    this.last,
  });

  factory CardsResponseModel.fromJson(Map<String, dynamic> json) {
    return CardsResponseModel(
      cardsRes: (json['cardsRes'] as List<dynamic>?)
          ?.map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      last: json['last'],
    );
  }
}
