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

import 'package:frontend/card/widgets/loading_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();


      final cardListProvider = Provider.of<CardListProvider>(context, listen: false);
      cardListProvider.checkUserCards().then((_) {
        // 카드 리스트 확인 후 필요한 작업 수행
        // 여기서 UI 업데이트를 유발하는 코드가 있으면 안전하게 실행됩니다.
        // 예를 들어, 로딩 상태가 변경되어 로딩 모달을 닫는 경우:
        if (!cardListProvider.loading && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      }).catchError((error) {
        // 에러 처리
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
              if (provider.loading) {
                Future.microtask(() => showLoadingModal());
                return SizedBox(); // 로딩 중엔 아무것도 표시하지 않도록
              } else {
                final items = _createItemList(provider.isCardRegistered);
                return ListView.separated(
                  itemCount: items.length,
                  itemBuilder: (context, index) => items[index],
                  separatorBuilder: (context, index) => const VerticalSpace(),
                );
              }
            },
          ),
        ),
      ),
    );

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
