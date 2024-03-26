import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/consumption_tab_1.dart';
import 'package:frontend/card/widgets/consumption_tab_2.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';

class ConsumptionTapbar extends StatefulWidget {
  const ConsumptionTapbar({super.key});

  @override
  State<ConsumptionTapbar> createState() => _ConsumptionTapbarState();
}

/// 개인 소비 패턴 탭바 위젯
/// 애니메이션 프레임당 한번씩 콜백 호출을 위해 SingleTickerProviderStateMixin 사용
class _ConsumptionTapbarState extends State<ConsumptionTapbar>
    with SingleTickerProviderStateMixin {
  // 탭바 컨트롤러
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  /// 라벨 텍스트 스타일
  TextStyle tabTextStyle = AppFonts.scDream(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textBlack,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.mainBlue,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            // 탭바 라벨
            tabs: [
              Column(
                children: [
                  Text(
                    '내 소비',
                    style: tabTextStyle,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              Column(
                children: [
                  Text(
                    '카드 추천',
                    style: tabTextStyle,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              ConsumptionTab1(),
              ConsumptionTab2(),
            ],
          ),
        ),
      ],
    );
  }
}
