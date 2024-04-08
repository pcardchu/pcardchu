import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/user/services/token_service.dart';
import 'package:frontend/utils/crypto_util.dart';

class FirstDioUtil {
  static final FirstDioUtil _instance = FirstDioUtil._internal();
  late final Dio _dio;
  static String? _accessToken;

  factory FirstDioUtil() {
    return _instance;
  }

  FirstDioUtil._internal() {
    _dio = Dio();
    // Dio 인스턴스 기본 설정 (예: 기본 URL, 타임아웃 등)
    _dio.options.baseUrl = dotenv.env['API_URL']!;
    _dio.options.connectTimeout = const Duration(milliseconds: 15000); //5초
    _dio.options.receiveTimeout = const Duration(milliseconds: 13000); //3초

    // 인터셉터 추가
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers["Accept"] = "application/json";
        options.headers["Content-Type"] = "application/json";

        print('요청 accessToken : $_accessToken');
        int? exp = CryptoUtil.extractExpFromAccessToken(_accessToken!);
        int leftTime = calculateTimeLeftInSeconds(exp);

        print("first accessToken 만료까지 남은 시간 : ${leftTime}초");


        if(leftTime < 500) {
          print('first token 재발급 로직 수행');
          String newAccessToken = await TokenService.refreshAccessToken(true);
          if(newAccessToken == '리프레시 토큰 만료') {
            //리프레시 토큰까지 만료됨
            print('리프레시 토큰 만료');
          } else if(newAccessToken!='') {
            _accessToken = newAccessToken;
            print('new accessToken : $_accessToken');
          }
        }

        options.headers["Authorization"] = "Bearer $_accessToken}";

        print('요청 Url: ${options.baseUrl}${options.path}');
        print('요청 Body: ${options.data}');

        return handler.next(options);
      },
      onResponse: (response, handler) {
        // 응답 처리 로직
        print('응답 Status Code: ${response.statusCode}');
        print('응답 Data: ${response.data}');

        return handler.next(response);
      },
      onError: (DioException e, handler) {
        // 에러 처리 로직
        print('응답 에러 Status Code: ${e.response?.statusCode}');

        return handler.next(e);
      },
    ));
  }

  void setAccessToken(String accessToken) {
    _accessToken = accessToken;
  }

  int calculateTimeLeftInSeconds(int? exp) {
    if (exp == null) return 0;

    // 현재 시간을 Epoch 시간으로 변환합니다.
    final currentTimeInSeconds = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    // 만료 시간까지 남은 시간을 계산합니다.
    final timeLeftInSeconds = exp - currentTimeInSeconds;

    print("남은 시간 : $timeLeftInSeconds");
    return timeLeftInSeconds;
  }


  Dio get dio => _dio;
}
