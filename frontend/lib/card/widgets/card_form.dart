import 'package:flutter/material.dart';

class CardForm extends StatelessWidget {
  /// 카드 번호 입력 텍스트창 컨트롤러
  final TextEditingController numCtrl;

  /// 카드 정보 입력 Form Key
  final GlobalKey<FormState> formKey;

  /// 제출 버튼이 눌렸을떄 카드 번호 텍스트창 값을 저장하는 함수
  final FormFieldSetter<String> onCardNumSaved;

  const CardForm({
    super.key,
    required this.numCtrl,
    required this.formKey,
    required this.onCardNumSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          /// 카드 번호 입력창
          TextFormField(
            /// 카드 스캔을 할 경우 카드 번호를 입력창에 자동 수정
            controller: numCtrl,

            /// Form 제출 버튼이 눌렸을 때 실행
            onSaved: onCardNumSaved,
          ),

          SizedBox(height: 32.0),

          /// 제출 버튼
          ElevatedButton(
            onPressed: () {
              /// 유효성 검증을 통과 하면
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
              }
            },
            child: Text('제출'),
          ),
        ],
      ),
    );
  }
}
