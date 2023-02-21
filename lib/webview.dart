import 'dart:io';
import 'package:fairstores/constants.dart';
import 'package:fairstores/main.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  final String title;
  final String url;
  const WebViewExample({Key? key, required this.title, required this.url})
      : super(key: key);

  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: Text(widget.title),
      ),
      body: const WebView(
        initialUrl:
            'https://app.enzuzo.com/policies/tos/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJDdXN0b21lcklEIjoxMDQ4OCwiQ3VzdG9tZXJOYW1lIjoiY3VzdC1IRk5mZHJGWCIsIkN1c3RvbWVyTG9nb1VSTCI6IiIsIlJvbGVzIjpbInJlZmVycmFsIl0sIlByb2R1Y3QiOiJlbnRlcnByaXNlIiwiaXNzIjoiRW56dXpvIEluYy4iLCJuYmYiOjE2NTQ3NjY4MzR9.79MRRO2i6_UIxhf3JK_UGqZMM8xb111xdvIrQUmFMsk',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
