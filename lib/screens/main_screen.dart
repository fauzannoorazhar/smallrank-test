import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:app/blocs/webview_screen/webview_screen_bloc.dart';
import 'package:app/screens/setting_screen.dart';
import 'package:app/service_impl/version_service_impl.dart';
import 'package:app/widgets/no_connection_widget.dart';
import 'package:app/widgets/update_dialog_widget.dart';
import 'package:app/widgets/webview_scaffold_widget.dart';
import 'package:connectivity_helper/blocs/connectivity/connectivity_bloc.dart';
import 'package:connectivity_helper/blocs/connectivity/connectivity_event.dart';
import 'package:connectivity_helper/blocs/connectivity/connectivity_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_version_app/blocs/version_check/version_check_bloc.dart';
import 'package:flutter_version_app/widgets/version_helper.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  final PackageInfo packageInfo;

  MainScreen({@required this.packageInfo});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ReceivePort _port = ReceivePort();
  PullToRefreshController pullToRefreshController;
  InAppWebViewController webViewController;
  final WebviewScreenBloc webviewScreenBloc = new WebviewScreenBloc();
  final ConnectivityBloc connectivityBloc = new ConnectivityBloc(ConnectivityState(message: ''));
  VersionCheckBloc versionCheckBloc;
  DateTime currentBackPressTime;
  final GlobalKey webViewKey = GlobalKey();
  String urlLaunch = '';
  PackageInfo packageInfo;

  bool _isDialogShowing = false;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
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
    ));

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    /// TODO :
    versionCheckBloc = new VersionCheckBloc(VersionServiceImpl());
    versionCheckBloc.add(InitialLoadVersionEvent());
    connectivityBloc.add(CheckConnectivityEvent());
    webviewScreenBloc.add(InitialWebviewScreenEvent());
    /// TODO :
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        refreshWebview();
      },
    );

    /// TODO :
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState((){ });
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  void refreshWebview() async {
    if (Platform.isAndroid) {
      webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
    } else if (Platform.isIOS) {
      webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
    }
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  void _onDownload(String url) async {
    final status = await Permission.storage.request();

    if(status.isGranted) {
      final externalDir = await getExternalStorageDirectory();

      final id = await FlutterDownloader.enqueue(
        url: url,
        savedDir: externalDir.path,
        showNotification: true,
        openFileFromNotification: true,
      );
    } else {
      /// TODO : Show toast to user

      print('Permission Denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await webViewController.canGoBack()) {
          print("onwill goback");
          webViewController.goBack();
          return Future.value(false);
        } else {
          var currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            currentFocus.focusedChild.unfocus();
            return false;
          } else {
            DateTime now = DateTime.now();
            if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
              currentBackPressTime = now;

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Press back again to exit.')));
              return Future.value(false);
            }
            return Future.value(true);
          }
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => this.connectivityBloc),
              BlocProvider(create: (context) => this.webviewScreenBloc),
              BlocProvider(create: (context) => this.versionCheckBloc),
            ],
            child: MultiBlocListener(
              listeners: [
                BlocListener<ConnectivityBloc, ConnectivityState>(
                  bloc: this.connectivityBloc,
                  listener: (context, ConnectivityState connectivityState) {
                    print(connectivityState.message);
                    if (connectivityState.message.contains('failed connect to network')) {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NoConnectionWidget(packageInfo: widget.packageInfo)), (route) => false);
                    }
                  },
                ),
                BlocListener<VersionCheckBloc, VersionCheckState>(
                  bloc: this.versionCheckBloc,
                  listener: (context, VersionCheckState versionCheckState) {
                    if (versionCheckState.version != null) {
                      if (VersionHelper.checkAppVersion('${widget.packageInfo.version}', versionCheckState.version.versionCode)) {
                        setState(() {
                          _isDialogShowing = true;
                        });
                        showDialog(context: context, builder: (context) {
                          return UpdateDialogWidget();
                        });
                      } else {
                        if (_isDialogShowing) {
                          Navigator.of(context, rootNavigator: true).pop();
                        }
                        setState(() {
                          _isDialogShowing = false;
                        });
                      }
                    }
                  },
                )
              ],
              child: BlocBuilder<VersionCheckBloc, VersionCheckState>(
                  bloc: versionCheckBloc,
                  builder: (context, VersionCheckState versionCheckState) {
                    return buildInAppWebView();
                  }
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInAppWebView() {
    return InAppWebView(
      key: webViewKey,
      initialUrlRequest: URLRequest(url: Uri.parse("https://smallrank.shop/dashboard")),
      initialOptions: options,
      pullToRefreshController: pullToRefreshController,
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
      onLoadHttpError: (controller, url, statusCode, description) {
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
        if (![ "http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
          if (await canLaunch(uri.toString())) {
            await launch(uri.toString()).whenComplete(() async {
              if (await controller.canGoBack()) {
                controller.goBack();
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
        _onDownload(Uri.parse("$url").toString());
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
