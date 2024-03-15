import 'package:flutter/material.dart';

/// ShakeAnimation은 흔들림(shake) 애니메이션을 쉽게 구현할 수 있게 해주는 유틸리티 클래스입니다.
class ShakeAnimation {

  /// AnimationController를 생성합니다. 이 컨트롤러는 애니메이션의 진행을 관리합니다.
  ///
  /// [vsync]는 TickerProvider로서, 애니메이션의 타이머를 제공합니다.
  /// [duration]은 애니메이션의 지속 시간을 설정합니다. 기본값은 500밀리초입니다.
  static AnimationController createController(
      TickerProvider vsync, {
        Duration duration = const Duration(milliseconds: 500),
      }) {
    return AnimationController(
      duration: duration,
      vsync: vsync,
    );
  }

  /// 흔들림 애니메이션을 생성합니다. 이 애니메이션은 컨트롤러에 의해 조정됩니다.
  ///
  /// [controller]는 애니메이션의 진행을 관리하는 AnimationController입니다.
  /// [start]는 애니메이션 시작 위치의 오프셋을 설정합니다. 기본값은 0.0입니다.
  /// [end]는 애니메이션 끝 위치의 오프셋을 설정합니다. 기본값은 10.0입니다.
  /// [curve]는 애니메이션의 속도 곡선을 설정합니다. 기본값은 Curves.elasticIn입니다.
  static Animation<double> createShakeAnimation(
      AnimationController controller, {
        double start = 0.0,
        double end = 10.0,
        Curve curve = Curves.elasticIn,
      }) {
    // 흔들림 애니메이션의 범위를 정의합니다.
    return Tween<double>(begin: start, end: end).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // 애니메이션의 상태가 완료(Completed) 상태가 되면, 애니메이션을 역방향으로 실행합니다.
        controller.reverse();
      }
    });
  }
}
