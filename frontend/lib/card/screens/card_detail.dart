import 'package:flutter/material.dart';
import 'package:frontend/card/models/card_model.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:provider/provider.dart';

/// 카드 디테일 정보를 보여주는 페이지입니다.
class CardDetail extends StatefulWidget {
  // 해당 카드의 디테일 정보를 가져오기 위한 카드 아이디
  final String cardId;

  const CardDetail({
    super.key,
    required this.cardId,
  });

  @override
  State<CardDetail> createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    // 카드 디테일 정보 가져오기
    CardModel? card = context.watch<CardProvider>().cardDetail;
    // 카드 로딩 상태 확인하기
    final loading = context.watch<CardProvider>().loading;

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Color(0xFFF5F5F5),
        // 뒤로가기 버튼
        leading: IconButton(
          icon: Image.asset('assets/images/back_icon.png'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        // 스크롤할때 앱바 색 안바뀌게
        scrolledUnderElevation: 0,
      ),
      body: Container(
        color: Color(0xFFF5F5F5),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            loading || card == null
                ? Text(loading.toString())
                : Image.network(card.cardImage!),
          ],
        ),
      ),
    );
  }

  /// 빌드시 카드 디테일 정보 Get 요청
  Future<void> loadData() async {
    final cardProvider = context.read<CardProvider>();
    await cardProvider.getCardsDetail(widget.cardId);
  }
}
