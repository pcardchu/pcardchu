import 'package:frontend/card/models/example_candidate_model.dart';
import 'package:flutter/material.dart';
import 'package:frontend/home/models/card_info_model.dart';

class ExampleCard extends StatelessWidget {
  //final ExampleCandidateModel candidate;
  final CardInfoModel model;

  const ExampleCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 400,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      child: model.cardImage != null
          ? Image.network(
              model.cardImage!,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                // 로딩 실패 시 기본 이미지 표시
                return Image.asset('assets/images/xox_logo.png', width: 36, height: 36,
                    fit: BoxFit.cover);
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
      ), // 기본 이미지
    );
  }
}
