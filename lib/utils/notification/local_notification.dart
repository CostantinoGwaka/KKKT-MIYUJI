// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/subjects.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int? id;
  final String? title;
  final String? body;
  final String? payload;
}

class LocalNotification {
  static void requestPermissions() {
    // flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
    //       alert: true,
    //       badge: true,
    //       sound: true,
    //     );
    // flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
    //       alert: true,
    //       badge: true,
    //       sound: true,
    //     );
  }

  static void configureDidReceiveLocalNotificationSubject(
      {required BuildContext context}) {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title ?? '')
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body ?? '')
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                // Navigator.of(context, rootNavigator: true).pop();
                // await Navigator.push(
                //   context,
                //   MaterialPageRoute<void>(
                //     builder: (BuildContext context) =>
                //         SecondPage(receivedNotification.payload),
                //   ),
                // );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  static void configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      // await Navigator.pushNamed(context, '/secondPage');
    });
  }

  static Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload,
      {BuildContext? context}) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();

              // await Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => SecondScreen(payload),
              //   ),
              // );
            },
          )
        ],
      ),
    );
  }

  static Future selectNotification(String payload,
      {BuildContext? context}) async {
    debugPrint('notification payload: $payload');
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }

  static Future<void> intialize() async {
    // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // const AndroidInitializationSettings initializationSettingsAndroid =
    // AndroidInitializationSettings('ic_stat_onesignal_default.png');
    // final IOSInitializationSettings initializationSettingsIOS =
    //     const IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    // const MacOSInitializationSettings initializationSettingsMacOS = MacOSInitializationSettings();
    // final InitializationSettings initializationSettings = InitializationSettings(
    //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: initializationSettingsMacOS);
    // await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);
  }

  static Future<void> showNotification(
      {String? title, String? description}) async {
    // FlutterLocalNotificationsPlugin localNotifPlugin = FlutterLocalNotificationsPlugin();
    // const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    //   'channel_id',
    //   'channel_name',
    //   'channel_description',
    //   importance: Importance.max,
    //   priority: Priority.high,
    //   enableLights: true,
    //   ticker: 'ticker',
    //   icon: 'notification_icon_default',
    //   largeIcon: DrawableResourceAndroidBitmap('ic_stat_onesignal_default'),
    // );
    // var iOSChannelSpecifics = IOSNotificationDetails();
    // const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    // localNotifPlugin.show(
    //   0,
    //   title,
    //   description,
    //   platformChannelSpecifics,
    // );
  }
}
