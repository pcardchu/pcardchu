// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:frontend/card/screens/card_ocr.dart';
// import 'package:frontend/card/widgets/next_btn.dart';
//
// /// 카드 등록 바텀시트 위젯입니다.
// class CardRegistrationBottom extends StatelessWidget {
//   const CardRegistrationBottom({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.2,
//       width: double.infinity,
//       child: Column(
//         children: [
//           Expanded(
//             child: SizedBox(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('대충 동의하라는 내용'),
//                 ],
//               ),
//             ),
//           ),
//           NextBtn(
//             title: '동의하기',
//             onPressed: () => onPressed(context),
//           ),
//         ],
//       ),
//     );
//   }
//   // 동의하기 버튼 콜백함수
//   void onPressed(BuildContext context) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (_) => CardOcr(),
//       ),
//     );
//   }
// }
