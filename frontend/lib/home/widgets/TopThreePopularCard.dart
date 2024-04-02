import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:provider/provider.dart';

import '../../providers/top_three_popular_provider.dart';
import '../models/top_three_popular_model.dart';

class TopThreePopularCard extends StatefulWidget {
  const TopThreePopularCard({Key? key}) : super(key: key);

  @override
  _TopThreePopularCardState createState() => _TopThreePopularCardState();
}

class _TopThreePopularCardState extends State<TopThreePopularCard> {
  TopThreePopularModel? selectedData;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<TopThreePopularProvider>(context, listen: false);
      if (provider.consumeList.isEmpty) {
        provider.getTopThreeCategory().then((_) {
          if (mounted) {
            _selectRandomData(provider);
          }
        });
      } else {
        _selectRandomData(provider);
      }
    });
  }

  void _selectRandomData(TopThreePopularProvider provider) {
    if (provider.consumeList.isNotEmpty) {
      final randomIndex = Random().nextInt(provider.consumeList.length);
      selectedData = provider.consumeList[randomIndex];
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TopThreePopularProvider>(context);
    if (provider.consumeList != null && provider.consumeList.isNotEmpty && selectedData == null) {
      _selectRandomData(provider); // consumeList가 업데이트 되면 selectedData를 다시 설정
    }
    final loading = context.watch<TopThreePopularProvider>().loading;

    return SizedBox(
      height: ScreenUtil.h(26),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: const Color(0xFFF7D6F0),
        child: loading || selectedData == null
            ? Center(child: CircularProgressIndicator())
            : _buildCardContent(selectedData!),
      ),
    );
  }

  Widget _buildCardContent(TopThreePopularModel data) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${data.age} ${data.gender}이 선호하는 카드',
            style: AppFonts.suit(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textBlack),
          ),
          Text(
            'BEST 3',
            style: AppFonts.suit(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textBlack),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              margin: EdgeInsets.only(left: 10, top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.categoryList.asMap().entries.map((entry) {
                  int idx = entry.key;
                  String category = entry.value;
                  return Text(
                    '${idx + 1}. $category',
                    style: AppFonts.suit(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFA0478B)),
                  );
                }).toList(),
              ),
            ),
            Image.asset(
              'assets/images/medal_icon.png',
              width: ScreenUtil.w(21),
              height: ScreenUtil.w(21),
              fit: BoxFit.contain,
            )
          ]),
        ],
      ),
    );
  }
}
