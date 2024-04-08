class LoginResponse {
  bool? isFirst;
  String? accessToken;
  String? refreshToken;

  LoginResponse({this.isFirst, this.accessToken, this.refreshToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      isFirst: json['num'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isFirst': isFirst,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
