import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/next_btn.dart';

class CardForm extends StatelessWidget {
  /// 카드 정보 입력 Form Key
  final GlobalKey<FormState> formKey;

  /// 카드 번호 스캔 값
  final String scanNumber;

  /// 카드 번호 텍스트창 값
  final String? cardInputNumber;

  /// 제출 버튼을 누를때 카드 번호 인풋값을 저장하는 함수
  final FormFieldSetter<String> onCardNumSaved;

  const CardForm({
    super.key,
    required this.formKey,
    required this.onCardNumSaved,
    required this.scanNumber,
    required this.cardInputNumber,
  });

  @override
  Widget build(BuildContext context) {
    /// 텍스트폼필드 데코
    const textDeco = InputDecoration(
      label: Text(
        '카드번호',
        style: TextStyle(
          fontSize: 12.0,
          color: Color(0xff8F99A5),
        ),
      ),

      /// 각 상태마다 보더 지정
      /// 안눌렀을때
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),

      /// 포커스됐을때
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),

      /// 눌렀을때
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
    );

    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(height: 50.0),

          /// 카드 번호 입력창
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                /// 스캔 값이 자동으로 들어가게
                initialValue: scanNumber,

                /// Form 제출 버튼이 눌렸을 때 실행
                onSaved: onCardNumSaved,

                /// 유효성 검증
                validator: validator,
                decoration: textDeco,
              ),
            ),
          ),

          Text('확인용 : $cardInputNumber'),

          /// 제출 버튼
          NextBtn(
            onPressed: submitOnPressed,
            title: '등록하기',
          ),
        ],
      ),
    );
  }

  /// 제출 버튼 콜백함수
  void submitOnPressed() {
    /// 유효성 검증을 통과 하면
    /// TextFormField의 onSaved 수행
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    }
  }

  /// 유효성 검사 함수
  /// 16자리인지 체크
  String? validator(String? val) {
    if (val?.length != 16) {
      return '정확한 값을 입력 해 주세요';
    }
    return null;
  }
}
