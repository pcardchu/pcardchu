import 'package:flutter/material.dart';
import 'package:frontend/providers/consumption_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// 캘린더 날짜 위젯
Widget dayCell(BuildContext context, DateTime day, DateTime focusedDay) {
  // 임시로 설정한 값, 실제로는 적절한 데이터 구조로 대체해야 합니다.
  var total = 100000; // 예시 데이터

  /// 내 소비 패턴 정보
  final data = context.watch<ConsumptionProvider>().myConsumption;

  /// 가장 많이 소비한 날짜 top5 인덱스
  final top5 = context.watch<ConsumptionProvider>().getTop5(data!.calendar);

  return Center(
    child: Column(
      children: [
        Text(
          day.day.toString(),
          style: AppFonts.suit(
              fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.grey),
        ),

        // day가 데이터에 있는 날짜라면
        // 해당 인덱스를 가져와서 금액을 표시한다
        if (data.calendar.indexWhere((e) =>
                e.date.substring(6, 8) ==
                day.toString().split('-').join('').substring(6, 8)) !=
            -1)
          Text(
            '${data.calendar[data.calendar.indexWhere((e) => e.date.substring(6, 8) == day.toString().split('-').join('').substring(6, 8))].amount}',
            style: AppFonts.suit(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                // 상위 5개라면 빨간색 표시
                color: top5.contains(data
                        .calendar[data.calendar.indexWhere((e) =>
                            e.date.substring(6, 8) ==
                            day.toString().split('-').join('').substring(6, 8))]
                        .date)
                    ? AppColors.mainRed
                    : AppColors.lightGrey),
          ),
      ],
    ),
  );
}
