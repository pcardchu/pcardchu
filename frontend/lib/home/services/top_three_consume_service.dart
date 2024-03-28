import 'package:dio/dio.dart';
import 'package:frontend/home/models/top_three_consume_model.dart';

class TopThreeConsumeService {
  final dio = Dio();

  TopThreeConsumeService() {
    dio.options.baseUrl = 'https://j10d110.p.ssafy.io/api/';
    // JWT 토큰을 요청 헤더에 추가하는 인터셉터 설정
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // 여기서 `your_jwt_token`을 실제 토큰으로 교체하세요.
        // 토큰은 SharedPreferences, Keychain 등에서 안전하게 관리해야 합니다.
        const String yourJwtToken = 'eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwicm9sZSI6IlJPTEVfU0VDT05EX0FVVEgiLCJpYXQiOjE3MTE2MDY2MDYsImV4cCI6MTcxMTYwNjgyMn0.8K_yMR1ZGfFfrJU6CUk3SMwr9YGeWAcFBYvSl43ItDU';
        options.headers['Authorization'] = 'Bearer $yourJwtToken';
        return handler.next(options); // 계속해서 요청을 진행합니다.
      },
    ));
  }

  Future<List<TopThreeConsumeModel>> getTopThreeCategory() async {
    try {
      final response = await dio.get(
          'statistics/top3category');

      final List<dynamic> data = response.data;
      final List<TopThreeConsumeModel> cardList =
      data.map((e) => TopThreeConsumeModel.fromJson(e)).toList();
      return cardList;
    } on DioException catch (e) {
      if (e.response != null) {
        // 에러코드에 따른 처리
        throw Exception('Failed to load top 3 list: ${e.response}');
      } else {
        print(e.requestOptions);
        print(e.message);
        throw Exception('Failed to load top 3 list: ${e.message}');
      }
    }
  }
}