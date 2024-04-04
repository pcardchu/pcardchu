import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/card_list/card_list_wg.dart';
import 'package:frontend/card/widgets/card_list/category_list.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:provider/provider.dart';

/// 카드리스트 - 아래쪽 메인화면입니다.
class CardListBottom extends StatelessWidget {
  // 스크롤 자동이동을 위한 키
  final GlobalKey bottomKey;

  // 어떤 카테고리를 선택했는지 확인하는 인덱스
  final int selectedChoiceIndex;

  // 카테고리를 선택했을때 인덱스 저장하는 함수
  final Function(int) selectedChip;

  const CardListBottom({
    super.key,
    required this.bottomKey,
    required this.selectedChoiceIndex,
    required this.selectedChip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: bottomKey,
      width: MediaQuery.of(context).size.width,
      color: Color(0xFFF5F5F5),
      // 화면 전체 높이 - 앱바 높이 - 상태표시줄 높이
      height: MediaQuery.of(context).size.height -
          AppBar().preferredSize.height -
          MediaQuery.of(context).padding.top,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단부
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 39),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '혜택별로 살펴보는\n이번달 인기 카드',
                  style: AppFonts.suit(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff26282B),
                  ),
                ),
                SizedBox(
                    height: 60,
                    child: Image.asset('assets/images/complete.png')),
              ],
            ),
          ),
          SizedBox(height: 30),
          // 카테고리 리스트 스크롤
          CategoryList(
            selectedChoiceIndex: selectedChoiceIndex,
            selectedChip: selectedChip,
          ),
          SizedBox(height: 23.0),
          Container(
            height: 16,
            color: Color(0xFFE6E4F1),
          ),
          Container(
            height: 27,
            color: Color(0xFFF5F5F5),
          ),
          // 하단부
          Expanded(
            child: Container(
              color: Color(0xFF5F5F5),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 39),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '조건에 맞는 카드 리스트',
                      style: AppFonts.suit(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff26282B),
                      ),
                    ),
                    SizedBox(height: 15.0),

                    /// 카드 목록을 보여주는 위젯
                    CardListWg(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
