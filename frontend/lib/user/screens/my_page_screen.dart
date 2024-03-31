import 'package:flutter/material.dart';
import 'package:frontend/user/screens/edit_mypage_screen.dart';

import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            // TextButton을 Padding으로 감싸 추가적인 간격을 제공합니다.
            padding: const EdgeInsets.only(right: 36.0), // 오른쪽에만 패딩을 추가합니다.
            child: TextButton(
              onPressed: () {
                // 수정 페이지로 이동하는 로직을 여기에 추가
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => EditMyPageScreen()));
              },
              child: Text(
                '수정',
                style: AppFonts.suit(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.textBlack),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.mainWhite,
                backgroundColor: Colors.transparent,
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            SizedBox(height: 40), // 상단에 여백 추가
            Image.asset('assets/images/profile_icon.png',),
            SizedBox(height: 40), // 이미지와 이름 사이 여백 추가

            _buildProfileInfo('닉네임', '어쩌구'),

            _buildProfileInfo('생년월일', '1999.03.03'),

            _buildProfileInfo('성별', '여성'),

            _buildProfileInfo('간편 비밀번호', '변경하기', showArrowIcon: true),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(String title, String value,
      {bool showArrowIcon = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
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
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
