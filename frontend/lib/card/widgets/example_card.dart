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
        child: Image.asset(
          model.cardImage ?? 'assets/images/xox_logo.png', // 기본 이미지 경로를 추가하세요.
          fit: BoxFit.fill,
        ));
  }
}
