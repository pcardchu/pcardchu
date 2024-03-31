import 'package:flutter/material.dart';
import 'package:frontend/card/screens/consumption.dart';
import 'package:frontend/card/widgets/no_card_notice.dart';

class ExpenseAnalyticsScreen extends StatefulWidget {
  const ExpenseAnalyticsScreen({super.key});

  @override
  State<ExpenseAnalyticsScreen> createState() => _ExpenseAnalyticsScreenState();
}

class _ExpenseAnalyticsScreenState extends State<ExpenseAnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    return NoCardNotice();
  }
}
