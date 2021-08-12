import 'dart:io';
import 'package:launch_review/launch_review.dart';
import 'package:app/utils/asset_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateDialogWidget extends StatefulWidget {
  @override
  _UpdateDialogWidgetState createState() => _UpdateDialogWidgetState();
}

class _UpdateDialogWidgetState extends State<UpdateDialogWidget> {
  void onButtonUpdate() {
    // TODO : Need to add iOSAppId
    LaunchReview.launch(
      androidAppId: "com.smallrank.app",
      iOSAppId: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AlertDialog(
        title: Text('Update Available', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('There is a newer version of ap available please update it now.'),
            SizedBox(height: 15),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () => onButtonUpdate(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF0C8160)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
                    child: Text('Update', style: TextStyle(color: Colors.white)),
                  )
              ),
            ),
            SizedBox(height: 10),
            Divider(
              thickness: 1.5,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Image.asset(AssetString.googlePlayLogo, width: 100),
              ),
            )
          ],
        ),
      );
    } else {
      return CupertinoAlertDialog(
        title: Text('Update Available', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        content: Text('There is a newer version of ap available please update it now.'),
        actions: [
          CupertinoButton(child: Text('Update Now'), onPressed: () => onButtonUpdate()),
        ],
      );
    }
  }
}
