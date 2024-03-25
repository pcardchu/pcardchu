import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/animations/fade_slide_animation.dart';
import 'package:frontend/animations/fade_transition_page_route.dart';
import 'package:frontend/animations/slide_transition_page_route.dart';
import 'package:frontend/home/screens/home_screen.dart';
import 'package:frontend/user/screens/login_screen.dart';
import 'package:frontend/user/screens/scond_screen.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';

class MoreInfoScreen extends StatefulWidget {
  const MoreInfoScreen({super.key});

  @override
  State<MoreInfoScreen> createState() => _MoreInfoScreenState();
}

class _MoreInfoScreenState extends State<MoreInfoScreen> {
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  String? _selectedMonth;
  String? _selectedGender;
  final List<String> _months = List.generate(12, (index) => '${index + 1}');

  final FocusNode _yearFocusNode = FocusNode();

  //모든 필드가 채워졌는지 확인하는 함수
  bool get _isAllFieldsFilled {
    return _yearController.text.isNotEmpty &&
        _dayController.text.isNotEmpty &&
        _selectedMonth != null &&
        _selectedGender != null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _yearFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: ScreenUtil.h(10),),
                Text(
                  "생일과 성별을 입력해주세요",
                  style: AppFonts.suit(fontWeight: FontWeight.w700, color: AppColors.mainBlue, fontSize: 22),
                ),
                SizedBox(
                  width: ScreenUtil.w(85),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: _yearController,
                              focusNode: _yearFocusNode,
                              decoration: const InputDecoration(
                                labelText: '연도',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: '월',
                              ),
                              value: _selectedMonth,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedMonth = newValue;
                                });
                              },
                              items: _months
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: AppFonts.suit(color: AppColors.mainBlue, fontWeight: FontWeight.w500),),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: TextField(
                              controller: _dayController,
                              decoration: const InputDecoration(
                                labelText: '일',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 버튼들 사이의 간격을 균등하게 배치
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  _selectedGender = '남성';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _selectedGender == '남성' ? AppColors.mainBlue : AppColors.gray, // 선택된 성별에 따라 버튼 색상 변경
                              ),
                              child: Text('남성'),
                            ),
                          ),
                          const SizedBox(width: 8), // 버튼 사이의 간격
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  _selectedGender = '여성';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _selectedGender == '여성' ? AppColors.mainBlue : AppColors.gray, // 선택된 성별에 따라 버튼 색상 변경
                              ),
                              child: Text('여성'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
