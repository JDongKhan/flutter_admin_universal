import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'web_view_progress.dart';

class WebViewForPlatform extends StatefulWidget {
  final String? url;
  final String? htmlContentString;
  final String? title;
  final bool? hideAppBar;
  final bool? hideAppBarExt;

  const WebViewForPlatform({
    super.key,
    this.url,
    this.htmlContentString,
    this.title,
    this.hideAppBar,
    this.hideAppBarExt,
  });

  @override
  State<WebViewForPlatform> createState() => _WebViewForPlatformState();
}

class _WebViewForPlatformState extends State<WebViewForPlatform> {
  late WebViewController _webViewController;

  String? _title;

  final WebViewProgressController _progressController = WebViewProgressController();

  bool _closeBtn = false;

  @override
  void initState() {
    _title = widget.title;
    //初始化controller
    _webViewController = WebViewController();
    _webViewController.setUserAgent(Network.userAgent);
    _webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    _webViewController.setBackgroundColor(const Color(0x00000000));
    _webViewController.setNavigationDelegate(
      NavigationDelegate(
        //进度
        onProgress: (int progress) {
          // Update loading bar.
        },
        //页面开始
        onPageStarted: (String url) {
          _progressController.show();
          logger.d('[WebView]onPageStarted:$url');
        },
        //页面请求结束
        onPageFinished: (String url) {
          logger.d('[WebView]onPageFinished:$url');
          _webViewController.runJavaScriptReturningResult('document.title').then(
            (value) {
              if (widget.title == null) {
                setState(() {
                  _title = value.toString();
                });
              }
              _progressController.dismiss();
            },
          );
          _webViewController.canGoBack().then((value) {
            if (_closeBtn != value) {
              setState(() {
                _closeBtn = value;
              });
            }
          });
        },
        //资源请求错误
        onWebResourceError: (WebResourceError error) {
          logger.d('[WebView]onWebResourceError:${error.description}');
          _progressController.dismiss();
        },
        //请求拦截
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );

    String? htmlContentString = widget.htmlContentString;
    String? url = widget.url;
    String localUrl = '';
    bool isLocal = false;
    if (url != null) {
      final bool isRemote = url.startsWith('http') || url.startsWith('https');
      isLocal = !isRemote;
      if (isRemote) {
        localUrl = url;
      } else {
        if (Platform.isAndroid) {
          localUrl = '/android_asset/flutter_assets/$url';
        } else {
          localUrl = '/Frameworks/App.framework/flutter_assets/$url';
        }
      }
    }

    if (htmlContentString != null) {
      _webViewController.loadHtmlString(htmlContentString);
    } else if (isLocal) {
      // _loadHtmlAssets()
      //     .then((value) => {_webViewController.loadRequest(value)});
      _webViewController.loadFile(localUrl);
    } else {
      Map<String, String> header = {};
      _webViewController.loadRequest(Uri.parse(localUrl), headers: header);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget? leftWidget;
    if (Navigator.canPop(context)) {
      leftWidget = _buildAppBarLeft();
    }
    return WillPopScope(
      onWillPop: () async {
        bool canGoBack = await _webViewController.canGoBack();
        if (canGoBack) {
          _webViewController.goBack();
          return false;
        }
        return true;
      },
      child: Column(
        children: [
          //appbar
          if (widget.hideAppBar != true)
            _commonAppBar(
              title: _title ?? widget.title ?? '',
              leftWidget: (true != widget.hideAppBarExt) ? leftWidget : null,
            ),
          WebViewProgress(
            controller: _progressController,
          ),
          Expanded(
            child: WebViewWidget(
              controller: _webViewController,
            ),
          ),
        ],
      ),
    );
  }

  Future<Uri> _loadHtmlAssets(String url) async {
    String htmlPath = await rootBundle.loadString(url);
    return Uri.dataFromString(
      htmlPath,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    );
  }

  ///通用APP bar 统一后退键
  Widget _buildAppBarLeft() {
    return GestureDetector(
      onTap: () {
        _webViewController.canGoBack().then((value) {
          if (value) {
            _webViewController.goBack();
          } else {
            Navigator.of(context).pop();
          }
        });
      },
      child: Container(
        // color: Colors.red,
        padding: const EdgeInsets.only(left: 20, right: 0),
        alignment: Alignment.centerLeft,
        child: const Icon(
          Icons.arrow_back_ios,
        ),
      ),
    );
  }

  Widget _commonAppBar({
    Widget? leftWidget,
    String? title,
    List<Widget>? rightWidget,
    Color bgColor = Colors.white,
  }) {
    return Container(
      color: bgColor,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: (true == widget.hideAppBarExt) ? 1 : 44,
          // color: Colors.blue,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              leftWidget ?? Container(),
              if (_closeBtn) const CloseButton(),
              Expanded(
                child: Text(
                  '$title',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              if (rightWidget != null) ...rightWidget,
            ],
          ),
        ),
      ),
    );
  }
}
