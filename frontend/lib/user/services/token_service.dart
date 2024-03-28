import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/user/models/jwt_token.dart';
import 'package:frontend/user/models/login_response.dart';
import 'package:frontend/utils/crypto_util.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class TokenService {
  final String? baseUrl = dotenv.env['API_URL'];
  final Dio dio = Dio();
  final storage = const FlutterSecureStorage();

  Future<void> saveFirstToken(JwtToken jwtToken) async {
    await storage.write(key: 'firstAccessToken', value: jwtToken.accessToken);
    await storage.write(key: 'firstRefreshToken', value: jwtToken.refreshToken);
  }

  Future<JwtToken?> getFirstToken() async {
    String? accessToken = await storage.read(key: 'firstAccessToken');
    String? refreshToken = await storage.read(key: 'firstRefreshToken');

    if (accessToken != null && refreshToken != null) {
      return JwtToken(accessToken: accessToken, refreshToken: refreshToken, isFirst: true);
    } else {
      return null;
    }
  }

  Future<void> deleteFirstToken() async {
    await storage.delete(key: 'firstAccessToken');
    await storage.delete(key: 'firstRefreshToken');
  }

  Future<bool?> registrationRequest(JwtToken token, String gender, String shortPw, String birth) async {
    dio.options.connectTimeout = const Duration(milliseconds: 1000);
    dio.options.receiveTimeout = const Duration(milliseconds: 1000);
    dio.options.sendTimeout = const Duration(milliseconds: 1000);

    String url = "${baseUrl}/user/basic-info";

    var requestData = {
      'gender': gender,
      'birth': birth,
      'shortPw': shortPw,
    };

    try {
      print("registrationRequest 시작");
      final Response response = await dio.patch(
        url,
        data: requestData,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token.accessToken}',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('정보 등록 성공');
        return true;
      } if(response.statusCode == 401) {
        //토큰 만료 로직
        print('토큰 만료: ${response.statusCode}');
      } else {
        // 서버에서 반환된 오류 처리
        print('서버 오류: ${response.data}');
      }
    } catch (e) {
      print('요청 실패: $e');
    }

    return false;
  }

  Future<LoginResponse?> firstJwtRequest(OAuthToken token) async {
    // 연결 시도 최대 시간
    dio.options.connectTimeout = const Duration(milliseconds: 1000);
    // 서버로부터 데이터 수신 최대 시간
    dio.options.receiveTimeout = const Duration(milliseconds: 1000);
    // 데이터 전송 최대 시간
    dio.options.sendTimeout = const Duration(milliseconds: 1000);

    String url = "${baseUrl}/user/login/kakao";

    String encrypted = CryptoUtil.encryptAES(token.idToken);
    String? accessToken;
    String? refreshToken;
    // print('id토큰 : ${token.idToken}');
    // print('암호화 : ${encrypted.toString()}');
    // print('iv : ${CryptoUtil.iv.base64}');
    // print("url : ${url}");

    var requestData = {
      'encryptedIdToken': encrypted.toString(),
      'base64IV': CryptoUtil.iv.base64,
    };

    try {
      final Response response = await dio.post(
        url,
        data: requestData,
        options: Options(
          headers: {
            'accept' : 'application/json',
            'Content-Type': 'application/json', // 요청 헤더에 Content-Type 지정
          },
        ),
      );

      if (response.statusCode == 200) {
        accessToken = response.data['accessToken'];
        refreshToken = response.data['refreshToken'];
        print('로그인 성공: ${accessToken}');

        return LoginResponse(accessToken: accessToken, refreshToken: refreshToken, isFirst: false);
      } else if(response.statusCode == 201) {
        accessToken = response.data['accessToken'];
        refreshToken = response.data['refreshToken'];
        print('회원가입 성공: ${accessToken}');

        return LoginResponse(accessToken: accessToken, refreshToken: refreshToken, isFirst: true);
      } else {
        print('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('요청 실패: $e');
    }
  }
}