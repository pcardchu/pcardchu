import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/category_card.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:provider/provider.dart';

/// 카드리스트 - 아래쪽 메인화면 - 조건에 맞는 카드리스트 목록을 보여주는 위젯입니다.
class CardListWg extends StatefulWidget {
  const CardListWg({super.key});

  @override
  State<CardListWg> createState() => _CardListWgState();
}

class _CardListWgState extends State<CardListWg> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // provider에서 api 호출
    loadData();
  }

  /// provider에서 api 호출하는 함수
  /// api를 불러오기 때문에 비동기 처리
  Future<void> loadData() async {
    final cardProvider = Provider.of<CardProvider>(context, listen: false);
    // api 호출
    await cardProvider.getCategoryCards(context);
  }

  @override
  Widget build(BuildContext context) {
    /// 카테고리에 맞는 카드 리스트
    final cards = Provider.of<CardProvider>(context).categoryCards;

    /// 로딩 플래그, true면 로딩중
    final loading = Provider.of<CardProvider>(context).loading;

    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Color(0xffF5F5F5),
      
        /// 데이터 로딩중이라면 로딩 위젯 출력
        child: loading
      
            /// 로딩중
            ? Center(
                child: CircularProgressIndicator(),
              )
      
            /// 로딩 완료
            : ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  /// 카드 정보
                  return CategoryCard(cards: cards, index: index,);
                },
      
                /// 카드 사이에 여백
                separatorBuilder: (context, index) {
                  return SizedBox(height: 20);
                },
                itemCount: cards.length),
      ),
    );
  }
}
