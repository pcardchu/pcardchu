import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/benefit_calculate_card.dart';
import 'package:frontend/card/widgets/one_day_consume_card.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/card_detail_provider.dart';
import '../../providers/user_info_provider.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(mounted) {
        final provider = Provider.of<CardDetailProvider>(context, listen: false);
        provider.getMyConsumption(widget.cardId.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardDetailProvider = Provider.of<CardDetailProvider>(context);
    final loading = cardDetailProvider.loading;
    //final cardDetailData = cardDetailProvider.cardDetailModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: AppColors.mainWhite,
        elevation: 0,
        // 뒤로가기 버튼
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
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
              _buildTransactionList(context),
              Container(
                margin: EdgeInsets.symmetric(vertical: 23),
                height: 16,
                color: AppColors.bottomGrey,
              ),
              _buildBenefitsSummary(context),
            ],
          ),
        )
      )
    );
  }

  Widget _buildCardInfo(BuildContext context) {
    final userProvider = Provider.of<UserInfoProvider>(context);
    final cardDetailProvider = Provider.of<CardDetailProvider>(context);
   final loading = cardDetailProvider.loading;

    final data = cardDetailProvider.cardDetailModel;

    if (data == null) {
    // cardDetailData가 null일 경우, 로딩 인디케이터 또는 대체 UI를 표시합니다.
    return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            Center(
                child: Container(
                  width: ScreenUtil.w(56),
                  height: ScreenUtil.h(36),
                  child: Image.network("${data.cardImage}"),
                )),
            const SizedBox(height: 20,),
            Text(
              '이번 달 ${userProvider.userName}님이 쓴 금액',
              style: AppFonts.scDream(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: AppColors.textBlack,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                NumberFormat('#,###원', 'ko_KR')
                    .format(data.useMoneyMonth),
                style: AppFonts.suit(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppColors.mainBlue,
                ),
              ),
            ),
            const SizedBox(height: 12,),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                '${data.cardCompany} | ${data.cardName}',
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

  Widget _buildTransactionList(BuildContext context) {
    final cardDetailProvider = Provider.of<CardDetailProvider>(context);
    // final loading = cardDetailProvider.loading;
    final data = cardDetailProvider.cardDetailModel?.todayUseHistory ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                '지난 24시간 나의 소비',
                style: AppFonts.suit(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: AppColors.lightGrey,
                ),
              ),
            ),
            Container(
              height: 200,
              margin: EdgeInsets.only(left: 20),
              child: ListView.separated(
                //ListView가 차지하는 공간을 자식 크기에 맞춤
                  //shrinkWrap: true,
                  // 부모 스크롤과 충돌 방지
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return SizedBox(height: 25);
                  },
                  // 소비 분야 위젯
                  separatorBuilder: (context, index) {
                    return OneDayConsumeCard(
                      index: index,
                    );
                  },
                  itemCount:
                  data!.length + 1
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitsSummary(BuildContext context) {
    final cardDetailProvider = Provider.of<CardDetailProvider>(context);
    // final loading = cardDetailProvider.loading;
    final data = cardDetailProvider.cardDetailModel?.useBenefit ?? {};

    if(data == null){
      return Text(
        '카드 혜택이 존재하지 않습니다',
        style: AppFonts.suit(fontSize: 20, color: AppColors.textBlack, fontWeight: FontWeight.w800),
      );
    }

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

            Container(
              height: 200,
              child: ListView.separated(
                //ListView가 차지하는 공간을 자식 크기에 맞춤
                //shrinkWrap: true,
                // 부모 스크롤과 충돌 방지
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    String benefitType = data.entries.elementAt(index).key;
                    int benefitAmount = data.entries.elementAt(index).value;
                    return BenefitCalculateCard(
                      benefitType: benefitType,
                      benefitAmount: benefitAmount,
                    );
                  },
                  // 소비 분야 위젯
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                  itemCount:
                  data!.entries.length
              ),
            ),
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
