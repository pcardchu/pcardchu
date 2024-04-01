class TimeAnalyzeModel {
  int status;
  String message;
  String data;

  TimeAnalyzeModel({
    this.status = 0,
    this.message = '',
    this.data = '',
  });

  factory TimeAnalyzeModel.fromJson(Map<String, dynamic> json) {
    return TimeAnalyzeModel(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}