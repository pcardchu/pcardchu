import 'package:frontend/card/models/card_detail_model.dart';

class CardDetailResponse {
  final int status;
  final String message;
  final CardDetailModel data;

  CardDetailResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CardDetailResponse.fromJson(Map<String, dynamic> json) {
    return CardDetailResponse(
      status: json['status'],
      message: json['message'],
      data: CardDetailModel.fromJson(json['data']),
    );
  }
}