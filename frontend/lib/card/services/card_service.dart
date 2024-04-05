import 'package:dio/dio.dart';
import 'package:frontend/card/models/api_response_model.dart';
import 'package:frontend/card/models/card_model.dart';
import 'package:frontend/utils/dio_util.dart';

class CardService {
  final dio = Dio();

  /// 카테고리에 맞는 카드 리스트 GET 요청
  /// id는 카테고리 아이디
  Future<ApiResponseModel> getCategoryCards(String category, pageNumber) async {
    print(category);
    try {
      final Response response = await DioUtil().dio.get(
          "/cards/list",
          queryParameters: {'category': category, 'pageNumber': pageNumber, 'pageSize': 5},
      );

      if (response.statusCode == 200) {
        ApiResponseModel apiResponse = ApiResponseModel.fromJson(response.data);


        return apiResponse;
      } else {
        throw Exception('Failed to load cards');
      }
    } catch (e) {
      throw Exception('Failed to load cards: $e');
    }
  }

  /// 해당 아이디의 카드 디테일 정보 GET 요청
  /// id는 카드 아이디
  Future<CardModel> getCardsDetail(String cardId) async {
    try {
      final Response response = await DioUtil().dio.get(
          "/cards/list/detail/$cardId",
          queryParameters: {'cardId': cardId});
      if (response.statusCode == 200) {
        // CardModel 객체로 변환;
        final CardModel cards = CardModel.fromJson(response.data['data']);

        return cards;
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
      final Response response = await DioUtil().dio.post(
          "/cards/my-cards",
          data: {
            'cardCompany': cardCompany,
            'cardNo': cardNumber,
            'cardCompanyId': id,
            'cardCompanyPw': pw
          });

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load cards');
      }
    } on DioException catch (e) {
      if(e.response?.statusCode == 409){
        /// 여기서 409 ( 이미 중복된 카드 일 때 대응 해주기 )
      }
      return {'data': false};
      throw Exception('Failed to load cards: $e');
    }
  }
}
