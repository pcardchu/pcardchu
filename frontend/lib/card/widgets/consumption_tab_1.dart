import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/consumption_chart.dart';
import 'package:frontend/card/widgets/consumption_list.dart';
import 'package:frontend/utils/app_colors.dart';

class ConsumptionTab1 extends StatelessWidget {
  const ConsumptionTab1({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 내 소비 차트 위젯
          ConsumptionChart(),
          SizedBox(height: 30),
          // 내 소비 분류
          ConsumptionList(),
          Container(
            height: 16,
            width: MediaQuery.of(context).size.width,
            color: AppColors.bottomGrey,
          )
        ],
      ),
    );
  }
}
