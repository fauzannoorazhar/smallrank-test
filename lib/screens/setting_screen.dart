import 'package:app/blocs/webview_screen/webview_screen_bloc.dart';
import 'package:app/utils/asset_string.dart';
import 'package:app/widgets/webview_scaffold_widget.dart';
import 'package:connectivity_helper/blocs/connectivity/connectivity_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:package_info/package_info.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class SettingScreen extends StatefulWidget {
  final PersistentTabController controller;
  final Function(String url) onDownload;
  final PullToRefreshController pullToRefreshController;
  final InAppWebViewController webViewController;
  final WebviewScreenBloc webviewScreenBloc;
  final Function(InAppWebViewController webViewController) setWebViewController;
  final ConnectivityBloc connectivityBloc;
  final Function(bool value) setStateHideNavigationBar;

  SettingScreen({
    this.controller,
    this.onDownload,
    this.pullToRefreshController,
    this.webViewController,
    this.webviewScreenBloc,
    this.setWebViewController,
    this.connectivityBloc,
    this.setStateHideNavigationBar
  });

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75.0),
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              leading: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Icon(
                  Icons.dehaze,
                  color: Colors.black,
                  size: 25,
                ),
              ),
              title: Image.asset(AssetString.appbarLogo, width: 150)
          ),
        ),
      ),
      body: SafeArea(
          child: ListView(
            children: [
              ListTile(
                title: Text('Account Settings'),
                trailing: Icon(CupertinoIcons.right_chevron),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => WebviewScaffoldWidget(
                    urlWebview: 'https://smallrank.shop/dashboard/settings/',
                    onDownload: widget.onDownload,
                    pullToRefreshController: widget.pullToRefreshController,
                    webViewController: widget.webViewController,
                    webviewScreenBloc: widget.webviewScreenBloc,
                    setWebViewController: widget.setWebViewController,
                    connectivityBloc: widget.connectivityBloc,
                    titleAppbar: 'Account Settings',
                    useAppbar: true,
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      backgroundColor: Color(0xFF0C8160),
                      child: Icon(CupertinoIcons.person_circle_fill),
                    ),
                  )));
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Divider(),
              ),
              ListTile(
                title: Text('Products'),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child:Column(
                  children: [
                    ListTile(
                      title: Text('All Products'),
                      trailing: Icon(CupertinoIcons.right_chevron),
                      onTap: () {
                        widget.controller.jumpToTab(1);
                      },
                    ),
                    ListTile(
                      title: Text('Categories'),
                      trailing: Icon(CupertinoIcons.right_chevron),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => WebviewScaffoldWidget(
                          urlWebview: 'https://smallrank.shop/dashboard/products/category',
                          onDownload: widget.onDownload,
                          pullToRefreshController: widget.pullToRefreshController,
                          webViewController: widget.webViewController,
                          webviewScreenBloc: widget.webviewScreenBloc,
                          setWebViewController: widget.setWebViewController,
                          connectivityBloc: widget.connectivityBloc,
                          titleAppbar: 'Categories',
                          useAppbar: true,
                          floatingActionButton: FloatingActionButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            backgroundColor: Color(0xFF0C8160),
                            child: Icon(CupertinoIcons.person_circle_fill),
                          ),
                        )));
                      },
                    ),
                    ListTile(
                      title: Text('Orders'),
                      trailing: Icon(CupertinoIcons.right_chevron),
                      onTap: () {
                        widget.controller.jumpToTab(2);
                      },
                    ),
                    ListTile(
                      title: Text('Shipping'),
                      trailing: Icon(CupertinoIcons.right_chevron),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => WebviewScaffoldWidget(
                          urlWebview: 'https://smallrank.shop/dashboard/shipping/',
                          onDownload: widget.onDownload,
                          pullToRefreshController: widget.pullToRefreshController,
                          webViewController: widget.webViewController,
                          webviewScreenBloc: widget.webviewScreenBloc,
                          setWebViewController: widget.setWebViewController,
                          connectivityBloc: widget.connectivityBloc,
                          titleAppbar: 'Shipping',
                          useAppbar: true,
                          floatingActionButton: FloatingActionButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            backgroundColor: Color(0xFF0C8160),
                            child: Icon(CupertinoIcons.person_circle_fill),
                          ),
                        )));
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text('Analytics'),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child:Column(
                  children: [
                    ListTile(
                      title: Text('Shop Analytics'),
                      trailing: Icon(CupertinoIcons.right_chevron),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => WebviewScaffoldWidget(
                          urlWebview: 'https://smallrank.shop/dashboard/stats',
                          onDownload: widget.onDownload,
                          pullToRefreshController: widget.pullToRefreshController,
                          webViewController: widget.webViewController,
                          webviewScreenBloc: widget.webviewScreenBloc,
                          setWebViewController: widget.setWebViewController,
                          connectivityBloc: widget.connectivityBloc,
                          titleAppbar: 'Shop Analytics',
                          useAppbar: true,
                          floatingActionButton: FloatingActionButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            backgroundColor: Color(0xFF0C8160),
                            child: Icon(CupertinoIcons.person_circle_fill),
                          ),
                        )));
                      },
                    ),
                    ListTile(
                      title: Text('Smarts Marketing'),
                      trailing: Icon(CupertinoIcons.right_chevron),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => WebviewScaffoldWidget(
                          urlWebview: 'https://smallrank.shop/dashboard/marketing',
                          onDownload: widget.onDownload,
                          pullToRefreshController: widget.pullToRefreshController,
                          webViewController: widget.webViewController,
                          webviewScreenBloc: widget.webviewScreenBloc,
                          setWebViewController: widget.setWebViewController,
                          connectivityBloc: widget.connectivityBloc,
                          titleAppbar: 'Smarts Marketing',
                          useAppbar: true,
                          floatingActionButton: FloatingActionButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            backgroundColor: Color(0xFF0C8160),
                            child: Icon(CupertinoIcons.person_circle_fill),
                          ),
                        )));
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text('Others'),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child:Column(
                  children: [
                    ListTile(
                      title: Text('Customers'),
                      trailing: Icon(CupertinoIcons.right_chevron),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => WebviewScaffoldWidget(
                          urlWebview: 'https://smallrank.shop/dashboard/customers',
                          onDownload: widget.onDownload,
                          pullToRefreshController: widget.pullToRefreshController,
                          webViewController: widget.webViewController,
                          webviewScreenBloc: widget.webviewScreenBloc,
                          setWebViewController: widget.setWebViewController,
                          connectivityBloc: widget.connectivityBloc,
                          titleAppbar: 'Customers',
                          useAppbar: true,
                          floatingActionButton: FloatingActionButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            backgroundColor: Color(0xFF0C8160),
                            child: Icon(CupertinoIcons.person_circle_fill),
                          ),
                        )));
                      },
                    ),
                    ListTile(
                      title: Text('Chat'),
                      trailing: Icon(CupertinoIcons.right_chevron),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => WebviewScaffoldWidget(
                          urlWebview: 'https://smallrank.shop/dashboard/chats',
                          onDownload: widget.onDownload,
                          pullToRefreshController: widget.pullToRefreshController,
                          webViewController: widget.webViewController,
                          webviewScreenBloc: widget.webviewScreenBloc,
                          setWebViewController: widget.setWebViewController,
                          connectivityBloc: widget.connectivityBloc,
                          titleAppbar: 'Chat',
                          useAppbar: true,
                          floatingActionButton: FloatingActionButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            backgroundColor: Color(0xFF0C8160),
                            child: Icon(CupertinoIcons.person_circle_fill),
                          ),
                        )));
                      },
                    ),
                    ListTile(
                      title: Text('Pages'),
                      trailing: Icon(CupertinoIcons.right_chevron),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => WebviewScaffoldWidget(
                          urlWebview: 'https://smallrank.shop/dashboard/pages',
                          onDownload: widget.onDownload,
                          pullToRefreshController: widget.pullToRefreshController,
                          webViewController: widget.webViewController,
                          webviewScreenBloc: widget.webviewScreenBloc,
                          setWebViewController: widget.setWebViewController,
                          connectivityBloc: widget.connectivityBloc,
                          titleAppbar: 'Pages',
                          useAppbar: true,
                          floatingActionButton: FloatingActionButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            backgroundColor: Color(0xFF0C8160),
                            child: Icon(CupertinoIcons.person_circle_fill),
                          ),
                        )));
                      },
                    ),
                    ListTile(
                      title: Text('Domains'),
                      trailing: Icon(CupertinoIcons.right_chevron),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => WebviewScaffoldWidget(
                          urlWebview: 'https://smallrank.shop/dashboard/domains',
                          onDownload: widget.onDownload,
                          pullToRefreshController: widget.pullToRefreshController,
                          webViewController: widget.webViewController,
                          webviewScreenBloc: widget.webviewScreenBloc,
                          setWebViewController: widget.setWebViewController,
                          connectivityBloc: widget.connectivityBloc,
                          titleAppbar: 'Domains',
                          useAppbar: true,
                          floatingActionButton: FloatingActionButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            backgroundColor: Color(0xFF0C8160),
                            child: Icon(CupertinoIcons.person_circle_fill),
                          ),
                        )));
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      final PackageInfo info = snapshot.data;

                      return Text("Version : " + info.version, textAlign: TextAlign.right, style: TextStyle(fontSize: 12));
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          )
      ),
    );
  }
}