import 'package:dio/dio.dart';
import 'package:frontend/card/models/consumption_model.dart';
import 'package:frontend/card/models/recommend_model.dart';

class ConsumptionService{
  final dio = Dio();

  /// 내 소비 패턴 정보 GET 요청
  Future<ConsumptionModel> getMyConsumption(String id) async {
    try {
      final Response response = await dio.get(
          "https://j10d110.p.ssafy.io/api/statistics/consumption",
          options: Options(
            headers: {
              'accept': 'application/json',
              'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwicm9sZSI6IlJPTEVfU0VDT05EX0FVVEgiLCJpYXQiOjE3MTE2ODYyMDEsImV4cCI6MTcxMTY4ODAwMX0.sI5iqSZ7PTtmTV1oA3crO1OFa4qDQTZ_LtcPjgIKRy0'
            }
          ));

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
  Future<RecommendModel> getMyRecommend(String id) async {
    try {
      final Response response = await dio.get(
          "https://c1572068-2b01-47af-9cc5-f1fffef18d53.mock.pstmn.io/recommend/1");

      if (response.statusCode == 200) {
        // RecommendModel 객체로 변환;
        final recommendModel = RecommendModel.fromJson(response.data);

        return recommendModel;
      } else {
        throw Exception('Failed to load recommendModel');
      }
    } catch (e) {
      throw Exception('Failed to load recommendModel: $e');
    }
  }
}