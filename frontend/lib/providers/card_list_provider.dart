import 'package:flutter/material.dart';

import 'package:frontend/home/models/card_info_model.dart';

import 'package:frontend/home/services/card_list_service.dart';

class CardListProvider with ChangeNotifier {
  /// 등록한 카드 리스트
  late List<CardInfoModel> cardList = [];

  /// 카드 등록 여부
  bool isCardRegistered = false;

  /// 상태 관리용
  bool loading = false;

  /// 카드 리스트 반환하는 서비스
  final CardListService _cardService = CardListService();

  checkUserCards() async {
    loading = true;
    notifyListeners();

    cardList = await _cardService.getCardList();

    if (cardList.isNotEmpty) {
      isCardRegistered = true;
    } else {
      isCardRegistered = false;
    }

    //isCardRegistered = false;

    loading = false;
    notifyListeners();
  }
}
