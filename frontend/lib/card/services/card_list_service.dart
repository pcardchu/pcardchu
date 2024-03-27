import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:frontend/card/models/card_info_model.dart';

class CardListService {
  final dio = Dio();

  Future<List<CardInfoModel>> getCardList() async {
    try {
      final response = await dio.get('https://yourapi.com/cards');

      final List<dynamic> data = response.data;
      final List<CardInfoModel> cardList =
          data.map((e) => CardInfoModel.fromJson(e)).toList();
      return cardList;
    } on DioException catch (e) {
      if (e.response != null) {
        // 에러코드에 따른 처리
        throw Exception('Failed to load card list: ${e.response}');
      } else {
        print(e.requestOptions);
        print(e.message);
        throw Exception('Failed to load card list: ${e.message}');
      }
    }

  }
}
