import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';

class EditMyPageScreen extends StatefulWidget {
  const EditMyPageScreen({super.key});

  @override
  State<EditMyPageScreen> createState() => _EditMyPageScreenState();
}

class _EditMyPageScreenState extends State<EditMyPageScreen> {
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '내 정보 수정',
          style: AppFonts.scDream(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: AppColors.textBlack),
        ),
        backgroundColor: AppColors.mainWhite,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelText: '닉네임',
                labelStyle: AppFonts.suit(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.textBlack),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // 텍스트 필드의 둥근 모서리
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelText: '생년월일',
                labelStyle: AppFonts.suit(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.textBlack),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // 텍스트 필드의 둥근 모서리
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              '성별',
              style: AppFonts.suit(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: AppColors.textBlack),
            ),
            SizedBox(height: 20.0),
            ToggleButtons(
              borderColor: AppColors.lightGrey,
              fillColor: AppColors.bottomGrey,
              // 선택된 상태의 배경색
              borderWidth: 1,
              selectedBorderColor: Colors.grey,
              borderRadius: BorderRadius.circular(20.0),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 4),
                  child: Text('남성'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 4),
                  child: Text('여성'),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = i == index;
                  }
                });
              },
              isSelected: isSelected,
            ),
            Spacer(), // 나머지 공간을 모두 채움
            SizedBox(
              width: double.infinity, // 부모의 전체 너비
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainBlue, // 버튼의 배경색
                ),
                onPressed: () {
                  // 저장 버튼 동작을 여기에 구현
                },
                child: Text('저장', style: TextStyle(color: AppColors.mainWhite)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
