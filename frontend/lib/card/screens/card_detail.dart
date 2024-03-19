import 'package:flutter/material.dart';
import 'package:frontend/card/models/card_model.dart';
import 'package:frontend/card/screens/card_web_view.dart';
import 'package:frontend/card/widgets/detail_bottom.dart';
import 'package:frontend/card/widgets/detail_top.dart';
import 'package:frontend/card/widgets/next_btn.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:frontend/utils/app_colors.dart';
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
        // 스크롤 할 때 앱바 색 안 바뀌게
        scrolledUnderElevation: 0,
      ),
      backgroundColor: AppColors.mainWhite,
      body: Container(
        color: Color(0xFFF5F5F5),
        width: MediaQuery.of(context).size.width,
        // 로딩중 이거나 값이 없을 경우 로딩 표시
        child: loading || card == null
            // 로딩중 일 때
            ? Center(
                child: CircularProgressIndicator(),
              )
            // 로딩 끝났을 때
            // 스크롤 가능하게
            : SingleChildScrollView(
                // 화면 전체 컬럼
                child: Column(
                  children: [
                    // 상단부
                    DetailTop(),
                    // 구분선
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 23),
                      height: 16,
                      color: AppColors.bottomGrey,
                    ),
                    // 하단부
                    DetailBottom(),
                  ],
                ),
              ),
      ),
      // 하단에 떠있는 고정 버튼
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: NextBtn(
          title: '카드 신청하기',
          onPressed: onPressed,
        ),
      ),
      // 하단에 떠있는 고정 버튼 위치
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// 빌드시 카드 디테일 정보 Get 요청
  Future<void> loadData() async {
    final cardProvider = context.read<CardProvider>();
    await cardProvider.getCardsDetail(widget.cardId);
  }

  /// 하단 고정 카드 신청 버튼 함수
  void onPressed() {
    CardModel? card = context.read<CardProvider>().cardDetail;
    // 카드 정보가 불러와졌을때만 웹뷰를 실행
    if (card != null) {
      // 카드 신청 웹 주소
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CardWebView(),
        ),
      );
    }
  }
}
