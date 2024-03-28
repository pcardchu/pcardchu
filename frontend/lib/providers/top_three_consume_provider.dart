import 'package:flutter/material.dart';
import 'package:frontend/home/models/top_three_consume_model.dart';
import 'package:frontend/home/services/top_three_consume_service.dart';

class TopThreeConsumeProvider with ChangeNotifier {
  /// 등록한 카드 리스트
  late List<TopThreeConsumeModel> consumeList = [];


  /// 상태 관리용
  bool loading = false;

  /// 카드 리스트 반환하는 서비스
  final TopThreeConsumeService _topThreeConsumeService = TopThreeConsumeService();

  void checkUserCards() async {
    loading = true;
    consumeList = await _topThreeConsumeService.getTopThreeCategory();
    loading = false;

    notifyListeners();
  }
}