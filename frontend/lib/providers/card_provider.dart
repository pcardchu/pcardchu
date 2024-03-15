import 'package:flutter/material.dart';
import 'package:frontend/card/models/card_model.dart';
import 'package:frontend/card/services/card_service.dart';

class CardProvider with ChangeNotifier {
  /// 나에게 맞는 추천 카드 리스트
  /// late를 사용할때는 무조건 !!!! 초기화를 해주자
  /// 안그러면 비동기 통신할때 에러남
  late List<CardModel> categoryCards = [];

  /// 로딩 상태 관리
  bool loading = false;

  /// 카드 api 서비스
  CardService cardService = CardService();

  /// 카테고리 선택 인덱스
  int _categoryId = 0;

  int get categoryId => _categoryId;

  /// 카테고리에 맞는 카드 리스트 GET
  getCategoryCards(context) async {
    loading = true;
    categoryCards = await cardService.getCategoryCards(_categoryId.toString());
    loading = false;

    print('Get 요청 프로바이더');

    notifyListeners();
  }

  /// 카테고리 인덱스 변경
  /// int index는 카테고리 인덱스
  /// 해당 카테고리에 맞는 카드 리스트를 Get 요청
  void changeCategory(int index) async {
    if (_categoryId != index) {
      _categoryId = index;
      loading = true;
      categoryCards = await cardService.getCategoryCards(_categoryId.toString());
      loading = false;

      print('카테고리 변경 완료');
      
      notifyListeners();
    }
  }
}
