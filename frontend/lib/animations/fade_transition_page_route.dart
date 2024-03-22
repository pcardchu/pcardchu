import 'package:flutter/material.dart';

/// `FadeTransitionPageRoute`는 화면 전환 시 페이드 인(fade-in) 효과를 제공하는 페이지 라우트입니다.
///
/// 이 클래스는 `PageRouteBuilder`를 상속받아, 페이드 인 애니메이션을 사용한 커스텀 페이지 전환을 구현합니다.
/// 사용자는 전환 지속 시간을 조절할 수 있습니다.
class FadeTransitionPageRoute extends PageRouteBuilder {
  /// 전환될 페이지.
  final Widget page;

  /// 애니메이션의 지속 시간. 기본값은 500밀리초입니다.
  final Duration transitionDuration;

  /// 뒤로 가기 애니메이션의 지속 시간. 기본값은 500밀리초입니다.
  final Duration reverseTransitionDuration;

  /// `FadeTransitionPageRoute` 생성자.
  ///
  /// [page]는 전환될 페이지 위젯을 받습니다.
  /// [transitionDuration]과 [reverseTransitionDuration]을 통해 애니메이션의 지속 시간을 설정할 수 있습니다.
  FadeTransitionPageRoute({
    required this.page,
    this.transitionDuration = const Duration(milliseconds: 500),
    this.reverseTransitionDuration = const Duration(milliseconds: 500),
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
      // 페이드 인 애니메이션을 구현하는 부분
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: transitionDuration, // 전환 애니메이션 지속 시간 설정
    reverseTransitionDuration: reverseTransitionDuration, // 뒤로 가기 애니메이션 지속 시간 설정
  );
}
