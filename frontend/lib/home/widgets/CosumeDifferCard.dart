import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/consume_differ_provider.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/screen_util.dart';

class ConsumeDifferCard extends StatefulWidget {
  const ConsumeDifferCard({Key? key}) : super(key: key);

  @override
  _ConsumeDifferCardState createState() => _ConsumeDifferCardState();
}

class _ConsumeDifferCardState extends State<ConsumeDifferCard> {
  @override
  void initState() {
    super.initState();
    // 데이터를 가져오는 작업을 시작합니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(mounted) {
        final provider = Provider.of<ConsumeDifferProvider>(context, listen: false);
        provider.getConsumeDiffer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Provider를 통해 현재 로딩 상태와 데이터를 가져옵니다.
    final loading = context.watch<ConsumeDifferProvider>().loading;
    final data = context.watch<ConsumeDifferProvider>().diff;

    return SizedBox(
      height: ScreenUtil.h(26),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: const Color(0xFFC2F4D8),
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '내 또래의 ${data.gender}들은',
                        style: AppFonts.suit(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textBlack),
                      ),
                      Text(
                        '${data.lastMonth}월에 얼마나 썼을까?',
                        style: AppFonts.suit(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textBlack),
                      ),
                    ],
                  ),
                  Image.asset(
                    'assets/images/card_graph_icon.png',
                    width: ScreenUtil.w(20),
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil.h(4),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '유저님은 ${data.ageGroup} ${data.gender}에 비해',
                      style: AppFonts.suit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF61806F)),
                    ),
                    Text(
                      data.percent > 0
                          ? '평균 ${data.percent}% 많이 소비하고 있어요.'
                          : '평균 ${data.percent.abs()}% 적게 소비하고 있어요.',
                      style: AppFonts.suit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF61806F)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
