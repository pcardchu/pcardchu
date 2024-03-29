import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioUtil {
  static final DioUtil _instance = DioUtil._internal();
  late final Dio _dio;

  factory DioUtil() {
    return _instance;
  }

  DioUtil._internal() {
    _dio = Dio();
    // Dio 인스턴스 기본 설정 (예: 기본 URL, 타임아웃 등)
    _dio.options.baseUrl = dotenv.env['API_URL']!;
    _dio.options.connectTimeout = const Duration(milliseconds: 5000); //5초
    _dio.options.receiveTimeout = const Duration(milliseconds: 3000); //3초

    // 인터셉터 추가
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // 모든 요청에 대해 헤더에 토큰 추가

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
    _dio.interceptors.clear(); // 기존 인터셉터 제거
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers["Accept"] = "application/json";
        options.headers["Authorization"] = "Bearer $accessToken";
        return handler.next(options);
      },
      // onResponse, onError 설정
    ));
  }

  Dio get dio => _dio;
}
