import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';
import 'package:provider/provider.dart';

class CardForm extends StatefulWidget {
  // 카드 정보 입력 Form Key
  final GlobalKey<FormState> formKey;

  // 카드 번호 텍스트창 값
  final String? cardInputNumber;

  // 제출 버튼을 누를때 카드 번호 인풋값을 저장하는 함수
  final FormFieldSetter<String> onCardNumSaved;

  const CardForm({
    super.key,
    required this.formKey,
    required this.onCardNumSaved,
    required this.cardInputNumber,
  });

  @override
  State<CardForm> createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> {
  @override
  Widget build(BuildContext context) {
    String? scanNumber = context.watch<CardProvider>().scanNumber;

    // 텍스트폼필드 스타일
    const textDeco = InputDecoration(
      // 각 상태마다 보더 지정
      // 안눌렀을때
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      // 포커스됐을때
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      // 눌렀을때
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      // 글자수 체크 텍스트 안보이게
      counterText: '',
    );

    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          const SizedBox(height: 50),
          // 카드 번호 입력창
          Expanded(
            child: TextFormField(
              style: AppFonts.suit(
                fontSize: 25,
                fontWeight: FontWeight.w900,
                color: AppColors.textBlack,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              maxLength: 19,
              initialValue: scanNumber,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 받음
                CardNumberInputFormatter(), // 사용자 정의 입력 포맷터 사용
              ],
              // Form 제출 버튼이 눌렸을 때 실행
              onSaved: widget.onCardNumSaved,
              // 유효성 검증
              validator: validator,
              decoration: textDeco,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// 유효성 검사 함수
  /// 0000-0000-0000-0000 형식에 맞는지 체크
  String? validator(String? val) {
    // 정규 표현식 패턴
    RegExp regex = RegExp(r'^[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{4}$');

    // 입력된 문자열이 정규 표현식에 맞는지 확인
    if (val == null || !regex.hasMatch(val) || val.isEmpty) {
      return '정확한 값을 입력해주세요';
    } else {
      return null;
    }
  }
}

// 사용자 입력을 포맷팅하는 커스텀 TextInputFormatter 정의
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = StringBuffer();
    int j = 0;
    for (int i = 0; i < newValue.text.length; i++) {
      // 숫자만 추가
      if ('0123456789'.contains(newValue.text[i])) {
        newText.write(newValue.text[i]);
        j++;
        // 4글자마다 하이픈 추가 (맨 끝에는 추가하지 않음)
        if (j % 4 == 0 && j != 16) {
          newText.write('-');
        }
      }
    }
    // 새로운 포맷된 값 반환
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}