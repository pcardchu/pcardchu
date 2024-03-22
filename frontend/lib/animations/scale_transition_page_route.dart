import 'package:flutter/cupertino.dart';

class ScaleTransitionPageRoute extends PageRouteBuilder {
  final Widget page;

  ScaleTransitionPageRoute({required this.page})
      : super(
      transitionDuration: Duration(milliseconds: 300),
      reverseTransitionDuration: Duration(milliseconds: 300),

    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) {
      // 시작 및 종료 값 설정
      var scaleTween = Tween<double>(begin: 0.85, end: 1.0);

      // Curve를 사용하여 애니메이션의 속도(가속도)를 조절합니다.
      var curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.decelerate, // 커브 타입
      );

      return ScaleTransition(
        scale: scaleTween.animate(curvedAnimation),
        child: child,
      );
    }

  );
}
