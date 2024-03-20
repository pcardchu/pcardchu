// import 'package:flutter/material.dart';
// import 'package:frontend/card/widgets/next_btn.dart';
//
// class CardOcr extends StatefulWidget {
//   // 스캔 화면을 호출하는 함수
//   final Function scan;
//
//   const CardOcr({
//     super.key,
//     required this.scan,
//   });
//
//   @override
//   State<CardOcr> createState() => _CardOcrState();
// }
//
// class _CardOcrState extends State<CardOcr> {
//   // 카드 정보 입력 Form Key
//   final GlobalKey<FormState> formKey = GlobalKey();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(''),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios_new),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: SafeArea(
//         child: SizedBox(
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             children: [
//               Expanded(
//                 child: SizedBox(),
//               ),
//               Container(
//                 margin: const EdgeInsets.only(
//                   left: 35,
//                   right: 35,
//                   bottom: 22,
//                 ),
//                 child: NextBtn(
//                   title: '스캔하기',
//                   onPressed: (){
//                     widget.scan();
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
