import 'package:flutter/services.dart';
import 'package:frontend/utils/aes_util.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart';

class KakaoLoginService {
  Future<OAuthToken?> signInWithKakao() async {
    try {
      // 카카오톡 실행 가능 여부 확인
      if (await isKakaoTalkInstalled()) {
        // 카카오톡으로 로그인 시도
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
          print("카카오톡으로 로그인 성공, 액세스 토큰: ${token.accessToken}");

          var encrypted = AesUtil.encryptAES(token.idToken); //암호화 테스트

          return token;
        } catch (error) {
          print('카카오톡으로 로그인 실패 $error');

          // 로그인 취소 또는 특정 오류 처리
          if (error is PlatformException && error.code == 'CANCELED') {
            print('카카오톡 로그인 취소');
            return null; // 로그인 취소로 간주, 추가 로그인 시도 없이 종료
          }

          // 로그인 취소가 아닌 다른 오류인 경우, 예외를 던져 처리를 중단
          throw Exception('카카오톡으로 로그인 실패: $error');
        }
      } else {
        // 카카오톡이 설치되어 있지 않은 경우, 카카오계정으로 로그인 시도
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print("카카오계정으로 로그인 성공, 액세스 토큰: ${token.accessToken}");

          return token;
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          throw Exception('카카오계정으로 로그인 실패: $error');
        }
      }
    } catch (error) {
      print('로그인 과정에서 예외 발생: $error');
      throw Exception('로그인 과정에서 예외 발생: $error');
    }
  }
}
