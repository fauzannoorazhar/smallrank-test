import 'package:app/screens/main_screen.dart';
import 'package:app/screens/splash_screen.dart';
import 'package:connectivity_helper/blocs/connectivity/connectivity_bloc.dart';
import 'package:connectivity_helper/blocs/connectivity/connectivity_event.dart';
import 'package:connectivity_helper/blocs/connectivity/connectivity_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';

class NoConnectionWidget extends StatefulWidget {
  final PackageInfo packageInfo;

  NoConnectionWidget({@required this.packageInfo});

  @override
  _NoConnectionWidgetState createState() => _NoConnectionWidgetState();
}

class _NoConnectionWidgetState extends State<NoConnectionWidget> {
  ConnectivityBloc connectivityBloc = new ConnectivityBloc(ConnectivityState(message: ''));

  @override
  void initState() {
    // TODO: implement initState
    connectivityBloc.add(CheckConnectivityEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ConnectivityBloc>(
          create: (context) => connectivityBloc,
          child: BlocListener<ConnectivityBloc, ConnectivityState>(
            listener: (context, ConnectivityState connectivityState) {
              print('ConnectivityBloc : ');
              print(connectivityState.message);

              if (!connectivityState.message.contains('failed connect to network')) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MainScreen(packageInfo: widget.packageInfo)), (route) => false);
              }
            },
            child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
              bloc: connectivityBloc,
              builder: (context, ConnectivityState connectivityState) {
                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.wifi, size: 50),
                        SizedBox(height: 10),
                        Text('Could not connection to the internet. Please check your network.', textAlign: TextAlign.center)
                      ],
                    ),
                  ),
                );
              },
            ),
          )
      ),
    );
  }
}

