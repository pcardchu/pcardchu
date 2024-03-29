import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/card_stack.dart';
import 'package:frontend/utils/app_colors.dart';

class CardStorage extends StatelessWidget {
  const CardStorage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          color: AppColors.mainWhite,
        ),
        Expanded(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Container(
                alignment: Alignment.center,
                color: Colors.grey.shade800.withOpacity(0.6),
              ),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(left: 60, right: 60, top: 80, bottom: 80),
            child: Container(
          // decoration: BoxDecoration(
          //   border: Border.all(
          //     color: Colors.black,
          //     width: 1
          //   )
          // ),
              child: CardStack(),
        ))
      ],
    );
  }
}
