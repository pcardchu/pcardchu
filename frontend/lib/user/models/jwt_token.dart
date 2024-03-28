import 'package:frontend/user/models/login_response.dart';

class JwtToken {
  bool? isFirst;
  String? accessToken;
  String? refreshToken;

  JwtToken({this.isFirst, this.accessToken, this.refreshToken});

  factory JwtToken.fromJson(Map<String, dynamic> json) {
    return JwtToken(
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

  factory JwtToken.fromLoginResponse(LoginResponse response, bool isFirst) {
    return JwtToken(
      isFirst : isFirst,
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
  }
}
