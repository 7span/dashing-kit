import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

///Use this as
///context.pushRoute(WebViewRoute(title: 'Title',url: 'URL',),);
@RoutePage()
class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    super.key,
    @QueryParam() this.url,
    @QueryParam() this.title,
  });

  final String? url;
  final String? title;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController webViewController = WebViewController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController();

    unawaited(
      webViewController.setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() {
              isLoading = false;
            });
          },
        ),
      ),
    );

    unawaited(
      webViewController.loadRequest(Uri.parse(widget.url ?? '')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        title: widget.title,
        automaticallyImplyLeading: true,
        backgroundColor: context.colorScheme.white,
      ),
      body:
          !isLoading
              ? const Center(child: AppCircularProgressIndicator())
              : WebViewWidget(controller: webViewController),
    );
  }
}
