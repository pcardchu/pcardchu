import 'card_info_model.dart';

class CardInfoResponse {
  final int status;
  final String message;
  final List<CardInfoModel> data;

  CardInfoResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CardInfoResponse.fromJson(Map<String, dynamic> json) {
    return CardInfoResponse(
      status: json['status'],
      message: json['message'],
      data: List<CardInfoModel>.from(json['data'].map((x) => CardInfoModel.fromJson(x))),
    );
  }

  @override
  String toString() {
    return super.toString();
  }
}
