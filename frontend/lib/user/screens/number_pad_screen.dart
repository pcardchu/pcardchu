import 'package:flutter/material.dart';
import 'package:frontend/home/screens/home_screen.dart';
import 'package:frontend/providers/password_provider.dart';
import 'package:frontend/user/widgets/custom_number_pad.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:provider/provider.dart';

class NumberInputScreen extends StatefulWidget {
  @override
  _NumberInputScreenState createState() => _NumberInputScreenState();
}

class _NumberInputScreenState extends State<NumberInputScreen> {
  // String _inputValue = "";

  @override
  Widget build(BuildContext context) {
    final passwordProvider = Provider.of<PasswordProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("커스텀 숫자 키패드"),
      ),
      body: Column(
        children: [
          // 임시 홈 스크린 버튼
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => HomeScreen(),
                ),
              );
            },
            child: Text('임시 홈스크린 버튼'),
          ),
          // 첫 번째 자식을 Flexible로 감싸서 비율을 지정합니다.
          Flexible(
            flex: 1, // 비율 설정 (1:1 비율을 위해 여기서는 1을 사용)
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child:
                  Center(child: Text("입력된 숫자: ${passwordProvider.inputValue}")),
            ),
          ),
          // 두 번째 자식을 Flexible로 감싸서 비율을 지정합니다.
          Flexible(
            flex: 1, // 비율 설정 (1:1 비율을 위해 여기서는 1을 사용)
            child: CustomNumberPad(),
          ),
        ],
      ),
    );
  }
}
