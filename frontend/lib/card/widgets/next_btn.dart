import 'package:flutter/material.dart';

/// 재사용 버튼입니다.
/// 버튼 텍스트에 들어갈 String과 onPressed 콜백함수를 받아야합니다.
class NextBtn extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const NextBtn({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    /// 버튼 스타일
    final _btnStyle = ElevatedButton.styleFrom(
      backgroundColor: Color(0xff051D40),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 35,
          right: 35,
          bottom: 22,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: _btnStyle,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'SUIT',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}