
import 'dart:async';
import 'dart:convert';
import 'package:ecom/models/checkoutSteps.dart';
import 'package:flutter/material.dart';
import 'package:ecom/payments/config.dart';
import 'package:ecom/utils/appTheme.dart';
import 'package:ecom/http/woohttprequest.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewTap extends StatefulWidget {
  final String initalUrl;
  StepTwo shippmentLine;

  WebViewTap(this.initalUrl, this.shippmentLine);

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewTap> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Stack(alignment: Alignment.topLeft,
          children: [
            WebView(
              initialUrl: widget.initalUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              // TODO(iskakaushik): Remove this when collection literals makes it to stable.
              // ignore: prefer_collection_literals
              javascriptChannels: <JavascriptChannel>[
                _toasterJavascriptChannel(context),
              ].toSet(),
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith(tapRedirectUrls["url"])) {
                  Map<String,String> shippmentLineDetail= {
                    "method_id":widget.shippmentLine.id.toString(),
                    "method_title":widget.shippmentLine.title,
                    "total":widget.shippmentLine.shippmentCost.toString(),
                  };

                WooHttpRequest().putNewOrder(context, "tap","Tap",shippmentLineDetail).then((value) {
                    Navigator.pushReplacementNamed(context, "/home");
                  });
                  return NavigationDecision.prevent;
                }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              gestureNavigationEnabled: true,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: EdgeInsets.only(top: 40),
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.arrow_back,
                    color: MainHighlighter,
                    size: 25,),
                )
            ),
          ],
        );
      }),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        final snackBar = SnackBar(
          content: Text(message.message),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
  }

}