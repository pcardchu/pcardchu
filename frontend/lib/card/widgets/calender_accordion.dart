import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/calender.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

/// 소비패턴 - 캘린더 아코디언바
class CalenderAccordion extends StatefulWidget {
  /// 아코디언바가 확장 됐을때 자동으로 스크롤이 맨 아래로 내려가게 하기 위해서 사용
  final ScrollController scrollController;

  const CalenderAccordion({
    super.key,
    required this.scrollController,
  });

  @override
  State<CalenderAccordion> createState() => _CalenderAccordionState();
}

class _CalenderAccordionState extends State<CalenderAccordion> {
  /// 확장 여부 확인
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 0,
      // 패널의 확장 상태가 변할때 마다 실행
      expansionCallback: (int index, bool isExpanded) {
        // 확장 상태 변경
        setState(() {
          _isExpanded = !_isExpanded;
        });
        // 확장 상태라면 스크롤바가 자동으로 화면 맨 아래로 이동하게
        if (_isExpanded) {
          // 아코디언이 확장되기 전에 스크롤바가 맨 아래로 이동하기 때문에
          // 제대로 원하는 동작이 안된다.
          // 그래서 1초 딜레이를 주고 난 뒤에 스크롤바를 이동하게 했습니다.
          Future.delayed(Duration(milliseconds: 200), () {
            widget.scrollController.animateTo(
              widget.scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        }
      },
      children: [
        ExpansionPanel(
          // 확장 상태 관리
          isExpanded: _isExpanded,
          // 아코디언바 헤더
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ListTile(
                title: Text(
                  '전체 내역',
                  style: AppFonts.suit(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.mainBlue,
                  ),
                ),
              ),
            );
          },
          // 아코디언바가 확장 됐을때 안에 들어갈 위젯
          // 캘린더 위젯
          body: Calender(),
          backgroundColor: AppColors.mainWhite,
        ),
      ],
    );
  }
}
