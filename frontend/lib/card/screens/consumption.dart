import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/consumption_tapbar.dart';
import 'package:frontend/providers/consumption_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:provider/provider.dart';

/// 개인 소비 패턴을 보여주는  페이지
class Consumption extends StatefulWidget {
  const Consumption({super.key});

  @override
  State<Consumption> createState() => _ConsumptionState();
}

class _ConsumptionState extends State<Consumption> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<ConsumptionProvider>().loading;

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: AppColors.mainWhite,
        // 뒤로가기 버튼 삭제
        automaticallyImplyLeading: false,
        // 톱니 버튼
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
              color: AppColors.textBlack,
              size: 28,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Container(
        color: AppColors.mainWhite,
        child: Center(
          child: loading
              ? CircularProgressIndicator()
              : Container(
                  color: AppColors.mainWhite,
                  // 화면 메인 컬럼
                  child: Column(
                    children: [
                      // 탭바
                      Expanded(
                        child: ConsumptionTapbar(),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  /// 내 소비 내역 정보 GET
  Future<void> loadData() async {
    // 내 소비내역 정보 배열에 정보가 없을때만 Get 호출
    if (!context.read<ConsumptionProvider>().loadMyConsumption) {
      await context.read<ConsumptionProvider>().getMyConsumption('1');
    }
    // 내 추천 카드 정보 배열에 정보가 없을때만 Get 호출
    if (!context.read<ConsumptionProvider>().loadMyRecommend) {
      await context.read<ConsumptionProvider>().getMyRecommend('1');
    }
  }
}
