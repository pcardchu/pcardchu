import 'package:flutter/material.dart';
import 'package:frontend/card/screens/consumption.dart';
import 'package:frontend/card/widgets/no_card_notice.dart';
import 'package:provider/provider.dart';

import '../../providers/card_list_provider.dart';

class ExpenseAnalyticsScreen extends StatefulWidget {
  const ExpenseAnalyticsScreen({super.key});

  @override
  State<ExpenseAnalyticsScreen> createState() => _ExpenseAnalyticsScreenState();
}

class _ExpenseAnalyticsScreenState extends State<ExpenseAnalyticsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cardListProvider = Provider.of<CardListProvider>(context);
    // 카드 리스트가 비어 있는지 여부에 따라 조건부 렌더링
    final hasCards = cardListProvider.isCardRegistered;
    return hasCards ? Consumption() : NoCardNotice();
  }
}
