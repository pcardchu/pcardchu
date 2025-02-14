import 'package:flutter/material.dart';
import 'package:frontend/card/models/api_response_model.dart';
import 'package:frontend/card/models/card_model.dart';
import 'package:frontend/card/services/card_service.dart';
import 'package:frontend/utils/card_company.dart';

class CardProvider with ChangeNotifier {
  /// 나에게 맞는 추천 카드 리스트
  /// late를 사용할때는 무조건 !!!! 초기화를 해주자
  /// 안그러면 비동기 통신할때 에러남
  late List<List<CardModel>> categoryCards = [];

  /// 카드 디테일 정보
  late CardModel? cardDetail = null;

  /// 로딩 상태 관리
  bool loading = false;
  bool firstLoading = true;

  /// 카테고리 리스트 로드 상태
  /// 참이면 카테고리 배열에 이미 데이터가 있는 상태 >> Get할 필요 없음
  bool loadCategory = false;

  /// 카드 api 서비스
  CardService cardService = CardService();

  /// 카테고리 선택 인덱스
  int _categoryId = 0;

  int get categoryId => _categoryId;

  /// 카드 스캔 번호
  /// 텍스트로 입력한 카드 번호도 마지막엔 이곳에 저장된다
  String _scanNumber = '';

  /// 카드 스캔 번호 getter
  String get scanNumber => _scanNumber;

  /// 카드사 아이디
  String _companyId = '';

  String get companyId => _companyId;

  /// 카드사 비번
  String _companyPw = '';

  String get companyPw => _companyPw;

  /// 카드 등록시 선택한 카드사 인덱스
  int _companyIndex = -1;

  int get companyIndex => _companyIndex;

  /// 카드사 정보
  final CardCompany _cardCompany = CardCompany();

  /// 카드사 정보 getter
  List get companyList => _cardCompany.companyList;

  /// 카드 등록 가능 여부
  String cardRegisterResult = '';

  /// 페이지네이션 다음 페이지 있는지 여부 확인용
  bool isNextPage = true;

  /// 현재 페이지
  int currentPage = 1;

  /// 선택한 카드사 회원가입 url
  String get companyUrl {
    // _companyIndex가 유효한지 확인.
    if (_companyIndex >= 0 && _companyIndex < _cardCompany.companyList.length) {
      return _cardCompany.companyList[_companyIndex]['cardApplication'];
    } else {
      // 유효하지 않은 경우
      return 'error';
    }
  }

  /// 카테고리 인덱스 변경
  /// int index는 카테고리 인덱스
  /// 해당 카테고리에 맞는 카드 리스트를 Get 요청
  void setCategory(int index) async {
    if (_categoryId != index) {
      _categoryId = index;

      // 현재 페이지 1로 다시 초기화
      currentPage = 1;
      isNextPage = true;
      notifyListeners();
    }
  }

  /// 카드 등록시 카드사를 선택할때마다 인덱스 수정
  void setCompanyIndex(int index) async {
    if (_companyIndex != index) {
      _companyIndex = index;

      notifyListeners();
    }
  }

  /// 카드 스캔 번호 변경
  void setScanNumber(String num) async {
    _scanNumber = num;

    notifyListeners();
  }

  /// 카드사 아이디 변경
  void setCompanyId(String id) async {
    _companyId = id;

    notifyListeners();
  }

  // 로딩 상태 수동 변경
  void startLoading() async {
    loading = true;
    notifyListeners();
  }

  // 로딩 상태 수동 변경
  void endLoading() async {
    loading = false;
    notifyListeners();
  }

  /// 카드사 비밀번호 변경
  void setCompanyPw(String pw) async {
    _companyPw = pw;

    notifyListeners();
  }

  //-------- API ---------------------------------------------------------------

