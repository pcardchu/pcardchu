import 'package:frontend/home/models/top_three_consume_model.dart';

class TopThreeConsumeResponse {
  final int status;
  final String message;
  final List<TopThreeConsumeModel> data;

  TopThreeConsumeResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TopThreeConsumeResponse.fromJson(Map<String, dynamic> json) {
    return TopThreeConsumeResponse(
      status: json['status'],
      message: json['message'],
      data: List<TopThreeConsumeModel>.from(json['data'].map((x) => TopThreeConsumeModel.fromJson(x))),
    );
  }

  @override
  String toString() {
    return super.toString();
  }
}
