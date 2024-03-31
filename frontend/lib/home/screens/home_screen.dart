import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:frontend/home/widgets/TopThreeConsumeCard.dart';
import 'package:frontend/home/widgets/ToListCard.dart';
import 'package:frontend/home/widgets/CosumeDifferCard.dart';
import 'package:frontend/home/widgets/TopThreePopularCard.dart';
import 'package:frontend/home/widgets/ToRegisterCard.dart';
import 'package:frontend/home/widgets/TimeAnalyzeCard.dart';
import 'package:provider/provider.dart';

import 'package:frontend/providers/card_list_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    /// 위젯 트리가 완전히 만들어졌을 때 호출되도록
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CardListProvider>(context, listen: false).checkUserCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainWhite,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: AppColors.mainWhite,
      body: Center(
        child: Container(
          width: ScreenUtil.w(90),
          child: Consumer<CardListProvider>(
            builder: (context, provider, child) {
              final items = _createItemList(provider.isCardRegistered);
              return ListView.separated(
                itemCount: items.length,
                itemBuilder: (context, index) => items[index],
                separatorBuilder: (context, index) => const VerticalSpace(),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _createItemList(bool isCardRegistered) {
    List<Widget> items = [
      TopThreeConsumeCard(),
      ToListCard(),
      TopThreePopularCard(),
    ];

    if (isCardRegistered) {
      items.addAll([
        ConsumeDifferCard(),
        TimeAnalyzeCard(),
      ]);
    } else {
      items.add(ToRegisterCard());
    }

    items.add(const VerticalSpace());
    return items;
  }
}

class VerticalSpace extends StatelessWidget {
  final double? height;

  const VerticalSpace({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    final double finalHeight = height ?? ScreenUtil.h(1);
    return SizedBox(height: finalHeight);
  }
}
