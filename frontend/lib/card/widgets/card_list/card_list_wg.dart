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

  Timer? _throttle;

  int? _lastCategoryId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_onScroll);
    // Provider에서 카테고리 ID 변경을 감지하기 위해 리스너를 추가
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CardProvider>(context, listen: false);
      _lastCategoryId = provider.categoryId;
      Provider.of<CardProvider>(context, listen: false).removeListener(_onCategoryChanged);
      provider.addListener(_onCategoryChanged);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _throttle?.cancel(); // 타이머를 취소합니다.
    super.dispose();
  }

  void _onCategoryChanged() {
    final provider = Provider.of<CardProvider>(context, listen: false);
    if (_lastCategoryId != provider.categoryId) {
      // 카테고리 ID가 변경되었으므로 스크롤을 맨 위로 이동
      _scrollController.animateTo(
        0.0, // 스크롤 위치를 0으로 설정하여 맨 위로 이동
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      _lastCategoryId = provider.categoryId; // 마지막 카테고리 ID 업데이트
    }
  }

  void _onScroll() {
    if (_throttle?.isActive ?? false) return; // 타이머가 활성화된 경우 바로 반환

    _throttle = Timer(const Duration(milliseconds: 300), () {
      // 300ms 동안의 쓰로틀링
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent ||
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent / 2) {
        if (!Provider.of<CardProvider>(context, listen: false).loading) {
          _loadMoreData();
        }
      }
    });
  }

  Future<void> _loadMoreData() async {
    final provider = Provider.of<CardProvider>(context, listen: false);

    /// 다음 페이지 있는지 확인
    bool isNextPage = provider.isNextPage;

    /// 현재 카테고리
    int categoryIndex = provider.categoryId;

    /// 현재 페이지
    int pageNumber = provider.currentPage;

    // 다음 페이지가 있다면
    if (isNextPage) {
      // 다음 페이지 데이터 배열에 추가하기
      await provider.getNextPage(categoryIndex, pageNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 플래그, true면 로딩중
    final loading = context.watch<CardProvider>().loading;
    final firstLoading = context.watch<CardProvider>().firstLoading;
    // 카테고리 아이디
    final categoryId = context.watch<CardProvider>().categoryId;
    // 카테고리에 맞는 카드 리스트
    final cards = context.watch<CardProvider>().categoryCards;

    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Color(0xffF5F5F5),
        // 데이터 로딩중이라면 로딩 위젯 출력
        child: firstLoading ? Center(child: CircularProgressIndicator(),) : ListView.separated(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              if (index < cards[categoryId].length) {
                // 카드 정보
                return CategoryCard(index: index);
              }
              if (index == cards[categoryId].length + (loading ? 1 : 0)) {
                return SizedBox(height: 200); // 조정 가능한 여백
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
