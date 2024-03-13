// // screens/pin_input_screen.dart
// import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart';
// import 'package:provider/provider.dart';
//
//
// class PinInputScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final passwordProvider = Provider.of<PasswordProvider>(context, listen: false);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("6자리 비밀번호 입력"),
//       ),
//       body: Center(
//         child: Pinput(
//           length: 6,
//           onCompleted: (pin) {
//             passwordProvider.validatePassword(pin);
//             if (passwordProvider.isValid) {
//               // Navigate or show a success message
//             } else {
//               // Show an error message
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
