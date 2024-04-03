import 'package:flutter/material.dart';
import 'package:frontend/animations/fade_and_slide_transition_page_route.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:frontend/user/screens/edit_mypage_screen.dart';
import 'package:frontend/user/screens/password_screen.dart';
import 'package:frontend/user/widgets/profile_info.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/user_info_provider.dart';

import '../../animations/fade_transition_page_route.dart';
import '../../providers/password_provider.dart'; // UserInfoProvider의 경로를 확인해주세요.

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // UserInfoProvider로부터 유저 정보를 가져옵니다.
    final userInfo = Provider.of<UserInfoProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '회원 정보',
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 36.0),
            child: TextButton(
              onPressed: () {
                userInfo.assignNewData();
                final passwordProvider = Provider.of<PasswordProvider>(context, listen: false);
                passwordProvider.clearAll();

                Navigator.of(context).push(
                  FadeAndSlideTransitionPageRoute(
                      page: const PasswordScreen(isEdit: true,),
                      duration: const Duration(milliseconds: 200),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.mainWhite,
                backgroundColor: Colors.transparent,
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                '수정',
                style: AppFonts.suit(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.textBlack),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            SizedBox(height: ScreenUtil.h(5)),
            loginProvider.profileImageUrl != ''
                ? CircleAvatar(
              backgroundImage: NetworkImage(loginProvider.profileImageUrl),
              radius: 70.0,
            )
                : const CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile_icon.png'),
              radius: 70.0,
            ),
            SizedBox(height: ScreenUtil.h(5)),

            ProfileInfo(title: '닉네임', value: userInfo.userName, ),

            ProfileInfo(title: '생년월일', value: userInfo.birthDay, ),

            ProfileInfo(title: '성별', value: userInfo.gender, ),

            Column(
              children: [
                SizedBox(height: ScreenUtil.h(2.5),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '생체인증',
                      style: AppFonts.suit(
                        color: AppColors.textBlack,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Checkbox(
                      value: userInfo.isBiometric,
                      activeColor: AppColors.mainBlue,
                      onChanged: (bool? value) {
                      },
                    ),

                  ],
                ),
                SizedBox(height: ScreenUtil.h(2.5),),
              ],
            ),

            SizedBox(
              width: ScreenUtil.w(85),
              child: TextButton(
                onPressed: (){
                  loginProvider.logout(context);
                },
                child: Text('로그아웃', style: TextStyle(color: AppColors.mainBlue),),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(color: AppColors.mainBlue, width: 1),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
