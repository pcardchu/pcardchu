import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ConfettiOverlay {
  final BuildContext context;
  late ConfettiController _controller;
  OverlayEntry? _overlayEntry;

  ConfettiOverlay({required this.context}) {
    _controller = ConfettiController(duration: const Duration(milliseconds: 500));
  }

  void show() {
    if (_overlayEntry != null) {
      // 이미 오버레이가 존재한다면 제거
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)?.insert(_overlayEntry!);

    // 애니메이션이 진행 중이 아닐 때만 애니메이션 재생
    if (_controller.state != ConfettiControllerState.playing) {
      _controller.play();
    }
  }

  void dispose() {
    _controller.dispose();
    _overlayEntry?.remove();
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(builder: (context) {
      return IgnorePointer(
        child: Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _controller,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            child: Container(color: Colors.transparent), // 배경을 투명하게 설정합니다.
          ),
        ),
      );
    });
  }
}
