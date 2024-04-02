import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/user_info_provider.dart'; // UserInfoProvider의 경로를 확인해주세요.

class EditMyPageScreen extends StatefulWidget {
  const EditMyPageScreen({super.key});

  @override
  _EditMyPageScreenState createState() => _EditMyPageScreenState();
}

class _EditMyPageScreenState extends State<EditMyPageScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // UserInfoProvider로부터 유저 정보를 가져옵니다.
    final userInfo = Provider.of<UserInfoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '회원 정보 수정',
          style: AppFonts.scDream(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: AppColors.textBlack),
        ),
        backgroundColor: AppColors.mainWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 36.0),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.mainWhite,
                backgroundColor: Colors.transparent,
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                '저장',
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

            _buildProfileInfo('닉네임', userInfo.userName),

            _buildProfileInfo('생년월일', userInfo.birthDay),

            _buildProfileInfo('성별', userInfo.gender),

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
                        // 상태 업데이트
                        // setState(() {
                        //   userInfo.isBiometric = value!;
                        // });
                      },
                    ),

                  ],
                ),
                SizedBox(height: ScreenUtil.h(2.5),),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(String title, String value) {
    final TextEditingController _controller = TextEditingController(text: value);

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
            IntrinsicWidth(
              child: TextField(
                controller: _controller, // 위에서 생성한 TextEditingController를 지정합니다.
                style: AppFonts.suit(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mainBlue, // 직접 Colors.grey를 사용. AppColors.grey와 동일하다고 가정합니다.
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
        SizedBox(height: ScreenUtil.h(2.5),),
      ],
    );
  }
}
