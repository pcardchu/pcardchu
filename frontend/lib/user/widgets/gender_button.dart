import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';

class GenderButton extends StatelessWidget {
  final String gender;
  final String selectedGender;
  final VoidCallback onTap;

  const GenderButton(
      {Key? key, required this.gender, required this.selectedGender, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: gender == selectedGender
              ? AppColors.mainBlue
              : AppColors.gray,
        ),
        child: Text(gender),
      ),
    );
  }
}