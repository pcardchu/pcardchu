import 'package:frontend/home/models/top_three_consume_model.dart';
import 'package:frontend/home/models/top_three_popular_model.dart';

class TopThreePopularResponse {
  final int status;
  final String message;
  final List<TopThreePopularModel> data;

  TopThreePopularResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TopThreePopularResponse.fromJson(Map<String, dynamic> json) {
    return TopThreePopularResponse(
      status: json['status'],
      message: json['message'],
      data: List<TopThreePopularModel>.from(json['data'].map((x) => TopThreePopularModel.fromJson(x))),
    );
  }

  @override
  String toString() {
    return super.toString();
  }
}
