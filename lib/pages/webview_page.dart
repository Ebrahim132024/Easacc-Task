import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/storage_service.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController controller;
  String url = "";

  @override
  void initState() {
    super.initState();
    loadWebUrl();
  }

  void loadWebUrl() async {
    url = await StorageService.loadUrl() ?? "https://google.com";

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    setState(() {}); // Update UI after controller ready
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Web View")),
      body: url.isEmpty
          ? Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: controller),
    );
  }
}
