import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/consumption/day_cell.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatelessWidget {
  const Calender({super.key});

  @override
  Widget build(BuildContext context) {
    /// 캘린더 오늘 날짜
    DateTime focusedDay = DateTime.now();

    /// 이번달 1일 시작
    DateTime firstDay = DateTime(focusedDay.year, focusedDay.month + 1, 1);

    /// 이번달 말일까지
    DateTime lastDay = DateTime(focusedDay.year, focusedDay.month + 2, 1)
        .subtract(Duration(days: 1));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          TableCalendar(
            // 한글 설정
            locale: 'ko_KR',
            // 오늘 날짜
            focusedDay: focusedDay,
            // 최소일
            firstDay: firstDay,
            // 최대일
            lastDay: lastDay,
            // 제스처 삭제
            availableGestures: AvailableGestures.none,
            // 요일 컬럼 높이
            daysOfWeekHeight: 50,
            // 헤더 안보이게
            headerVisible: false,
            // 요일 컬럼 스타일 수정
            daysOfWeekStyle: DaysOfWeekStyle(
              // 평일 컬럼 텍스트 스타일 수정
              weekdayStyle: AppFonts.suit(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.grey),
              // 주말 컬럼 텍스트 스타일 수정
              weekendStyle: AppFonts.suit(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.grey),
            ),
            // 캘린더 스타일
            calendarStyle: CalendarStyle(
              // 오늘 날짜 표시 삭제
              isTodayHighlighted: false,
              // 이전, 이후 날짜 표시 안하기
              outsideDaysVisible: false,
            ),
            // 캘린더 수정 빌더
            calendarBuilders: CalendarBuilders(
              // 각 날짜 위젯 수정
              defaultBuilder: (context, day, focusedDay) =>
                  dayCell(context, day, focusedDay),
            ),
            // 요일 컬럼 수정
            // dowBuilder: dowBuilder,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
