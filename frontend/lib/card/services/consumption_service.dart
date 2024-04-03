import 'package:dio/dio.dart';
import 'package:frontend/card/models/consumption_model.dart';
import 'package:frontend/card/models/recommend_model.dart';
import 'package:frontend/utils/dio_util.dart';

class ConsumptionService{
  final dio = Dio();

  /// 내 소비 패턴 정보 GET 요청
  Future<ConsumptionModel> getMyConsumption(String id) async {
    try {
      final Response response = await DioUtil().dio.get(
          "/statistics/consumption");

      if (response.statusCode == 200) {
        // ConsumptionModel 객체로 변환;
        final consumptionModel = ConsumptionModel.fromJson(response.data['data']);

        return consumptionModel;
      } else {
        throw Exception('Failed to load consumptionModel');
      }
    } catch (e) {
      throw Exception('Failed to load consumptionModel: $e');
    }
  }

  /// 추천 카드 GET 요청
  Future<RecommendModel?> getMyRecommend(String id) async {
    try {
      final Response response = await DioUtil().dio.get(
          "/cards/recommend/personal-card");

      if (response.statusCode == 200) {
        // RecommendModel 객체로 변환;
        final recommendModel = RecommendModel.fromJson(response.data);

        return recommendModel;
      } else {
        throw Exception('Failed to load recommendModel');
      }
    } on DioException catch (e) {
      if(e.response!.statusCode == 404)
        {
          return null;
        }
      throw Exception('Failed to load recommendModel: $e');
    }
  }
}