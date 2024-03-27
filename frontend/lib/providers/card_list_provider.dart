import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:frontend/card/models/card_info_model.dart';

import 'package:frontend/card/services/card_list_service.dart';

class CardListProvider with ChangeNotifier {
  late List<CardInfoModel> cardList = [];

  bool isCardRegistered = false;

  final CardListService _cardService = CardListService();

  void checkUserCards() async {
    final cards = await _cardService.getCardList();
    if (cards.isNotEmpty) {
      isCardRegistered = true;
    } else {
      isCardRegistered = false;
    }
    notifyListeners();
  }

}