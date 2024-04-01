import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/card_list/category_card.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:provider/provider.dart';

/// 카드리스트 - 아래쪽 메인화면 - 조건에 맞는 카드리스트 목록을 보여주는 위젯입니다.
class CardListWg extends StatefulWidget {
  const CardListWg({super.key});

  @override
  State<CardListWg> createState() => _CardListWgState();
}

class _CardListWgState extends State<CardListWg> {
  /// 스크롤을 맨 아래로 땡기면 데이터를 로드하는 함수를 실행시키기 위한 컨트롤러
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // 맨 아래로 스크롤했을때 다음 페이지 불러오기
  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    final provider = Provider.of<CardProvider>(context, listen: true);
    /// 다음 페이지 있는지 확인
    bool isNextPage = provider.isNextPage;
    /// 현재 카테고리
    int categoryIndex = provider.categoryId;
    /// 현재 페이지
    int pageNumber = provider.currentPage;

    // 다음 페이지가 있다면
    if(isNextPage){
      // 다음 페이지 데이터 배열에 추가하기
      provider.getNextPage(categoryIndex, pageNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 플래그, true면 로딩중
    final loading = context.watch<CardProvider>().loading;
    // 카테고리 아이디
    final categoryId = context.watch<CardProvider>().categoryId;
    // 카테고리에 맞는 카드 리스트
    final cards = context.watch<CardProvider>().categoryCards;

    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Color(0xffF5F5F5),
        // 데이터 로딩중이라면 로딩 위젯 출력
        child: loading
            // 로딩중
            ? Center(
                child: CircularProgressIndicator(),
              )
            // 로딩 완료
            : ListView.separated(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index < cards[categoryId].length) {
                    // 카드 정보
                    return CategoryCard(
                      index: index,
                    );
                  }else{
                    // 로딩 인디케이터를 표시
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
                // 카드 사이에 여백
                separatorBuilder: (context, index) {
                  return SizedBox(height: 20);
                },
                // 로딩중이라면 리스트에 로딩 인디케이터를 추가해야하니 + 1
                itemCount: cards[categoryId].length + (loading ? 1 : 0)),
      ),
    );
  }
}
