import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/card_screen/registration_modal.dart';
import 'package:frontend/card/widgets/card_stack.dart';
import 'package:frontend/utils/app_colors.dart';

class CardStorage extends StatelessWidget {
  final int? myCardFlag;
  const CardStorage({super.key, required this.myCardFlag});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          color: AppColors.mainWhite,
        ),
        ClipRect(
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
        Container(
          padding: myCardFlag == 1
              ? EdgeInsets.only(left: 60, right: 60, top: 80, bottom: 80)
              : EdgeInsets.zero,
          child: myCardFlag == 1
              ? const CardStack()
              :const RegistrationModal()
                )
      ],
    );
  }
}
