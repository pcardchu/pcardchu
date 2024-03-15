import 'package:flutter/material.dart';
import 'package:frontend/providers/password_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:provider/provider.dart';

class InputIndicator extends StatefulWidget {
  @override
  _InputIndicatorState createState() => _InputIndicatorState();
}

class _InputIndicatorState extends State<InputIndicator> {
  @override
  Widget build(BuildContext context) {
    final passwordProvider = Provider.of<PasswordProvider>(context);
    final inputLength = passwordProvider.inputValue.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        // 입력 시 크기 변화를 위한 계산
        final bool isActive = index < inputLength;
        final double size = isActive ? 40 : 35; // 활성화 시 크기 증가

        return AnimatedContainer(
          duration: Duration(milliseconds: 250),
          curve: Curves.ease, // 부드러운 애니메이션 효과
          margin: EdgeInsets.all(4),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isActive ? AppColors.mainBlue : AppColors.bottomGrey,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }
}
