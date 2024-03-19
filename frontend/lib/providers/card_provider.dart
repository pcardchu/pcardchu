import 'package:flutter/material.dart';
import 'package:frontend/card/models/card_model.dart';
import 'package:frontend/card/services/card_service.dart';

class CardProvider with ChangeNotifier {
  // 나에게 맞는 추천 카드 리스트
  // late를 사용할때는 무조건 !!!! 초기화를 해주자
  // 안그러면 비동기 통신할때 에러남
  late List<List<CardModel>> categoryCards = [];

  // 카드 디테일 정보
  late CardModel? cardDetail = null;

  // 로딩 상태 관리
  bool loading = false;

  // 카테고리 리스트 로드 상태
  // 참이면 카테고리 배열에 이미 데이터가 있는 상태 >> Get할 필요 없음
  bool loadCategory = false;

  // 카드 api 서비스
  CardService cardService = CardService();

  // 카테고리 선택 인덱스
  int _categoryId = 0;

  int get categoryId => _categoryId;

  /// 카테고리별 카드 리스트 GET
  /// 0 : 전체
  /// 1 : 교통
  /// 2 : 카페
  /// 3 : 배달
  /// 4 : 영화/문화
  getCategoryCards(context) async {
    loading = true;

    for (int i = 0; i < 5; i ++){
      categoryCards.add(await cardService.getCategoryCards(i.toString()));
    }

    // categoryAll = await cardService.getCategoryCards(_categoryId.toString());
    loading = false;
    loadCategory = true;

    notifyListeners();
  }

  /// 카테고리 인덱스 변경
  /// int index는 카테고리 인덱스
  /// 해당 카테고리에 맞는 카드 리스트를 Get 요청
  void changeCategory(int index) async {
    if (_categoryId != index) {
      _categoryId = index;
      // loading = true;
      // categoryAll =
      //     await cardService.getCategoryCards(_categoryId.toString());
      // loading = false;

      notifyListeners();
    }
  }

  /// 카드 디테일 정보 Get 요청
  getCardsDetail(String cardId) async {
    loading = true;
    cardDetail = await cardService.getCardsDetail(cardId);
    loading = false;

    notifyListeners();
  }
}
