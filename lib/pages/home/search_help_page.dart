import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SearchHelpPage extends StatefulWidget {
  @override
  _SearchHelpPageState createState() => _SearchHelpPageState();
}

class _SearchHelpPageState extends State<SearchHelpPage> {
  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String url = "http://192.168.0.150:3000";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: new WebView(
          initialUrl: url, // 加载的url
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController web) {
            // webview 创建调用，
            web.loadUrl(url);
            web.canGoBack().then((res) {
              print(res); // 是否能返回上一级
            });
            web.currentUrl().then((url) {
              print(url); // 返回当前url
            });
            web.canGoForward().then((res) {
              print(res); //是否能前进
            });
          },
          onPageFinished: (String value) {
            // webview 页面加载调用
          },
        ),
      ),
    );
  }
}
