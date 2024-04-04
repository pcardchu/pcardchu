import 'package:flutter/cupertino.dart';
import 'package:frontend/card/models/calendar_model.dart';
import 'package:frontend/card/models/card_detail_model.dart';
import 'package:frontend/card/models/consumption_model.dart';
import 'package:frontend/card/models/recommend_model.dart';
import 'package:frontend/card/services/card_detail_service.dart';
import 'package:frontend/chart/services/consumption_service.dart';

class CardDetailProvider with ChangeNotifier {


  /// 로딩 상태 관리
  bool _loading = false;

  // 카드 상세 내역
  CardDetailModel? _cardDetailModel;


  /// 카드 상세내역 반환하는 서비스
  final CardDetailService  _cardDetailService = CardDetailService ();

  bool get loading => _loading;

  CardDetailModel get cardDetailModel => _cardDetailModel!;


  /// 내 소비 내역 정보 GET 요청
  getMyConsumption(String id) async {
    _setLoading(true);
    try {
      _cardDetailModel = await _cardDetailService.getMyCardDetail(id);
      _setLoading(false);
    }catch (e) {
      _setLoading(false);
    }
  }


  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }



}
