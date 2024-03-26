import 'package:flutter/material.dart';
import 'package:frontend/card/screens/card_registration_completion.dart';
import 'package:frontend/card/widgets/card_registration_modal.dart';
import 'package:frontend/card/widgets/company_info_form.dart';
import 'package:frontend/card/widgets/company_registration.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:provider/provider.dart';

class CardCompanyInfo extends StatefulWidget {
  const CardCompanyInfo({super.key});

  @override
  State<CardCompanyInfo> createState() => _CardCompanyInfoState();
}

class _CardCompanyInfoState extends State<CardCompanyInfo> {
  // 카드사 회원 정보 입력 Form Key
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 키패드 나와도 위젯 재배치 안하기
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: AppColors.mainWhite,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context); // 이전 페이지로 이동
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          color: AppColors.mainWhite,
          child: Center(
            child: Container(
              color: AppColors.mainWhite,
              width: ScreenUtil.w(85),
              child: Column(
                children: [
                  // 화면 메인 부분
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '카드사 정보를 입력해주세요',
                              style: AppFonts.suit(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack,
                              ),
                            ),
                          ],
                        ),
                        // 카드사 회원 정보 입력 Form
                        CompanyInfoForm(
                          formKey: formKey,
                          idOnSaved: idOnSaved,
                          pwOnSaved: pwOnSaved,
                        ),
                        const SizedBox(height: 30),
                        // 카드사 회원가입 하러가기 위젯
                        const CompanyRegistration(),
                      ],
                    ),
                  ),
                  // 하단 확인 버튼
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: submitOnPressed,
                          child: const Text('확인'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 제출 버튼 콜백 함수
  /// 다음 페이지로 넘어간다
  void submitOnPressed() async {
    /// 유효성 검증을 통과 하면
    /// TextFormField의 onSaved 수행
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      /// 카드 등록 POST 요청
      await context.read<CardProvider>().cardRegistration();

      // 입력받은 정보로 POST 요청을 했을때 카드 등록이 가능한지 체크용
      // false라면 등록 불가능 하다는 모달창을 띄우는데 사용됩니다
      bool isPossible =
          context.read<CardProvider>().cardRegisterResult?['data'];

      // 카드 등록 불가한 정보라면
      // 카드 등록 불가 다이얼로그를 보여줍니다
      if (!isPossible) {
        showDialog(
            context: context,
            builder: (_) {
              return CardRegistrationModal();
            });
      }
      // 카드 등록 가능한 정보라면
      // 등록 완료 페이지로 이동
      else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CardRegistrationCompletion(),
          ),
        );
      }
    }
  }

  /// id 입력 유효성 검사를 통과했을때 실행되는 함수
  void idOnSaved(String? val) {
    context.read<CardProvider>().setCompanyId(val!);
  }

  /// pw 입력 유효성 검사를 통과했을때 실행되는 함수
  /// 결과값을 bool형식으로 프로바이더에 저장한다
  void pwOnSaved(String? val) {
    context.read<CardProvider>().setCompanyPw(val!);
  }
}
