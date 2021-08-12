import 'package:app/screens/main_screen.dart';
import 'package:app/screens/version_update_screen.dart';
import 'package:app/utils/asset_string.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PackageInfo packageInfo;

  @override
  void initState() {
    new Future.delayed(const Duration(seconds: 2), () {
      if (packageInfo != null) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen(packageInfo: packageInfo)), (route) => false);
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF0C8160),
        body: FutureBuilder(
          future: PackageInfo.fromPlatform(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              packageInfo = snapshot.data;

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: MediaQuery.of(context).size.height / 2,
                      child: Image.asset(
                        AssetString.logoApp,
                        height: 100,
                        width: 100,
                      ),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(bottom: 20),
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black38)
                              ),
                              SizedBox(height: 15),
                              Text("Version : " + packageInfo.version, textAlign: TextAlign.center, style: TextStyle(color: Colors.white))
                            ],
                          )),
                    )
                  ],
                ),
              );
            }

            return Text('');
          },
        ),
      )
    );
  }
}
