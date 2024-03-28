import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/animations/fade_slide_animation.dart';
import 'package:frontend/animations/fade_transition_page_route.dart';
import 'package:frontend/animations/shake_animation.dart';
import 'package:frontend/animations/slide_transition_page_route.dart';
import 'package:frontend/home/screens/home_screen.dart';
import 'package:frontend/providers/user_info_provider.dart';
import 'package:frontend/user/screens/login_screen.dart';
import 'package:frontend/user/screens/password_submit_screen.dart';
import 'package:frontend/user/screens/second_screen.dart';
import 'package:frontend/user/widgets/birthday_input_widget.dart';
import 'package:frontend/user/widgets/gender_button.dart';
import 'package:frontend/user/widgets/user_info_dialog.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:provider/provider.dart';

class MoreInfoScreen extends StatefulWidget {
  const MoreInfoScreen({super.key});

  @override
  State<MoreInfoScreen> createState() => _MoreInfoScreenState();
}

class _MoreInfoScreenState extends State<MoreInfoScreen> with SingleTickerProviderStateMixin {
  final FocusNode _yearFocusNode = FocusNode();
  final FocusNode _dayFocusNode = FocusNode();
  final FocusNode _monthFocusNode = FocusNode();

  ShakeAnimation? _shakeAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _yearFocusNode.requestFocus();
    });
    _shakeAnimation = ShakeAnimation(
      vsync: this,
      begin: 15, // 시작점을 -20으로 설정
      end: -15, // 끝점을 20으로 설정
      durationMilliseconds: 80, // 지속 시간을 300ms로 설정
    );
  }
  @override
  void dispose() {
    super.dispose();
    _shakeAnimation?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider = Provider.of<UserInfoProvider>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: ScreenUtil.h(10),),
                    Text(
                      "생일과 성별을 입력해 주세요",
                      style: AppFonts.suit(fontWeight: FontWeight.w700, color: AppColors.mainBlue, fontSize: 22),
                    ),
                    SizedBox(
                      width: ScreenUtil.w(85),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16.0),
                          AnimatedBuilder(
                            animation: _shakeAnimation!.controller,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(_shakeAnimation!.value * (_shakeAnimation!.controller.value <= 0.1 ? 0 : 1), 0),
                                child: child,
                              );
                            },
                            child: BirthdayInputWidget(
                              userInfoProvider: userInfoProvider,
                              yearFocusNode: _yearFocusNode,
                              monthFocusNode: _monthFocusNode,
                              dayFocusNode: _dayFocusNode,
                            ),
                          ),
                          Center(
                            // height: ScreenUtil.h(3),
                            child: Visibility(
                              visible: userInfoProvider.isWrongDate,
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  "생일을 확인해 주세요",
                                  style: TextStyle(
                                      color: AppColors.mainRed,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 19.0),
                          Visibility(
                            visible: userInfoProvider.isAllBirthdayFilled,
                            child:FadeSlideAnimation(
                              durationMilliseconds: 400,
                                beginOffset: const Offset(0, 1),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GenderButton(gender: '남성', selectedGender: userInfoProvider.gender,
                                        onTap: () {
                                          userInfoProvider.gender = '남성';
                                          FocusScope.of(context).requestFocus(FocusNode());
                                        }
                                    ),
                                    const SizedBox(width: 16,),
                                    GenderButton(gender: '여성', selectedGender: userInfoProvider.gender,
                                        onTap: () {
                                          userInfoProvider.gender = '여성';
                                          FocusScope.of(context).requestFocus(FocusNode());
                                        }
                                    ),
                                  ],
                                ),
                            )
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Column(
              children: [
                Visibility(
                  visible: userInfoProvider.isAllFieldsFilled,
                  child: FadeSlideAnimation(
                    durationMilliseconds: 400,
                    beginOffset: const Offset(0, 1),
                    child: SizedBox(
                      height: 45,
                      width: ScreenUtil.w(85),
                      child: ElevatedButton(
                        onPressed: () {
                          if (userInfoProvider.isValidDate()) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return UserInfoDialog(
                                  gender: userInfoProvider.gender,
                                  date: userInfoProvider.formatDate(),
                                  onConfirm: () {
                                    Navigator.of(context).pop(); // 다이얼로그 닫기
                                    userInfoProvider.initPasswordSubmit();
                                    Navigator.of(context).push(
                                        SlideTransitionPageRoute(page: const PasswordSubmitScreen())
                                    );
                                  },
                                );
                              },
                            );
                          } else {
                            _shakeAnimation?.startAnimation();
                            print("날짜 오류");
                          }
                        },
                        child: const Text('계속하기'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
