import 'package:flutter/material.dart';
import 'package:frontend/card/screens/registration_web_view.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';

/// 카드사 회원가입 하러가기 위젯
class CompanyRegistration extends StatefulWidget {
  const CompanyRegistration({super.key});

  @override
  State<CompanyRegistration> createState() => _CompanyRegistrationState();
}

class _CompanyRegistrationState extends State<CompanyRegistration> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '카드사 아이디와 비밀번호가 없으신가요?',
              style: AppFonts.suit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.lightGrey,
              ),
            ),
            // 카드사 회원가입 하러가기 버튼
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bottomGrey,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                minimumSize: const Size(100, 30),
              ),
              // 버튼을 눌렀을때
              // 카드 등록 정보를 확인한다
              onPressed: onPressed,
              child: Row(
                children: [
                  Text(
                    '카드사 회원가입하러 가기',
                    style: AppFonts.suit(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: AppColors.textBlack,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 버튼 클릭시 카드사 회원가입 웹뷰 보여주기
  void onPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RegistrationWebView(),
      ),
    );
  }
}
