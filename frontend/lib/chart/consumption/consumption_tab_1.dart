import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/chart/consumption/calender_accordion.dart';
import 'package:frontend/chart/consumption/compare.dart';
import 'package:frontend/chart/consumption/consumption_chart.dart';
import 'package:frontend/chart/consumption/consumption_list.dart';
import 'package:frontend/utils/app_colors.dart';

/// 소비패턴 - 내 소비 탭 화면
class ConsumptionTab1 extends StatefulWidget {
  const ConsumptionTab1({super.key});

  @override
  State<ConsumptionTab1> createState() => _ConsumptionTab1State();
}

class _ConsumptionTab1State extends State<ConsumptionTab1> {
  /// 아코디언바가 확장 됐을때 자동으로 스크롤이 맨 아래로 내려가게 하기 위해서 사용
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          // 내 소비 차트 위젯
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: ConsumptionChart(),
          ),
          const SizedBox(height: 30),
          // 내 소비 분류
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: ConsumptionList(),
          ),
          Container(
            height: 16,
            width: MediaQuery.of(context).size.width,
            color: AppColors.bottomGrey,
          ),
          // 전 달과 비교 위젯
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Compare(),
          ),
          Container(
            height: 16,
            width: MediaQuery.of(context).size.width,
            color: AppColors.bottomGrey,
          ),
          // 캘린더 아코디언바
          CalenderAccordion(scrollController: scrollController,),
          SizedBox(height: 56)
        ],
      ),
    );
  }
}
