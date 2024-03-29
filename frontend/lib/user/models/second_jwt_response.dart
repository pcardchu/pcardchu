class SecondJwtResponse {
  int? code;
  int? count;
  String? accessToken;
  String? refreshToken;

  // 기본 생성자
  SecondJwtResponse({
    this.code,
    this.count,
    this.accessToken,
    this.refreshToken,
  });
}