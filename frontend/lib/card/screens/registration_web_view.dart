import 'package:flutter/material.dart';
import 'package:frontend/card/widgets/loading_modal.dart';
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
  late WebViewController controller = WebViewController();

  /// 로딩 상태 관리
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 처음 한번만 로딩 모달 띄우기
    WidgetsBinding.instance.addPostFrameCallback((_) => showLoadingModal());
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

  void loadData() {
    // 선택한 카드사 회원가입 페이지 url을 가져온다.
    final url = Uri.parse(context.read<CardProvider>().companyUrl);

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
}
