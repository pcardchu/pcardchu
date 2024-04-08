import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/user/models/jwt_token.dart';
import 'package:frontend/user/models/login_response.dart';
import 'package:frontend/user/models/second_jwt_response.dart';
import 'package:frontend/utils/crypto_util.dart';
import 'package:frontend/utils/first_dio_util.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static final String? baseUrl = dotenv.env['API_URL'];
  static final Dio dio = Dio();
  final storage = const FlutterSecureStorage();

  Future<void> saveFirstToken(JwtToken jwtToken) async {
    await storage.write(key: 'firstAccessToken', value: jwtToken.accessToken);
    await storage.write(key: 'firstRefreshToken', value: jwtToken.refreshToken);
  }

  Future<JwtToken?> getFirstToken() async {
    String? accessToken = await storage.read(key: 'firstAccessToken');
    String? refreshToken = await storage.read(key: 'firstRefreshToken');

    if (accessToken != null && refreshToken != null) {
      FirstDioUtil().setAccessToken(accessToken!);
      return JwtToken(accessToken: accessToken, refreshToken: refreshToken, isFirst: true);
    } else {
      return null;
    }
  }

  Future<void> deleteFirstToken() async {
    await storage.delete(key: 'firstAccessToken');
    await storage.delete(key: 'firstRefreshToken');
  }

  Future<void> saveSecondToken(JwtToken jwtToken) async {
    await storage.write(key: 'secondAccessToken', value: jwtToken.accessToken);
    await storage.write(key: 'secondRefreshToken', value: jwtToken.refreshToken);
  }

  Future<JwtToken?> getSecondToken() async {
    String? accessToken = await storage.read(key: 'secondAccessToken');
    String? refreshToken = await storage.read(key: 'secondRefreshToken');

    if (accessToken != null && refreshToken != null) {
      return JwtToken(accessToken: accessToken, refreshToken: refreshToken);
    } else {
      return null;
    }
  }

  Future<void> deleteSecondToken() async {
    await storage.delete(key: 'secondAccessToken');
    await storage.delete(key: 'secondRefreshToken');
  }

  Future<bool> updateBiometricToServer(bool value, JwtToken token) async {
    dio.options.connectTimeout = const Duration(milliseconds: 1000);
    dio.options.receiveTimeout = const Duration(milliseconds: 1000);
    dio.options.sendTimeout = const Duration(milliseconds: 1000);

    String url = "${baseUrl}/user/flag-biometrics";

    var requestData = {
      "flagBiometrics": value
    };

    try {
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
        print("생체인증 수정 요청 성공 : ${response!.statusCode}");
        return true;
      } else {
        print("생체인증 수정 요청 성공 : ${response!.statusCode}");
      }

    } on DioException catch(e) {
      print("생체인증 수정 요청 실패 : ${e.response!.statusCode}");
    } finally {
      print("생체인증 수정 요청 end");
    }

    return false;
  }

  Future<String?> registrationRequest(JwtToken token, String gender, String shortPw, String birth) async {
    dio.options.connectTimeout = const Duration(milliseconds: 1000);
    dio.options.receiveTimeout = const Duration(milliseconds: 1000);
    dio.options.sendTimeout = const Duration(milliseconds: 1000);

    String url = "${baseUrl}/user/basic-info";

    var requestData = {
      'gender': gender,
      'birth': birth,
      'shortPw': shortPw,
    };

    print("요청 데이터 :ㅣ ${requestData}");

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
        return '성공';
      } else if(response.statusCode == 401) {
        //토큰 만료 로직
        print('토큰 만료: ${response.statusCode}');
        return '토큰 만료';
      } else {
        // 서버에서 반환된 오류 처리
        print('서버 오류: ${response.data}');
        return '실패';
      }
    } catch (e) {
      print('요청 실패: $e');
    }

    return '실패';
  }

  Future<SecondJwtResponse> secondJwtRequestWithPassword(digest) async {
    final Dio _dio = FirstDioUtil().dio;

    String url = "/user/login/password";

    var requestData = {
      'password': digest,
    };


    try {
      final Response response = await _dio.post(
        url,
        data: requestData,
      );

      // 성공 응답 처리
      print("2차 jwt 발급 성공 ${response.data}");

      JwtToken result = JwtToken(
        isFirst: false,
        accessToken: response.data['accessToken'],
        refreshToken: response.data['refreshToken']
      );

      saveSecondToken(result);

      return SecondJwtResponse(
        code: response.statusCode,
        count: 0,
        accessToken: response.data['accessToken'],
        refreshToken: response.data['refreshToken'],
      );
    } on DioException catch (e) {
      // DioError에서 응답 객체 접근
      final response = e.response;

      // 상태 코드가 있을 경우 그에 따라 처리
      if (response != null) {
        print("응답 에러 코드: ${response.statusCode}");
        print("응답 에러 내용: ${response.data}");

        if (response.statusCode == 400) {
          // 비밀번호 오류 처리
          return SecondJwtResponse(
            code: response.statusCode,
            count: response.data,
            accessToken: null,
            refreshToken: null,
          );
        } else if (response.statusCode == 401) {
          // 토큰 만료 처리
          print("토큰 만료");
        } else {
          // 그 외 오류 처리
          print("기타 오류 처리");
        }
      } else {
        // 응답 없이 발생한 예외 처리
        print("응답 없음: $e");
      }
    } catch (e) {
      // 그 외 예외 처리
      print("2차 Jwt 토큰 발급 실패 : $e");
    }

// 기본 반환 값 설정, 실패 시 반환할 객체
    return SecondJwtResponse(
      code: 0,
      count: 0,
      accessToken: 'null',
      refreshToken: 'null',
    );
  }

  Future<JwtToken> secondJwtRequestWithBiometric() async {
    final Dio _dio = FirstDioUtil().dio;

    String url = "/user/login/bio";

    try {
      final Response response = await _dio.post(
        url,
      );

      // 성공 응답 처리
      print("지문 2차 jwt 발급 성공 ${response.data}");

      JwtToken result = JwtToken(
          isFirst: false,
          accessToken: response.data['accessToken'],
          refreshToken: response.data['refreshToken']
      );

      saveSecondToken(result);

      return result;
    } on DioException catch (e) {
      // DioError에서 응답 객체 접근
      final response = e.response;

      // 상태 코드가 있을 경우 그에 따라 처리
      if (response != null) {
        print("응답 에러 코드: ${response.statusCode}");
        print("응답 에러 내용: ${response.data}");

        if (response.statusCode == 400) {
          // 비밀번호 오류 처리
          return JwtToken(
              isFirst: false,
              accessToken: null,
              refreshToken: null
          );
        } else {
          // 그 외 오류 처리
          print("기타 오류 처리");
        }
      } else {
        // 응답 없이 발생한 예외 처리
        print("응답 없음: $e");
      }
    } catch (e) {
      // 그 외 예외 처리
      print("2차 Jwt 토큰 발급 실패 : $e");
    }

// 기본 반환 값 설정, 실패 시 반환할 객체
    return JwtToken(
        isFirst: false,
        accessToken: null,
        refreshToken: null
    );
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
    bool? isBiometric;
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
        isBiometric = response.data['flagBiometrics'] == 1 ? true : false;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('biometric_login', isBiometric);

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

  static Future<String> refreshAccessToken(bool isFirst) async {
    final String url = "${baseUrl}/user/refresh";
    const storage = FlutterSecureStorage();
    String? refreshToken;

    if(isFirst) {
      refreshToken = await storage.read(key: 'firstRefreshToken');
    } else {
      refreshToken = await storage.read(key: 'secondRefreshToken');
    }
    print("isFirst : $isFirst\nrefreshToken : $refreshToken");

    try {
      final Response response = await dio.post(
        url,
        data: {
          'flagFirst' : isFirst,
          'refreshToken': refreshToken
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];

        if(isFirst) {
          await storage.write(key: 'firstAccessToken', value: newAccessToken);
          await storage.write(key: 'firstRefreshToken', value: newRefreshToken);
        } else {
          await storage.write(key: 'secondAccessToken', value: newAccessToken);
          await storage.write(key: 'secondRefreshToken', value: newRefreshToken);
        }


        return newAccessToken;
      } else {
        print('토큰 갱신 실패: ${response.statusCode}');
        return '';
      }
    } on DioException catch (e) {
      print('토큰 갱신 에러: $e');

      if(e.response!.statusCode == 404) {
        return '리프레시 토큰 만료' ;
      }

      return '';
    }
  }
}