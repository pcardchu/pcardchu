import 'package:flutter/material.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 카드사별 회원가입페이지 웹뷰
class RegistrationWebView extends StatefulWidget {
  const RegistrationWebView({super.key});

  @override
  State<RegistrationWebView> createState() => _RegistrationWebViewState();
}

class _RegistrationWebViewState extends State<RegistrationWebView> {
  @override
  Widget build(BuildContext context) {
    // 선택한 카드사 회원가입 페이지 url을 가져온다.
    final url = Uri.parse(context.read<CardProvider>().companyUrl);

    // 웹뷰 컨트롤러
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(url);

    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}
