class ConsumeDifferModel {
  int status;
  String message;
  int data;

  ConsumeDifferModel({
    this.status = 0,
    this.message = '',
    this.data = 0,
  });

  factory ConsumeDifferModel.fromJson(Map<String, dynamic> json) {
    return ConsumeDifferModel(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}