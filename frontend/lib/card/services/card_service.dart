import 'package:dio/dio.dart';
import 'package:frontend/card/models/card_model.dart';

class CardService {
  final dio = Dio();

  /// 카테고리에 맞는 카드 리스트
  /// id는 카테고리 아이디
  Future<List<CardModel>> getCategoryCards(String id) async {
    try {
      final Response response = await dio.get(
          "https://c1572068-2b01-47af-9cc5-f1fffef18d53.mock.pstmn.io/category",
          queryParameters: {'id': id});

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<CardModel> cards =
            data.map((json) => CardModel.fromJson(json)).toList();

        return cards;
      } else {
        throw Exception('Failed to load cards');
      }
    } catch (e) {
      throw Exception('Failed to load cards: $e');
    }
  }

  /// 해당 아이디의 카드 디테일 정보
  /// id는 카드 아이디
  Future<CardModel> getCardsDetail(String id) async {
    try {
      final Response response = await dio.get(
          "https://c1572068-2b01-47af-9cc5-f1fffef18d53.mock.pstmn.io/card",
          queryParameters: {'id': id});

      if (response.statusCode == 200) {
        // CardModel 객체로 변환;
        final cardModel = CardModel.fromJson(response.data);

        return cardModel;
      } else {
        throw Exception('Failed to load cards');
      }
    } catch (e) {
      throw Exception('Failed to load cards: $e');
    }
  }
}
