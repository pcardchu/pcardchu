import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/user_info_provider.dart';

class BirthdayInputWidget extends StatelessWidget {
  final UserInfoProvider userInfoProvider;
  final FocusNode yearFocusNode;
  final FocusNode monthFocusNode;
  final FocusNode dayFocusNode;

  BirthdayInputWidget({
    Key? key,
    required this.userInfoProvider,
    required this.yearFocusNode,
    required this.monthFocusNode,
    required this.dayFocusNode,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            onChanged: (value) {
              userInfoProvider.year = value;
              if (value.length == 4) {
                FocusScope.of(context).requestFocus(monthFocusNode);
              }
            },
            maxLength: 4,
            focusNode: yearFocusNode,
            decoration: const InputDecoration(
                counterText: '',
                labelText: '연도'
            ),
            keyboardType: TextInputType.datetime,
            onSubmitted: (_) => monthFocusNode.requestFocus(),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: TextField(
            onChanged: (value) {
              userInfoProvider.month = value;
              if (value.length == 2) {
                FocusScope.of(context).requestFocus(dayFocusNode);
              }
            },
            maxLength: 2,
            focusNode: monthFocusNode,
            decoration: const InputDecoration(
                counterText: '',
                labelText: '월'
            ),
            keyboardType: TextInputType.datetime,
            onSubmitted: (_) => dayFocusNode.requestFocus(),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: TextField(
            onChanged: (value) => userInfoProvider.day = value,
            focusNode: dayFocusNode,
            maxLength: 2,
            decoration: const InputDecoration(
              counterText: '',
              labelText: '일'
            ),
            keyboardType: TextInputType.datetime,
          ),
        ),
      ],
    );
  }
}
