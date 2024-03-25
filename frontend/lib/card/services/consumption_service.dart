import 'package:dio/dio.dart';
import 'package:frontend/card/models/consumption_model.dart';

class ConsumptionService{
  final dio = Dio();

  /// 내 소비 패턴 정보 GET 요청
  Future<ConsumptionModel> getMyConsumption(String id) async {
    try {
      final Response response = await dio.get(
          "https://c1572068-2b01-47af-9cc5-f1fffef18d53.mock.pstmn.io/api/users/consumption",
          queryParameters: {'id': id});

      if (response.statusCode == 200) {
        // CardModel 객체로 변환;
        final consumptionModel = ConsumptionModel.fromJson(response.data);

        return consumptionModel;
      } else {
        throw Exception('Failed to load cards');
      }
    } catch (e) {
      throw Exception('Failed to load cards: $e');
    }
  }
}