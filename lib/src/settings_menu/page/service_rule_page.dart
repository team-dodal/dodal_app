import 'package:dodal_app/src/common/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const SERVICE_RULE_PAGE_URL =
    'https://seolhs04.notion.site/1ec52a13a1334f8a9ea3ed6011339a3d';

class ServiceRulePage extends StatelessWidget {
  ServiceRulePage({super.key});

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
    ..loadRequest(Uri.parse(SERVICE_RULE_PAGE_URL));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이용 약관'),
      ),
      body: Center(child: WebViewWidget(controller: controller)),
    );
  }
}
