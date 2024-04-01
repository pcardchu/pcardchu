class UserInfo {
  final String nickname;
  final String birth;
  final String gender;
  final bool flagBiometrics; // bool 타입으로 변경

  UserInfo({
    required this.nickname,
    required this.birth,
    required this.gender,
    required this.flagBiometrics,
  });

  UserInfo.empty()
      : nickname = '',
        birth = '',
        gender = '',
        flagBiometrics = false; // 기본값을 false로 설정

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      nickname: json['nickname'],
      birth: json['birth'],
      gender: json['gender'],
      flagBiometrics: json['flagBiometrics'] == 1, // 0과 1을 bool로 변환
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'birth': birth,
      'gender': gender,
      'flagBiometrics': flagBiometrics ? 1 : 0, // bool을 0 또는 1로 변환
    };
  }
}
