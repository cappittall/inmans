import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart' as AAA;
import 'package:webview_flutter/src/webview.dart' as BBB;

import 'package:webview_flutter/webview_flutter.dart';
import 'package:inmans/a1/pages/pages.dart';
import 'package:inmans/services/database/database_manager.dart';
import 'package:inmans/a1/utils/navigate.dart';

import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as dom;

class PayTrPayment extends StatefulWidget {
  final String token;
  final depositOPData;

  const PayTrPayment({Key key, this.token, this.depositOPData})
      : super(key: key);

  @override
  _PayTrPaymentState createState() => _PayTrPaymentState();
}

class _PayTrPaymentState extends State<PayTrPayment> {
  WebViewController controller;

  String htmlData;

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    double width = screenSize.width;
    double height = screenSize.height - 150;

    htmlData = """
    <html>
        <body>
            <iframe  src="https://www.paytr.com/odeme/guvenli/${widget.token}" width="$width" height="$height">
            </iframe>
        </body>
    </html>
      
    """;

    dom.Document document = htmlParser.parse(htmlData);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 40,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Platform.isAndroid
            ? WebView(
                initialUrl: Uri.dataFromString(htmlData, mimeType: 'text/html')
                    .toString(),
                navigationDelegate: (BBB.NavigationRequest request) async {
                  if (request.url.contains("google")) {
                    navigate(context: context, page: const HomePage(), replace: true);

                    await DataBaseManager.cloudFirestore
                        .collection("users")
                        .doc('firebaseAuth.currentUser.uid')
                        .collection("operationHistory")
                        .doc()
                        .set(widget.depositOPData);
                    return NavigationDecision.prevent;
                  } else if (request.url.contains("facebook")) {
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
                gestureNavigationEnabled: true,
                javascriptMode: JavascriptMode.unrestricted,
              )
            : AAA.Html.fromDom(
                document: document,
                shrinkWrap: true,
                navigationDelegateForIframe: (AAA.NavigationRequest request) async {
                  if (request.url.contains("google")) {
                    navigate(context: context, page: const HomePage(), replace: true);
                    return AAA.NavigationDecision.prevent;
                  }
                  return AAA.NavigationDecision.navigate;
                },
              ),
      ),
    );
  }
}
