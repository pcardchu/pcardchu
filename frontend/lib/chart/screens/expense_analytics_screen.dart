import 'package:flutter/material.dart';
import 'package:frontend/card/screens/consumption.dart';

class ExpenseAnalyticsScreen extends StatefulWidget {
  const ExpenseAnalyticsScreen({super.key});

  @override
  State<ExpenseAnalyticsScreen> createState() => _ExpenseAnalyticsScreenState();
}

class _ExpenseAnalyticsScreenState extends State<ExpenseAnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumption();
  }
}
