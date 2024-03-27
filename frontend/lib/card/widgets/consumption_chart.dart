import 'package:flutter/material.dart';
import 'package:frontend/providers/consumption_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/category_colors.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

/// 내 소비 차트 위젯
class ConsumptionChart extends StatelessWidget {
  const ConsumptionChart({super.key});

  @override
  Widget build(BuildContext context) {
    // 소비 내역 정보
    final data = context.watch<ConsumptionProvider>().myConsumption;

    /// 소비 패턴 분류별 색상
    CategoryColors categoryColors = CategoryColors();
    Map<String, Color> colorDict = categoryColors.categoryColors;



    // 소비 패턴 분류별 색상
    final List<Color> colorList = [
      colorDict[data!.mainConsumption![0][0]]!,
      colorDict[data.mainConsumption![1][0]]!,
      colorDict[data.mainConsumption![2][0]]!,
      colorDict[data.mainConsumption![3][0]]!,
      colorDict[data.mainConsumption![4][0]]!,
    ];

    // 현재 날짜 가져오기
    DateTime now = DateTime.now();
    // 현재 월
    int month = now.month;

    /// 소비 내역 정보
    Map<String, double> dataMap = {
      "${data!.mainConsumption![0][0]}": data.mainConsumption![0][1].toDouble(),
      "${data.mainConsumption![1][0]}": data.mainConsumption![1][1].toDouble(),
      "${data.mainConsumption![2][0]}": data.mainConsumption![2][1].toDouble(),
      "${data.mainConsumption![3][0]}": data.mainConsumption![3][1].toDouble(),
      "${data.mainConsumption![4][0]}": data.mainConsumption![4][1].toDouble(),
    };

    return Column(
      children: [
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '${month - 1}월 ${data!.userName}님의 소비',
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

        SizedBox(
          height: 240,
          width: 240,
          child: PieChart(
            dataMap: dataMap,
            colorList: colorList,
            animationDuration: Duration(milliseconds: 1500),
            chartValuesOptions: ChartValuesOptions(
              showChartValues: false,
            ),
            legendOptions: LegendOptions(showLegends: false),
            centerWidget: Container(
              width: 80.0, // 너비 설정
              height: 80.0, // 높이 설정
              decoration: BoxDecoration(
                color: AppColors.mainWhite, // 배경색 설정
                borderRadius: BorderRadius.circular(50.0), // 둥근 모서리 설정
              ),
            ),
          ),
        ),
      ],
    );
  }
}
