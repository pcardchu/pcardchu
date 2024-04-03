import 'package:flutter/material.dart';

import 'package:frontend/home/models/card_info_model.dart';

import 'package:frontend/home/services/card_list_service.dart';

class CardListProvider with ChangeNotifier {
  /// 등록한 카드 리스트
  late List<CardInfoModel> _cardList = [];

  /// 카드 등록 여부
  bool _isCardRegistered = false;

  /// 상태 관리용
  bool _loading = false;

  /// 카드 리스트 반환하는 서비스
  final CardListService _cardService = CardListService();

  List<CardInfoModel> get cardList => _cardList;

  bool get isCardRegistered => _isCardRegistered;

  bool get loading => _loading;
  bool _loadCardList = false;

  bool get loadCardList => _loadCardList;

  /// 두 메소드 모두 같은 서비스 메소드를 호출하는 게 좋은 상태관리 인가..
  checkUserCards() async {
    _setLoading(true);
    try {
      _cardList = await _cardService.getCardList();

      if (cardList.isNotEmpty) {
        _setIsCardRegistered(true);
      } else {
        _setIsCardRegistered(false);
      }

      _setLoading(false);
    } catch (e) {
      _setLoading(false);
    }
  }

  getUserCardsList() async {
    _setLoading(true);
    try {
      _cardList = await _cardService.getCardList();
      _setLoadCardList(true);
      _setLoading(false);
    } catch (e) {
      _setLoadCardList(false);
      _setLoading(false);
    }
  }

  void _setLoadCardList(bool value) {
    _loadCardList = value;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setIsCardRegistered(bool value) {
    _isCardRegistered = value;
    notifyListeners();
  }
}
