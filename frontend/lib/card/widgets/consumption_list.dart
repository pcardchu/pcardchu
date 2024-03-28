import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/consumption_card.dart';
import 'package:frontend/providers/consumption_provider.dart';
import 'package:provider/provider.dart';

class ConsumptionList extends StatefulWidget {
  const ConsumptionList({super.key});

  @override
  State<ConsumptionList> createState() => _ConsumptionListState();
}

class _ConsumptionListState extends State<ConsumptionList> {
  @override
  Widget build(BuildContext context) {
    // 내 소비 패턴 정보
    final data = context.watch<ConsumptionProvider>().myConsumption;

    return ListView.separated(
        //ListView가 차지하는 공간을 자식 크기에 맞춤
        shrinkWrap: true,
        // 부모 스크롤과 충돌 방지
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return SizedBox(height: 25);
        },
        // 소비 분야 위젯
        separatorBuilder: (context, index) {
          return ConsumptionCard(
            index: index,
          );
        },
        itemCount: data!.mainConsumption!.length + 1);
  }
}
