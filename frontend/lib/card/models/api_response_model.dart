import 'package:frontend/card/models/cards_response_model.dart';

class ApiResponseModel {
  int? status;
  String? message;
  CardsResponseModel? data;

  ApiResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiResponseModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? CardsResponseModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}
