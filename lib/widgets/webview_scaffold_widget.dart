import 'dart:io';
import 'dart:ui';

import 'package:app/blocs/webview_screen/webview_screen_bloc.dart';
import 'package:app/widgets/no_connection_widget.dart';
import 'package:connectivity_helper/blocs/connectivity/connectivity_bloc.dart';
import 'package:connectivity_helper/blocs/connectivity/connectivity_event.dart';
import 'package:connectivity_helper/blocs/connectivity/connectivity_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class WebviewScaffoldWidget extends StatelessWidget {
  final String urlWebview;
  final Function(String url) onDownload;
  final PullToRefreshController pullToRefreshController;
  final InAppWebViewController webViewController;
  final WebviewScreenBloc webviewScreenBloc;
  final Function(InAppWebViewController webViewController) setWebViewController;
  final FloatingActionButton floatingActionButton;
  final bool useAppbar;
  final String titleAppbar;
  final ConnectivityBloc connectivityBloc;

  WebviewScaffoldWidget({
    @required this.urlWebview,
    @required this.onDownload,
    @required this.pullToRefreshController,
    @required this.webViewController,
    @required this.webviewScreenBloc,
    @required this.setWebViewController,
    this.floatingActionButton,
    this.useAppbar = false,
    this.titleAppbar = '',
    @required this.connectivityBloc
  });

  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        useOnDownloadStart: true,
        verticalScrollBarEnabled: false,
        useShouldInterceptAjaxRequest: true,
        clearCache: false,
        disableContextMenu: false,
        cacheEnabled: true,
        javaScriptEnabled: true,
        javaScriptCanOpenWindowsAutomatically: true,
        transparentBackground: true,
        useShouldInterceptFetchRequest: true,
        userAgent: ("SmallRank Shops App"),
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: (useAppbar) ? AppBar(
          backgroundColor: Color(0xFF0C8160),
          elevation: 0,
          centerTitle: true,
          title: Text('${titleAppbar}'),
          leading: IconButton(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            icon: Platform.isIOS ? Icon(
              (Icons.arrow_back_ios),
            ) : Icon((Icons.arrow_back_rounded)),
            onPressed: () => Navigator.pop(context),
          )
      ) : null,
      resizeToAvoidBottomInset: false,
      floatingActionButton: (this.floatingActionButton != null) ? this.floatingActionButton : null,
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => this.webviewScreenBloc,
            ),
            BlocProvider(
              create: (context) => this.connectivityBloc,
            )
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener(
                bloc: this.connectivityBloc,
                listener: (context, ConnectivityState connectivityState) {
                  print('ConnectivityBloc : ');
                  print(connectivityState.message);

                  if (connectivityState.message.contains('failed connect to network')) {
                    //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => NoConnectionWidget()), (route) => false);
                  }
                },
              )
            ],
            child: BlocBuilder<WebviewScreenBloc, WebviewScreenState>(
              bloc: this.webviewScreenBloc,
              builder: (context, WebviewScreenState webviewScreenState) {
                return buildInAppWebView(context);
              },
            ),
          )
        ),
      ),
    );
  }

  Widget buildInAppWebView(context) {
    return InAppWebView(
      key: webViewKey,
      initialUrlRequest: URLRequest(url: Uri.parse("${urlWebview}")),
      initialOptions: options,
      pullToRefreshController: pullToRefreshController,
      onWebViewCreated: (controller) {
        setWebViewController(controller);
      },
      onLoadHttpError: (controller, url, statusCode, description) {
        print('Test : ');
        print(statusCode);
      },
      onLoadStart: (controller, url) {
        //setIsLoading(true);
        webviewScreenBloc.add(UpdateWebviewScreenEvent(
            isLoading: true
        ));
      },
      onLoadStop: (controller, url) async {
        //setIsLoading(false);
        webviewScreenBloc.add(UpdateWebviewScreenEvent(
            isLoading: false
        ));
        pullToRefreshController.endRefreshing();
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        Uri uri = navigationAction.request.url;

        print(uri.toString());
        print(uri.host);

        if (![ "http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
          if (await canLaunch(uri.toString())) {
            await launch(uri.toString()).whenComplete(() async {
              //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => SplashScreen()), (route) => false);
              print('URL TEST :');
              print(uri.host);
              if (uri.host.contains('api.whatsapp.com')) {
                print('goBack');

                if (await controller.canGoBack()) {
                  controller.goBack();
                }
              }
            });
            return NavigationActionPolicy.CANCEL;
          }
        }

        return NavigationActionPolicy.ALLOW;
      },
      androidOnPermissionRequest: (controller, origin, resources) async {
        return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
      },
      onLoadError: (controller, url, code, message) {
        print('error');

        pullToRefreshController.endRefreshing();
      },
      androidOnReceivedTouchIconUrl: (controller, url, precomposed) {
        print('androidOnReceivedTouchIconUrl');
        print(url);
      },
      onUpdateVisitedHistory: (controller, url, androidIsReload) {
      },
      onCreateWindow: (controller, createWindowRequest) async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Container(
                width: MediaQuery.of(context).size.width,
                height: 400,
                child: InAppWebView(
                  // Setting the windowId property is important here!
                  windowId: createWindowRequest.windowId,
                  initialOptions: InAppWebViewGroupOptions(
                    android: AndroidInAppWebViewOptions(
                      builtInZoomControls: true,
                      thirdPartyCookiesEnabled: true,
                    ),
                    crossPlatform: InAppWebViewOptions(
                        cacheEnabled: true,
                        javaScriptEnabled: true,
                        userAgent: "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36"
                    ),
                  ),
                  onWebViewCreated: (InAppWebViewController controller) {},
                  onCreateWindow: (controller, createWindowAction) => handleWindow(context, controller, createWindowRequest),
                  onCloseWindow: (controller) {},
                ),
              ),
            );
          },
        );

        return true;
      },
      onConsoleMessage: (controller, consoleMessage) {},
      onDownloadStart: (controller, url) async {
        onDownload(Uri.parse("$url").toString());
      },
    );
  }

  Future<bool> handleWindow(context, controller, createWindowRequest) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: 400,
            child: InAppWebView(
              // Setting the windowId property is important here!
              windowId: createWindowRequest.windowId,
              initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(
                  builtInZoomControls: true,
                  thirdPartyCookiesEnabled: true,
                ),
                crossPlatform: InAppWebViewOptions(
                    cacheEnabled: true,
                    javaScriptEnabled: true,
                    userAgent: "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36"
                ),
              ),
              onWebViewCreated: (InAppWebViewController controller) {

              },
              onCloseWindow: (controller) {
                // On Facebook Login, this event is called twice,
                // so here we check if we already popped the alert dialog context
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        );
      },
    );

    return true;
  }
}
