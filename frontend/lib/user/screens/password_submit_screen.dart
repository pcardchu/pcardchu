import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/animations/fade_slide_animation.dart';
import 'package:frontend/animations/fade_transition_page_route.dart';
import 'package:frontend/animations/slide_transition_page_route.dart';
import 'package:frontend/home/screens/home_screen.dart';
import 'package:frontend/providers/user_info_provider.dart';
import 'package:frontend/user/screens/login_screen.dart';
import 'package:frontend/user/screens/scond_screen.dart';
import 'package:frontend/user/widgets/gender_button.dart';
import 'package:frontend/user/widgets/user_info_dialog.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:provider/provider.dart';

class PasswordSubmitScreen extends StatefulWidget {
  const PasswordSubmitScreen({super.key});

  @override
  State<PasswordSubmitScreen> createState() => _PasswordSubmitScreenState();
}

class _PasswordSubmitScreenState extends State<PasswordSubmitScreen> {
  final FocusNode _yearFocusNode = FocusNode();
  final List<String> _months = List.generate(12, (index) => '${index + 1}');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _yearFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfoProvider>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            SingleChildScrollView(
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
                                  onChanged: (value) => userInfo.year = value,
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
                                  value: userInfo.month.isNotEmpty ? userInfo.month : null,
                                  onChanged: (newValue) => userInfo.month = newValue ?? '',
                                  items: [
                                    DropdownMenuItem<String>(
                                      value: null, // '월 선택' 항목에 대한 value를 null로 설정
                                      child: Text('', style: AppFonts.suit(color: Colors.black, fontWeight: FontWeight.w500),),
                                    ),
                                  ]..addAll(_months.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, style: AppFonts.suit(color: AppColors.mainBlue, fontWeight: FontWeight.w500),),
                                    );
                                  }).toList()),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: TextField(
                                  onChanged: (value) => userInfo.day = value,
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GenderButton(gender: '남성', selectedGender: userInfo.gender,
                                  onTap: () {
                                    userInfo.gender = '남성';
                                    FocusScope.of(context).requestFocus(FocusNode());
                                  }
                              ),
                              const SizedBox(width: 16,),
                              GenderButton(gender: '여성', selectedGender: userInfo.gender,
                                  onTap: () {
                                    userInfo.gender = '여성';
                                    FocusScope.of(context).requestFocus(FocusNode());
                                  }
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: userInfo.isAllFieldsFilled,
                      child: SizedBox(
                        height: 45,
                        width: ScreenUtil.w(85),
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return UserInfoDialog(
                                  year: userInfo.year,
                                  month: userInfo.month,
                                  day: userInfo.day,
                                  gender: userInfo.gender,
                                  onConfirm: () {
                                    Navigator.of(context).pop(); // 다이얼로그 닫기
                                    Navigator.of(context).push(SlideTransitionPageRoute(page: const SecondScreen()));
                                  },
                                );
                              },
                            );
                          },
                          child: const Text('계속하기'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
