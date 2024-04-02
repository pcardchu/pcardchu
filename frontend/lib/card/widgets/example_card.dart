import 'package:frontend/card/models/example_candidate_model.dart';
import 'package:flutter/material.dart';

class ExampleCard extends StatelessWidget {
  final ExampleCandidateModel candidate;

  const ExampleCard(
      this.candidate, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 300,
        height: 400,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
    color: Colors.white
    ),
    child: Image.asset('assets/images/excard.png', fit: BoxFit.fill,)
    );
  }
}