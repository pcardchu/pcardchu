import 'package:flutter/material.dart';
import 'package:frontend/home/models/card_info_model.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/card/screens/card_detail_screen.dart'; // CardDetailScreen을 import하세요

class ExampleCard extends StatelessWidget {
  final CardInfoModel model;

  const ExampleCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CardDetailScreen(cardId: model.cardId),
          ),
        );
      },
      child: Container(
        width: 300,
        height: 420,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                Image.asset('assets/images/xox_logo.png', fit: BoxFit.cover),
                SizedBox(height: 20),
                Text(
                  '카드 이미지가 존재하지 않습니다.',
                  style: AppFonts.suit(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
