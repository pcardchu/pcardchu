import 'package:flutter/material.dart';
import 'package:frontend/home/models/card_info_model.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/card/screens/card_detail_screen.dart';

import '../../utils/screen_util.dart'; // CardDetailScreen을 import하세요

class ExampleCard extends StatelessWidget {
  final CardInfoModel model;

  const ExampleCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    var cardWidth = ScreenUtil.w(70);
    var cardHeight = cardWidth * 1.4;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CardDetailScreen(cardId: model.cardId),
          ),
        );
      },
      child: Center(
        child: Container(
          width: ScreenUtil.w(65),
          height: cardHeight,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(17)),
            color: Colors.white,
          ),
          child: model.cardImage != null
              ? Image.network(
            model.cardImage!,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              // 로딩 실패 시 기본 이미지 표시
              return Image.asset('assets/images/xox_logo.png', fit: BoxFit.cover);
            },
          )
              : Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: const [Color(0xFFFF3868), Color(0xFFFFB49A)],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${model.name}',
                    style: AppFonts.scDream(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 30,),
                  Image.asset('assets/images/xox_logo.png', width: 36, height: 36, fit: BoxFit.cover),
                  SizedBox(height: 12),
                  Text(
                    '카드 이미지가 존재하지 않습니다.',
                    style: AppFonts.suit(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
