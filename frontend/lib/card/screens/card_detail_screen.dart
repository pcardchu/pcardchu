import 'package:flutter/material.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:provider/provider.dart';

import '../../providers/card_detail_provider.dart';
import '../../utils/app_colors.dart';

class CardDetailScreen extends StatefulWidget {
  final int? cardId;

  const CardDetailScreen({super.key, required this.cardId});

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<CardDetailProvider>().loading;

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: AppColors.mainWhite,
        elevation: 0,
        // 뒤로가기 버튼
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: AppColors.mainWhite,
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardInfo(context),
            _buildTransactionList(),
            _buildBenefitsSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardInfo(BuildContext context) {
    // Replace with actual data
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Center(
              child: Container(
                color: Colors.amber,
                width: ScreenUtil.w(56),
                height: ScreenUtil.h(36),
              )),
          Text(
            '이번 달 xx님이 쓴 금액',
            style: AppFonts.scDream(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: AppColors.textBlack,
            ),
          ),
          Text(
            '9xx,xxx원',
            style: AppFonts.suit(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: AppColors.mainBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    // Replace with actual data
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '14일 동안의 지출',
            style: AppFonts.suit(fontSize: 20),
          ),
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 5, // replace with actual count
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.purple, // color based on category
                child: Icon(Icons.shopping_cart),
              ),
              title: Text('쇼핑'),
              subtitle: Text('3,900원'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBenefitsSummary() {
    // Replace with actual data
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '지금까지 이런 혜택을 이용했어요',
            style: AppFonts.suit(fontSize: 20),
          ),
        ),
        Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBenefitCategory('쇼핑', 980),
            _buildBenefitCategory('음식', 2165),
            _buildBenefitCategory('교통/주유', 3855),
          ],
        ),
      ],
    );
  }

  Widget _buildBenefitCategory(String category, int amount) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.purple, // color based on category
          child: Text(
            '₩$amount',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          category,
          style: TextStyle(
            color: AppColors.textBlack,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
