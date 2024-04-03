import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/screen_util.dart';


class ProfileInfo extends StatelessWidget {
  final String title;
  final String value;
  final bool showArrowIcon;
  final VoidCallback? onTap;

  const ProfileInfo({
    Key? key,
    required this.title,
    required this.value,
    this.showArrowIcon = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: ScreenUtil.h(2.5)),
        Row(
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
            InkWell(
              onTap: showArrowIcon ? onTap ?? () => print('변경하기') : null,
              child: Row(
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
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ]
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: ScreenUtil.h(2.5)),
      ],
    );
  }
}
