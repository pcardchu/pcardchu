import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:frontend/home/models/card_info_model.dart';
import 'package:frontend/utils/dio_util.dart';

class CardListService {
  final dio = Dio();

  // Future<List<CardInfoModel>> getCardList() async {
  //   try {
  //     final response = await DioUtil().dio.get('/cards/my-cards');
  //
  //     final List<dynamic> data = response.data;
  //     print(data);
  //     final List<CardInfoModel> cardList =
  //         data.map((e) => CardInfoModel.fromJson(e)).toList();
  //     print(cardList);
  //     return cardList;
  //   } on DioException catch (e) {
  //     if (e.response != null) {
  //       // 에러코드에 따른 처리
  //       throw Exception('Failed to load card list: ${e.response}');
  //     } else {
  //       print(e.requestOptions);
  //       print(e.message);
  //       throw Exception('Failed to load card list: ${e.message}');
  //     }
  //   }
  //
  // }

  Future<List<CardInfoModel>> getCardList() async {
    // API 개발이 완료될 때까지 더미 데이터 반환
    return Future.delayed(const Duration(seconds: 1), () => _getDummyCardList());
  }

  List<CardInfoModel> _getDummyCardList() {
    // 여기에 더미 데이터를 정의합니다.
    final List<CardInfoModel> dummyCardList = [
      CardInfoModel(id: 1, cardCompanyName: "Card Company 1", cardImage: "assets/card1.png", cardNumber: "1234 5678 9012 3456", cardName: "Platinum Card"),
      CardInfoModel(id: 2, cardCompanyName: "Card Company 2", cardImage: "assets/card2.png", cardNumber: "9876 5432 1098 7654", cardName: "Gold Card"),
      // 더미 데이터 추가...
    ];
    return dummyCardList;
  }
}
