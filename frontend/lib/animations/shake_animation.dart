import 'package:flutter/material.dart';

class ShakeAnimation {
  final AnimationController controller;
  Animation<double>? shakeAnimation;
  final double begin;
  final double end;
  final int durationMilliseconds;

  ShakeAnimation({
    required TickerProvider vsync,
    this.begin = 0,
    this.end = -10,
    this.durationMilliseconds = 150,
  }) : controller = AnimationController(
    duration: Duration(milliseconds: durationMilliseconds),
    vsync: vsync,
  ) {
    initAnimation();
  }

  get value => shakeAnimation?.value;



  void initAnimation() {
    shakeAnimation = Tween<double>(begin: begin, end: end).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.stop(); // 애니메이션이 끝나면 정지합니다.
        }
      });
  }

  void startAnimation() {
    if (controller.status != AnimationStatus.forward) {
      controller.forward(from: 0.0);
    }
  }

  void dispose() {
    controller.dispose();
  }
}
