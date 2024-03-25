import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:frontend/home/widgets/TopThreeConsumeCard.dart';
import 'package:frontend/home/widgets/ToListCard.dart';
import 'package:frontend/home/widgets/CosumeDifferCard.dart';

class HomeSecondScreen extends StatefulWidget {
  const HomeSecondScreen({super.key});

  @override
  State<HomeSecondScreen> createState() => _HomeSecondScreenState();
}

class _HomeSecondScreenState extends State<HomeSecondScreen> {
  final List<Widget> items = [
    TopThreeConsumeCard(),
    ToListCard(),
    ConsumeDifferCard(),
    TopThreePopularCard(),
    ToRegisterCard(),
    TimeAnalyzeCard(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainWhite,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: AppColors.mainWhite,
      body: SafeArea(
        child: Center(
            child: Container(
          width: ScreenUtil.w(90),
          child: ListView.separated(
            itemCount: items.length,
            itemBuilder: (context, index) {
              // 아이템 빌더
              return items[index];
            },
            separatorBuilder: (context, index) => VerticalSpace(), // 간격을 설정해줍니다
          ),
        )),
      ),
    );
  }
}

class TimeAnalyzeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil.h(20),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: Color(0xFFFAD7D7),
      ),
    );
  }
}

class ToRegisterCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil.h(20),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: Color(0xFFFCDABC),
      ),
    );
  }
}

class TopThreePopularCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil.h(20),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: Color(0xFFF7D6F0),
      ),
    );
  }
}

class VerticalSpace extends StatelessWidget {
  final double? height;

  const VerticalSpace({this.height});

  @override
  Widget build(BuildContext context) {
    final double finalHeight = height ?? ScreenUtil.h(1); // 기본값을 10.h로 설정합니다.
    return SizedBox(height: finalHeight);
  }
}




