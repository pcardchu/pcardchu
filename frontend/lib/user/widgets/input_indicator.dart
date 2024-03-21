import 'package:flutter/material.dart';
import 'package:frontend/providers/password_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:provider/provider.dart';

class InputIndicator extends StatefulWidget {
  @override
  _InputIndicatorState createState() => _InputIndicatorState();
}

class _InputIndicatorState extends State<InputIndicator> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _shakeAnimation;

  @override
  void initState() {
    super.initState();
    final passwordProvider = Provider.of<PasswordProvider>(context, listen: false);
    passwordProvider.clearAll();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    // 흔들림 애니메이션. 좌우로 -10.0에서 10.0까지 이동합니다.
    _shakeAnimation = Tween<double>(begin: 10, end: -10).animate(_controller!)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller!.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller!.stop(); // 애니메이션이 끝나면 정지합니다.
          passwordProvider.clearInput();
        }
      });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final passwordProvider = Provider.of<PasswordProvider>(context);
    final inputLength = passwordProvider.inputValue.length;

    // 비밀번호 길이가 6에 도달하면 흔들림 애니메이션을 시작합니다.
    if(inputLength == 6 && _controller!.status != AnimationStatus.forward) {
      _controller!.forward(from: 0.0);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: passwordProvider.wrongCount >= 1,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Text(
              "비밀번호가 맞지 않아요(${passwordProvider.wrongCount}/5)",
              style: TextStyle(color: AppColors.mainRed, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _shakeAnimation!,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimation!.value * (_controller!.value <= 0.1 ? 0 : 1), 0),
              child: child!,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              final bool isActive = index < inputLength;
              final double size = isActive ? 40 : 35;

              return AnimatedContainer(
                duration: Duration(milliseconds: 250),
                curve: Curves.ease,
                margin: EdgeInsets.all(4),
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.mainBlue : AppColors.bottomGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }),
          ),
        ),

      ],
    );
  }
}
