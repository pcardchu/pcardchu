import 'package:dio/dio.dart';
import 'package:frontend/card/models/card_detail_response.dart';
import 'package:frontend/utils/dio_util.dart';
import '../models/card_detail_model.dart';

class CardDetailService {
  final dio = Dio();

  /// 내 소비 패턴 정보 GET 요청
  Future<CardDetailModel> getMyCardDetail(String id) async {
    try {
      final Response response = await DioUtil()
          .dio
          .get("/cards/my-cards/$id", queryParameters: {'cardId': id});

      final responseData = CardDetailResponse.fromJson(response.data);

      if (responseData.status == 200) {
        return responseData.data;
      } else {
        throw Exception('Failed to load card detail: ${responseData.message}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // 에러코드에 따른 처리
        throw Exception('Failed to load card detail: ${e.response}');
      } else {
        print(e.requestOptions);
        print(e.message);
        throw Exception('Failed to load card detail: ${e.message}');
      }
    }
  }
}
