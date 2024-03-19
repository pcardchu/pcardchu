import 'package:flutter/material.dart';
import 'package:frontend/card/models/card_model.dart';
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
  @override
  Widget build(BuildContext context) {
    // 카드 디테일 정보 가져오기
    CardModel? card = context.read<CardProvider>().cardDetail;

    // 카드 신청 웹페이지 주소
    final url = Uri.parse(card!.cardApplication!);
    // 웹뷰 컨트롤러
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(url)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) {
          print('시작');
        },
        onPageFinished: (_) {
          print('완료');
        },
      ));

    return Scaffold(
        body: SafeArea(
      child: WebViewWidget(
        controller: controller,
      ),
    ));
  }
}
