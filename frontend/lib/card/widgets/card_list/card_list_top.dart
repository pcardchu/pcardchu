import 'package:flutter/material.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';

/// 카드 리스트 - 윗쪽 메인화면입니다.
class CardListTop extends StatelessWidget {
  final GlobalKey bottomKey;

  const CardListTop({
    super.key,
    required this.bottomKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Color(0xFFF5F5F5),
      // 컨테이너 높이 = 화면 전체 높이 - 앱바 높이 - 상태표시줄 높이
      height: MediaQuery.of(context).size.height -
          AppBar().preferredSize.height -
          MediaQuery.of(context).padding.top,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '더 좋은 카드는 없을까?',
            style: AppFonts.suit(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xff8F99A5),
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            '수많은 카드들을\n혜택별로 한눈에',
            style: AppFonts.scDream(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xff26282B),
            ),
          ),
          SizedBox(height: 90.0),
          Image.asset('assets/images/list_card_logo.png',
            width: ScreenUtil.w(72),
            fit: BoxFit.contain
          ),
          SizedBox(height: 120.0),
          // 스크롤 이동 버튼
          GestureDetector(
            child: Column(
              children: [
                Text(
                  '이용하러 가기',
                  style: AppFonts.suit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff8F99A5),
                  ),
                ),
                SizedBox(height: 12.0),
                Image.asset('assets/images/scroll_down_logo.png'
                ),
                SizedBox(height: 32.0),
              ],
            ),
            onTap: () {
              Scrollable.ensureVisible(
                // 바텀키 위젯으로 이동
                bottomKey.currentContext!,
                // 애니메이션 동작 시간
                duration: Duration(seconds: 1),
              );
            },
          ),
        ],
      ),
    );
  }
}