  /// 카테고리별 카드 리스트 GET 요청
  getCategoryCards(context, int pageNumber) async {
    Map<String, String> categoryDic = {
      '0': 'all',
      '1': '푸드',
      '2': '교통',
      '3': '쇼핑',
      '4': '의료',
      '5': '통신',
      '6': '여행',
      '7': '할인',
      '8': '문화/생활',
      '9': '카페',
      '10': '온라인결제',
      '11': '마트/편의점',
      '12': '기타',
    };

    loading = true;

    for (int i = 0; i < 13; i++) {
      ApiResponseModel data = await cardService.getCategoryCards(
          categoryDic[i.toString()]!, pageNumber);
      categoryCards.add(data.data!.cardsRes!);
    }

    loading = false;
    firstLoading = false;
    loadCategory = true;

    notifyListeners();
  }

  /// 페이지네이션 요청
  getNextPage(int categoryIndex, int pageNumber) async {
    Map<String, String> categoryDic = {
      '0': 'all',
      '1': '푸드',
      '2': '교통',
      '3': '쇼핑',
      '4': '의료',
      '5': '통신',
      '6': '여행',
      '7': '할인',
      '8': '문화/생활',
      '9': '카페',
      '10': '온라인결제',
      '11': '마트/편의점',
      '12': '기타',
    };

    // 다음 페이지가 있으면
    if (isNextPage) {
      loading = true;
      notifyListeners();

      try {
        ApiResponseModel data = await cardService.getCategoryCards(
            categoryDic[categoryIndex.toString()]!, pageNumber + 1);
        // 기존 해당 카테고리 정보가 들어 있는 배열 뒤에 다음 페이지 데이터들 추가
        categoryCards[categoryIndex] = [
          ...categoryCards[categoryIndex],
          ...data.data!.cardsRes!
        ];
        print('현재');
        // 현재 페이지 + 1
        currentPage += 1;

        // 만약 현재 페이지가 마지막 페이지라면
        if (data.data!.last!) {
          isNextPage = false;
        }
      } catch (e) {
        // 요청 실패 시 로딩 상태를 false로 설정
        print('Failed to load next page: $e');
      } finally {
        // 성공하거나 예외가 발생하더라도 마지막에 항상 실행
        loading = false;
        notifyListeners();
      }
    }
  }

  /// 카드 디테일 정보 GET 요청
  getCardsDetail(String cardId) async {
    loading = true;
    cardDetail = await cardService.getCardsDetail(cardId);
    loading = false;

    notifyListeners();
  }

  /// 카드 등록 POST 요청
  /// 카드사 이름, 카드 번호, 카드사 아이디, 비밀번호 필요
  cardRegistration() async {
    loading = true;
    cardRegisterResult = await cardService.cardRegistration(
        companyList[companyIndex]['name'], scanNumber, companyId, companyPw);
    loading = false;
    notifyListeners();
  }

//-------------------------리셋

// 클래스 멤버 변수들을 초기화하는 reset 메서드
  void reset() {
    // 추천 카드 리스트를 빈 리스트로 초기화
    categoryCards = [];

    // 카드 디테일 정보를 null로 초기화
    cardDetail = null;

    // 로딩 상태를 false로 초기화
    loading = false;

    // 첫 로딩 상태를 true로 초기화
    firstLoading = true;

    // 카테고리 리스트 로드 상태를 false로 초기화
    loadCategory = false;

    // 카테고리 선택 인덱스를 0으로 초기화
    _categoryId = 0;

    // 카드 스캔 번호를 빈 문자열로 초기화
    _scanNumber = '';

    // 카드사 아이디를 빈 문자열로 초기화
    _companyId = '';

    // 카드사 비밀번호를 빈 문자열로 초기화
    _companyPw = '';

    // 카드 등록시 선택한 카드사 인덱스를 -1로 초기화
    _companyIndex = -1;

    // 카드 등록 가능 여부를 ''로 초기화
    cardRegisterResult = '';

    // 페이지네이션 다음 페이지 있는지 여부를 true로 초기화
    isNextPage = true;

    // 현재 페이지를 1로 초기화
    currentPage = 1;

    // 변경 사항을 리스너들에게 알림
    notifyListeners();
  }
}
