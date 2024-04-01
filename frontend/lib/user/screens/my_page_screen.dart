import 'package:flutter/material.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:frontend/user/screens/edit_mypage_screen.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/user_info_provider.dart'; // UserInfoProvider의 경로를 확인해주세요.

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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => EditMyPageScreen()));
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

            _buildProfileInfo('닉네임', userInfo.userName),

            _buildProfileInfo('생년월일', userInfo.birthDay),

            _buildProfileInfo('성별', userInfo.gender),

            _buildProfileInfo('간편 비밀번호', '변경하기', showArrowIcon: true),

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

  Widget _buildProfileInfo(String title, String value, {bool showArrowIcon = false}) {
    return Column(
      children: [
        SizedBox(height: ScreenUtil.h(2.5),),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppFonts.suit(
                color: AppColors.textBlack,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                Text(
                  value,
                  style: AppFonts.suit(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey,
                  ),
                ),
                if (showArrowIcon) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ]
              ],
            ),
          ],
        ),
        SizedBox(height: ScreenUtil.h(2.5),),
      ],
    );
  }
}
