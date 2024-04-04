import 'package:flutter/material.dart';
import 'package:frontend/card/models/card_model.dart';
import 'package:frontend/card/widgets/loading_modal.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

// 카드 신청 웹뷰 페이지
class CardWebView extends StatefulWidget {
  const CardWebView({
    super.key,
  });

  @override
  State<CardWebView> createState() => _CardWebViewState();
}

class _CardWebViewState extends State<CardWebView> {
  late WebViewController controller = WebViewController();
  /// 로딩 상태 관리
  bool isLoading = true;

  // 로딩이 끝나면 로딩 상태 관리 변수를 setState()를 이용해서 상태 변경을 하는데
  // initState()에서 하지 않고 로딩이 끝날때 setState를 수행하기 하면
  // setState()가 재빌드를 무조건 하기때문에 재빌드 >> 로딩끝 >> 로딩상태 변경을 위해 setState()수행 >> 재빌드
  // 무한 루프에 빠진다
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 처음 한번만 로딩 모달 띄우기
    WidgetsBinding.instance.addPostFrameCallback((_) => showLoadingModal());
    // 로딩 화면을 띄우기 위한 세팅 함수
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Container()
            : WebViewWidget(
                controller: controller,
              ),
      ),
    );
  }

  Future<void> loadData() async {
    // 카드 디테일 정보 가져오기
    CardModel? card = context.read<CardProvider>().cardDetail;
    // 카드 신청 웹페이지 주소
    Uri url = Uri.parse("https://paybooc.co.kr/app/paybooc/AppPbCard.do?exec=detail&cardGdsNo=101514&chnlCd=Mobile&coCd=C005");
    if (card!.registrationUrl != ""){
      url = Uri.parse(card.registrationUrl!);
    }
    // 웹뷰 컨트롤러
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(url)
      ..setNavigationDelegate(
        NavigationDelegate(
          // 로딩이 끝났을때 로딩 상태 정보를 수정
          onPageFinished: (String url) {
            setState(() {
              setState(() {
                Navigator.of(context).pop();
                isLoading = false;
              });
            });
          },
        ),
      );
  }

  /// 로딩중일때 보여지는 모달
  void showLoadingModal() {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return LoadingModal();
      },
    );
  }
}
