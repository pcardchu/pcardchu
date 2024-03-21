import 'package:flutter/material.dart';

/// CustomPageRoute combines both fading and sliding effects for the transition.
class FadeAndSlideTransitionPageRoute extends PageRouteBuilder {
  final Widget page;
  final Duration duration;
  final Offset beginOffset;

  FadeAndSlideTransitionPageRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 500),
    this.beginOffset = const Offset(0.0, 0.3), // Default is slide up
  }) : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) {
      // Slide transition
      var slideTween = Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOut));
      var slideAnimation = animation.drive(slideTween);

      // Fade transition
      var fadeTween = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeOut));
      var fadeAnimation = animation.drive(fadeTween);

      return FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: child,
        ),
      );
    },
  );
}
