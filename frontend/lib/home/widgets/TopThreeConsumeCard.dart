import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/top_three_consume_provider.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:frontend/home/models/top_three_consume_model.dart';

class TopThreeConsumeCard extends StatefulWidget {
  const TopThreeConsumeCard({Key? key}) : super(key: key);

  @override
  _TopThreeConsumeCardState createState() => _TopThreeConsumeCardState();
}

class _TopThreeConsumeCardState extends State<TopThreeConsumeCard> {
  TopThreeConsumeModel? selectedData;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<TopThreeConsumeProvider>(context, listen: false);
      if (provider.consumeList.isEmpty) {
        provider.getTopThreeCategory().then((_) {
          if (mounted) {
            _selectRandomData(provider);
            print("예쁘게 잘 호출");
          }
        });
      } else {

        _selectRandomData(provider);
        print("데이터는 그대로인데 랜덤으로 호출");
      }
    });
  }

  void _selectRandomData(TopThreeConsumeProvider provider) {
    if (provider.consumeList.isNotEmpty) {
      final randomIndex = Random().nextInt(provider.consumeList.length);
      selectedData = provider.consumeList[randomIndex];
      print("sd${selectedData}");
      print('좋아요');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<TopThreeConsumeProvider>().loading;
    final isAlready = context.watch<TopThreeConsumeProvider>().loadConsumeList;

    print(loading);
    print(selectedData);
    print(isAlready);

    return SizedBox(
      height: ScreenUtil.h(26),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: const Color(0xFFC5D8FC),
        child: loading || selectedData == null && !isAlready
            ? Center(child: CircularProgressIndicator())
            : _buildCardContent(selectedData!),
      ),
    );
  }

  Widget _buildCardContent(TopThreeConsumeModel data) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${data.age} ${data.gender}이 가장 많이 한 소비',
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
                        color: Color(0xFF365592)),
                  );
                }).toList(),
              ),
            ),
            Image.asset(
              'assets/images/donut_chart_icon.png',
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
