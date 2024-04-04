import 'package:flutter/material.dart';
import 'package:frontend/animations/slide_transition_page_route.dart';
import 'package:frontend/card/widgets/consumption/consumption_tapbar.dart';
import 'package:frontend/card/widgets/loading_modal.dart';
import 'package:frontend/providers/consumption_provider.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:frontend/user/screens/my_page_screen.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../user/screens/login_screen.dart';

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
    // 데이터 호출
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<ConsumptionProvider>().loading;
    final loginInfoProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: AppColors.mainWhite,
        // 뒤로가기 버튼 삭제
        automaticallyImplyLeading: false,
        // 톱니 버튼
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  SlideTransitionPageRoute(
                      page: const MyPageScreen(),
                      beginOffset: const Offset(0, 1)
              )
              );
            },
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
              ? Container()
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
    // 데이터를 불러와야 할때만 로딩 모달 띄우기
    if(!context.read<ConsumptionProvider>().loadMyConsumption ||
        !context.read<ConsumptionProvider>().loadMyRecommend){
      WidgetsBinding.instance.addPostFrameCallback((_) => showLoadingModal());

      // 내 소비내역 정보 배열에 정보가 없을때만 Get 호출
      // 인자는 유저 아이디
      await context.read<ConsumptionProvider>().getMyConsumption('1');
      // 내 추천 카드 정보 배열에 정보가 없을때만 Get 호출
      // 인자는 유저 아이디
      await context.read<ConsumptionProvider>().getMyRecommend('1');
      // 데이터를 다 불러왔으니 로딩 모달 끄기
      Navigator.of(context).pop();
    }

  }

  /// 로딩중일때 보여지는 모달
  Future<void> showLoadingModal() async{
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return LoadingModal();
      },
    );
  }
}
