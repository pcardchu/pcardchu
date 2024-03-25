import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';

/// 카드사 회원정보를 입력하는 Form
class CompanyInfoForm extends StatelessWidget {
  /// 카드사 회원 정보 입력 Form Key
  final GlobalKey<FormState> formKey;

  /// id 입력 유효성 검사를 통과했을때 실행되는 함수
  final FormFieldSetter<String> idOnSaved;

  /// pw 입력 유효성 검사를 통과했을때 실행되는 함수
  final FormFieldSetter<String> pwOnSaved;

  const CompanyInfoForm({
    super.key,
    required this.formKey,
    required this.idOnSaved,
    required this.pwOnSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(height: 20),
          // 카드사 아이디 입력창
          TextFormField(
            style: AppFonts.suit(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.textBlack,
            ),
            maxLines: 1,
            maxLength: 19,
            decoration: InputDecoration(
              // 라벨
              labelText: '아이디',
              // 라벨 스타일
              labelStyle: AppFonts.suit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.lightGrey,
              ),
              // 글자수 체크 텍스트 안보이게
              counterText: '',
            ),
            // Form 제출 버튼이 눌렸을때 실행
            onSaved: idOnSaved,
            // 유효성 검증
            validator: idValidator,
          ),
          SizedBox(height: 25),
          // 카드사 비밀번호 입력창
          TextFormField(
            style: AppFonts.suit(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.textBlack,
            ),
            maxLines: 1,
            maxLength: 19,
            decoration: InputDecoration(
              // 라벨
              labelText: '비밀번호',
              // 라벨 스타일
              labelStyle: AppFonts.suit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.lightGrey,
              ),
              // 글자수 체크 텍스트 안보이게
              counterText: '',
            ),
            // Form 제출 버튼이 눌렸을때 실행
            onSaved: pwOnSaved,
            // 유효성 검증
            validator: pwValidator,
            // 입력이 안보이게
            obscureText: true,
          ),
        ],
      ),
    );
  }

  /// id 입력 유효성 검증 함수
  String? idValidator(String? val) {
    if (val == null || val.isEmpty) {
      return '값을 입력해주세요';
    } else {
      return null;
    }
  }

  /// pw 입력 유효성 검증 함수
  String? pwValidator(String? val) {
    if (val == null || val.isEmpty) {
      return '값을 입력해주세요';
    } else {
      return null;
    }
  }
}
