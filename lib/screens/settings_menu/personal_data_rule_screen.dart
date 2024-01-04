import 'package:dodal_app/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const PERSONAL_DATA_PAGE_URL =
    'https://seolhs04.notion.site/2773f46e28f4490e8843fc864a42eef4';

class PersonalDataRuleScreen extends StatelessWidget {
  PersonalDataRuleScreen({super.key});

  final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(AppColors.systemWhite)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(PERSONAL_DATA_PAGE_URL));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('개인정보처리방침'),
      ),
      body: Center(child: WebViewWidget(controller: controller)),
    );
  }
}
