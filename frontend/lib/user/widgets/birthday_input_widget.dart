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
            onChanged: (value) => userInfoProvider.year = value,
            focusNode: yearFocusNode,
            decoration: const InputDecoration(labelText: '연도'),
            keyboardType: TextInputType.datetime,
            onSubmitted: (_) => monthFocusNode.requestFocus(),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: TextField(
            onChanged: (value) => userInfoProvider.month = value,
            focusNode: monthFocusNode,
            decoration: const InputDecoration(labelText: '월'),
            keyboardType: TextInputType.datetime,
            onSubmitted: (_) => dayFocusNode.requestFocus(),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: TextField(
            onChanged: (value) => userInfoProvider.day = value,
            focusNode: dayFocusNode,
            decoration: const InputDecoration(labelText: '일'),
            keyboardType: TextInputType.datetime,
          ),
        ),
      ],
    );
  }
}
