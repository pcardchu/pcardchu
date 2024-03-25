import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/consumption_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:frontend/utils/category_colors.dart';

/// 내 소비 차트 위젯
class ConsumptionChart extends StatelessWidget {
  const ConsumptionChart({super.key});

  @override
  Widget build(BuildContext context) {
    // 소비 내역 정보
    final data = context.watch<ConsumptionProvider>().myConsumption;

    // 소비 패턴 분류별 색상
    CategoryColors categoryColors = CategoryColors();
    Map<String, Color> colorDict = categoryColors.categoryColors;

    // 현재 날짜 가져오기
    DateTime now = DateTime.now();
    // 현재 월
    int month = now.month;

    // PieChartSectionData를 생성하기 위한 함수
    List<PieChartSectionData> sectionDataList(List data) {
      return data.map<PieChartSectionData>((item) {
        return PieChartSectionData(
          value: (item[1] as int).toDouble(),
          color: colorDict[item[0]],
          showTitle: false,
          radius: 70,
        );
      }).toList();
    }

    return Column(
      children: [
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '$month월 ${data!.userName}님의 소비',
              style: AppFonts.suit(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // 천단위를 구분하여 표시
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              NumberFormat('#,###원', 'ko_KR').format(data.total),
              style: AppFonts.suit(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.mainBlue,
              ),
            ),
          ],
        ),
        // 도넛 차트
        SizedBox(
          height: 240,
          child: PieChart(
            PieChartData(
              // 섹션 사이 공간
              sectionsSpace: 2,
              // 도넛 차트 중앙 원 반지름
              centerSpaceRadius: 40,
              // 도넛 차트 데이터
              sections: sectionDataList(data.mainConsumption!),
            ),
            swapAnimationDuration: Duration(milliseconds: 150), // Optional
            swapAnimationCurve: Curves.linear, // Optional
          ),
        ),
      ],
    );
  }
}
