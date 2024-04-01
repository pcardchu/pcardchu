import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/card_list/card_list_bottom.dart';
import 'package:frontend/card/widgets/card_list/card_list_top.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:provider/provider.dart';

class CardList extends StatefulWidget {
  const CardList({super.key});

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  /// 스크롤 자동이동을 위한 키
  final GlobalKey bottomKey = GlobalKey();

  /// 어떤 카테고리를 선택했는지 확인하는 인덱스
  int selectedChoiceIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: AppColors.mainWhite,
        // 뒤로가기 버튼
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
            context.read<CardProvider>().setCategory(0);
          },
        ),
        // 스크롤할때 앱바 색 안바뀌게
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            // 윗 페이지
            CardListTop(
              bottomKey: bottomKey,
            ),
            // 아래 페이지
            CardListBottom(
              bottomKey: bottomKey,
              selectedChoiceIndex: selectedChoiceIndex,
              selectedChip: selectedChip,
            ),
          ],
        ),
      ),
    );
  }

  /// 카테고리를 선택했을때 인덱스 저장하는 함수
  void selectedChip(int index) {
    setState(() {
      selectedChoiceIndex = index;
    });
  }

  /// 카테고리 카드 리스트 Get
  Future<void> loadData() async {
    // 카테고리 카드 리스트 배열에 정보가 없을때만 Get 호출
    if (!context.read<CardProvider>().loadCategory) {
      await context.read<CardProvider>().getCategoryCards(context, 1);
    }
  }
}
