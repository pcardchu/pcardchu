import 'package:flutter/material.dart';
import 'package:frontend/providers/user_info_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/card/widgets/my_register_card.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/card/screens/card_registration.dart';
import 'package:frontend/providers/card_list_provider.dart';

class CardStack extends StatefulWidget {
  const CardStack({Key? key}) : super(key: key);

  @override
  State<CardStack> createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> {
  @override
  Widget build(BuildContext context) {
    // 여기서 CardListProvider를 context를 통해 접근
    final cardListProvider = Provider.of<CardListProvider>(context);
    final userProvider = Provider.of<UserInfoProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${userProvider.userName}님의 카드 ⚡',
          style: AppFonts.scDream(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: AppColors.mainWhite),
        ),
        SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => CardRegistration()));
            },
            child: Row(
              children: [
                Text(
                  '새 카드 등록하기',
                  style: AppFonts.suit(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: AppColors.mainWhite),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFD9D9D9), size: 14),
              ],
            ),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.mainWhite,
              backgroundColor: Colors.transparent,
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ]),
        SizedBox(height: 60),
        // 조건부 렌더링
        Center(child: MyRegisterCard()),
        SizedBox(height: 10),
        Align(
          alignment: Alignment.center,
          child: Text(
            '카드를 선택해주세요',
            style: AppFonts.suit(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: AppColors.mainWhite),
          ),
        )
      ],
    );
  }
}
