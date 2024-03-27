import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:rive/rive.dart';

/// 로딩중일때 보여지는 모달
class LoadingModal extends StatelessWidget {
  const LoadingModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        child: Container(
          padding: EdgeInsets.all(10),
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: AppColors.mainWhite,
            borderRadius: BorderRadius.circular(100),
          ),
          child: RiveAnimation.asset(
            'assets/images/card_animation.riv',
            animations: ['Timeline 1'],
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
