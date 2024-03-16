import 'package:dio/dio.dart';
import 'package:frontend/card/models/card_model.dart';

class CardService {
  final dio = Dio();

  /// 카테고리에 맞는 카드 리스트
  Future<List<CardModel>> getCategoryCards(String id) async {
    try {
      final Response response = await dio.get(
          "https://c1572068-2b01-47af-9cc5-f1fffef18d53.mock.pstmn.io/category",
          queryParameters: {'id': id});

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<CardModel> cards =
            data.map((json) => CardModel.fromJson(json)).toList();

        print('카테고리 카드 리스트 get 요청 완료');

        return cards;
      } else {
        throw Exception('Failed to load cards');
      }
    } catch (e) {
      throw Exception('Failed to load cards: $e');
    }
  }
}
