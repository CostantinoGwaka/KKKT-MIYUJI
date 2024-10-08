import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:miyuji/usajili/screens/index.dart';

class Alerts {
  static Future<void> show(context, title, message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Kubali"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showCupertinoAlert(context, title, message) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("Jisajili"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RegistrationScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  static showProgressDialog(BuildContext context, String title) {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  CupertinoActivityIndicator(),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  Flexible(
                      flex: 8,
                      child: Text(
                        title,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            );
          });
    } catch (e) {
      print(e.toString());
    }
  }

  static subscriptionloginrequiredhint(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ujaingia kwenye akaunti"),
          content: Text("Unatakiwa kuingia kwenye akaunti yako"),
          actions: <Widget>[
            TextButton(
              child: Text("Funga"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Ingia"),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.pushNamed(context, LoginScreen.routeName);
              },
            )
          ],
        );
      },
    );
  }

  static showPlaySubscribeAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Aujalipia"),
          content: Text("Unatakiwa uwe umeingia kwenye akauinti yako"),
          actions: <Widget>[
            TextButton(
              child: Text("Funga"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Jiunge"),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.pushNamed(context, SubscriptionScreen.routeName);
              },
            )
          ],
        );
      },
    );
  }

  static showPreviewSubscribeAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Subscribe"),
          content: Text("Jiunge"),
          actions: <Widget>[
            TextButton(
              child: Text("Funga"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Jiunge"),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.pushNamed(context, SubscriptionScreen.routeName);
              },
            )
          ],
        );
      },
    );
  }
}
