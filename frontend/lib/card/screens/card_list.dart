import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/card_list_bottom.dart';
import 'package:frontend/card/widgets/card_list_top.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Color(0xFFF5F5F5),

        /// 뒤로가기 버튼
        leading: IconButton(
          icon: Image.asset('assets/images/back_icon.png'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

        /// 스크롤할때 앱바 색 안바뀌게
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 윗 페이지
            CardListTop(
              bottomKey: bottomKey,
            ),

            /// 아래 페이지
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
}
