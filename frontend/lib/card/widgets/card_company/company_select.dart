import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/card_company/company_wg.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:provider/provider.dart';

// 카드등록 페이지 카드사 선택 위젯
class CompanySelect extends StatefulWidget {
  // 카드사 선택을 했는지 체크용
  final bool isSelected;
  final VoidCallback onSelected;

  const CompanySelect({
    super.key,
    required this.isSelected, required this.onSelected,
  });

  @override
  State<CompanySelect> createState() => _CompanySelectState();
}

class _CompanySelectState extends State<CompanySelect> {
  @override
  Widget build(BuildContext context) {
    // 카드사 정보 리스트
    // 카드사 로고, 카드사 이름
    final companyList = context.watch<CardProvider>().companyList;

    // 선택한 카드사 인덱스
    int selectedIndex = context.watch<CardProvider>().companyIndex;

    return Expanded(
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 한 줄에 3개의 위젯
            crossAxisSpacing: 8, // 가로 간격
            mainAxisSpacing: 8, // 세로 간격
          ),
          itemCount: companyList.length,
          itemBuilder: (context, index) {
            // 카드사 위젯
            return CompanyWg(
              company: companyList[index],
              isSelected: index == selectedIndex,
              onTap: () {
                // 선택한 카드사의 인덱스 갱신
                context.read<CardProvider>().setCompanyIndex(index);
                widget.onSelected();
              },
            );
          }),
    );
  }
}
