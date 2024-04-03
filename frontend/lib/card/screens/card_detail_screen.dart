import 'package:flutter/material.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:provider/provider.dart';

import '../../providers/card_detail_provider.dart';
import '../../utils/app_colors.dart';
import '../widgets/card_detail/detail_benefit.dart';

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
        scrolledUnderElevation: 0,
      ),
      backgroundColor: AppColors.mainWhite,
      body: Container(
        color: AppColors.mainWhite,
        width: ScreenUtil.screenWidth,
        child: loading
          ? Container()
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardInfo(context),
              Container(
                margin: EdgeInsets.symmetric(vertical: 23),
                height: 10,
                color: AppColors.bottomGrey,
              ),
              _buildTransactionList(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 23),
                height: 16,
                color: AppColors.bottomGrey,
              ),
              _buildBenefitsSummary(),
            ],
          ),
        )
      )
    );
  }

  Widget _buildCardInfo(BuildContext context) {
    // Replace with actual data
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Center(
                child: Container(
                  color: Colors.amber,
                  width: ScreenUtil.w(56),
                  height: ScreenUtil.h(36),
                )),
            SizedBox(height: 20,),
            Text(
              '이번 달 xx님이 쓴 금액',
              style: AppFonts.scDream(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: AppColors.textBlack,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                '9xx,xxx원',
                style: AppFonts.suit(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppColors.mainBlue,
                ),
              ),
            ),
            SizedBox(height: 12,),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                '삼성 카드',
                style: AppFonts.suit(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.lightGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    // Replace with actual data
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '14일 목요일',
                style: AppFonts.suit(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.lightGrey,
                ),
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 3, // replace with actual count
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple,
                  ),
                  title: Text('3,900원', style: AppFonts.suit(fontSize: 12, color: AppColors.grey, fontWeight: FontWeight.w800),),
                  subtitle: Text('쇼핑',  style: AppFonts.suit(fontSize: 10, color: AppColors.grey, fontWeight: FontWeight.w600),),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitsSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '지금까지 이런 혜택을',
              style: AppFonts.suit(fontSize: 20, color: AppColors.textBlack, fontWeight: FontWeight.w800),
            ),
            Text(
              '이용했어요',
              style: AppFonts.suit(fontSize: 20, color: AppColors.textBlack, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 30,),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            children: [
              // 혜택 이미지
              SizedBox(
                height: 46,
                width: 46,
                child: SizedBox(
                  child: Image.asset('assets/images/category_2.png')
                ),
              ),
              SizedBox(width: 25),
              Container(
                width: ScreenUtil.w(50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 혜택 종류
                    Text(
                      '교통',
                      style: AppFonts.suit(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey),
                    ),
                    // 혜택 정보
                    Text(
                      '000,000원 할인',
                      style: AppFonts.suit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
          ],
        ),
      ),
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
