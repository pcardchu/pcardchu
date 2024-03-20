import 'package:flutter/material.dart';

/// `SlideTransitionPageRoute`는 화면 전환 시 슬라이드 효과를 제공하는 페이지 라우트입니다.
///
/// 사용자는 전환 지속 시간과 애니메이션의 시작점을 조절할 수 있습니다.
class SlideTransitionPageRoute extends PageRouteBuilder {
  final Widget page;
  final Offset beginOffset;

  SlideTransitionPageRoute({
    required this.page,
    this.beginOffset = const Offset(0.0, 1.0), //애니메이션 방향
    Duration transitionDuration = const Duration(milliseconds: 500), // 전체 애니메이션 지속 시간
    Duration reverseTransitionDuration = const Duration(milliseconds: 500), // 뒤로 가기 애니메이션 지속 시간
  }) : super(
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
      var end = Offset.zero;
      var curve = Curves.fastOutSlowIn; // 여기서 Curve를 조절하여 애니메이션의 가속도 조절
      var tween = Tween(begin: beginOffset, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: transitionDuration,
    reverseTransitionDuration: reverseTransitionDuration,
  );
}
