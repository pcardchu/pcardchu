import 'package:dio/dio.dart';
import 'package:frontend/card/models/card_model.dart';

class CardService {
  final dio = Dio();

  /// 카테고리에 맞는 카드 리스트 GET 요청
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

  /// 해당 아이디의 카드 디테일 정보 GET 요청
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

  /// 내 소비 내역 GET 요청
  Future getConsumption(String id) async {
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

  /// 카드 등록 POST 요청
  Future cardRegistration(
    String cardCompany,
    String cardNumber,
    String id,
    String pw,
  ) async {
    try {
      final Response response = await dio.post(
          "https://c1572068-2b01-47af-9cc5-f1fffef18d53.mock.pstmn.io/api/users/cards",
          data: {
            'cardCompany': cardCompany,
            'cardNumber': cardNumber,
            'id': id,
            'pw': pw
          });

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load cards');
      }
    } catch (e) {
      throw Exception('Failed to load cards: $e');
    }
  }
}
