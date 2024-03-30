import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/app_fonts.dart';

// 카드 디테일 페이지 하단 약관
class DetailTerms extends StatelessWidget {
  const DetailTerms({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _Terms(content: '피카추는 해당 카드사의 금융상품에 관한 계약 체결권한이 없습니다'),
        _Terms(content: '본 카드의 서비스 내용은 카드사 사정에 따라 사전 고지 후 변경 또는 중단될 수 있습니다'),
        _Terms(content: '카드 사용 전 반드시 상품 설명서와 약관을 읽어주세요'),
      ],
    );
  }
}

class _Terms extends StatelessWidget {
  final String content;

  const _Terms({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '* ',
          style: AppFonts.suit(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.lightGrey,
          ),
        ),
        Expanded(
          child: Text(
            content,
            softWrap: true,
            style: AppFonts.suit(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.lightGrey,
            ),
          ),
        ),
      ],
    );
  }
}
