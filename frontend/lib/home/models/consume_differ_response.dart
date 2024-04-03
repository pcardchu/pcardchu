import 'consume_differ_model.dart';

class ConsumeDifferResponse {
  int status;
  String message;
  ConsumeDifferModel data; // 이 부분이 변경되었습니다.

  ConsumeDifferResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ConsumeDifferResponse.fromJson(Map<String, dynamic> json) {
    return ConsumeDifferResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      data: ConsumeDifferModel.fromJson(json['data'] as Map<String, dynamic>), // 이 부분이 변경되었습니다.
    );
  }
}