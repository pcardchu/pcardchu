import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/user_info_provider.dart';

import '../widgets/profile_info.dart'; // UserInfoProvider의 경로를 확인해주세요.

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

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: userInfo.newBirthDay, // UserInfoProvider에서 생년월일 정보를 가져옵니다.
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
      if (pickedDate != null && pickedDate != userInfo.birthDay) {
        setState(() {
          userInfo.newBirthDay = pickedDate;
        });
      }
    }

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



            Column(
              children: [
                SizedBox(height: ScreenUtil.h(2.5),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '생년월일',
                      style: AppFonts.suit(
                        color: AppColors.textBlack,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Text("${userInfo.birthDay.toString().split('T')[0]}"),
                    ),

                  ],
                ),
                SizedBox(height: ScreenUtil.h(2.5),),

              ],
            ),

            Column(
              children: [
                SizedBox(height: ScreenUtil.h(2.5),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '성별',
                      style: AppFonts.suit(
                        color: AppColors.textBlack,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    _buildGenderButtons()
                  ],
                ),
                SizedBox(height: ScreenUtil.h(2.5),),
              ],
            ),

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
                        setState(() {
                          userInfo.isBiometric = value!;
                        });
                      },
                    ),

                  ],
                ),
                SizedBox(height: ScreenUtil.h(2.5),),
              ],
            ),
            ProfileInfo(title: '간편 비밀번호', value: '변경하기', showArrowIcon: true,
              onTap: () {

                print("프로필 정보 변경하기");
              },),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderButtons() {
    final userInfo = Provider.of<UserInfoProvider>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            // UserInfoProvider의 newGender 속성을 '남자'로 업데이트
            userInfo.newGender = '남자';
          },
          child: Text('남자'),
          style: ElevatedButton.styleFrom(
            backgroundColor: userInfo.newGender == '남자' ? Colors.blue : Colors.grey,
          ),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            // UserInfoProvider의 newGender 속성을 '여자'로 업데이트
            userInfo.newGender = '여자';
          },
          child: Text('여자'),
          style: ElevatedButton.styleFrom(
            backgroundColor: userInfo.newGender == '여자' ? Colors.pink : Colors.grey,
          ),
        ),
      ],
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
