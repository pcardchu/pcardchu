import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/user/models/login_response.dart';
import 'package:frontend/utils/crypto_util.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart';

///카카오 소셜 로그인 서비스입니다.
class KakaoLoginService {
  final Dio _dio = Dio();

  ///기존에 발급된 토큰이 있는지 확인합니다.
  Future<bool> checkKakaoSignIn() async {
    bool result = false;
    if (await AuthApi.instance.hasToken()) {
      try {
        AccessTokenInfo tokenInfo =
        await UserApi.instance.accessTokenInfo();
        print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}, ${tokenInfo.appId}');

        var enc = CryptoUtil.encryptAES(tokenInfo.id.toString());
        print('${tokenInfo.id}\n${enc}');

        result = true;
      } catch (error) {
        if (error is KakaoException && error.isInvalidTokenError()) {
          print('토큰 만료 $error');
        } else {
          print('토큰 정보 조회 실패 $error');
        }
      }
    }

    return result;
  }

  Future<OAuthToken?> signInWithKakao() async {
    try {
      // 카카오톡 실행 가능 여부 확인
      if (await isKakaoTalkInstalled()) {
        // 카카오톡으로 로그인 시도
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
          print("카카오톡으로 로그인 성공, 액세스 토큰: ${token.accessToken}");
          
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

  Future<LoginResponse?> sendFirstJwtRequest(OAuthToken token) async {
    String url = "${dotenv.env['API_URL']!}/user/login/kakao";

    String encrypted = CryptoUtil.encryptAES(token.idToken);
    String? result;
    // print('id토큰 : ${token.idToken}');
    // print('암호화 : ${encrypted.toString()}');
    // print('iv : ${CryptoUtil.iv.base64}');
    // print("url : ${url}");

    var requestData = {
      'encryptedIdToken': encrypted.toString(),
      'base64IV': CryptoUtil.iv.base64,
    };

    try {
      final Response response = await _dio.post(
        url,
        data: requestData,
        options: Options(
          headers: {
            'accept' : 'application/json',
            'Content-Type': 'application/json', // 요청 헤더에 Content-Type 지정
          },
        ),);

      if (response.statusCode == 200) {
        result = response.headers.value('authorization');
        print('로그인 성공: ${result}');

        return LoginResponse(token: result);
      } else if(response.statusCode == 201) {
        result = response.headers.value('authorization');
        print('회원가입 성공: ${result}');

        return LoginResponse(isFirst: true,token: result);
      } else {
        print('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('요청 실패: $e');
    }
  }
}
