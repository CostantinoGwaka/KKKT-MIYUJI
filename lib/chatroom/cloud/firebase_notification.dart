import 'dart:convert';

import './local_notification.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:miyuji/models/message.dart';

const String FIREBASE_API_KEY =
    "AAAA8UdPgfc:APA91bEdD2_3efaG6aYBiog4VRll4IFJwcMokUNknGZWGIObncUUY93oKNhZivjH8eZggbMEkGwNn4_Kmp1Dk6Vncc80_HMlNR5wbe0JJSczsL0lCJsRclwMPjur_jryZ1h92bWcd44X";

class FireibaseClass {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static Future<String> getUserToken() async {
    String token = await _firebaseMessaging.getToken();
    return token;
  }

  static Future<void> initialize({context}) async {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("here we go onMessage: $message");
        // HandleMessageFunction.saveIncomingMessage(
        //   message: message["data"]["message"],
        // );
        LocalNotification.showNotification();
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("here we go onLaunch: $message");
        // HandleMessageFunction.saveIncomingMessage(
        //   message: message["data"]["message"],
        // );
        LocalNotification.showNotification();
      },
      onResume: (
        Map<String, dynamic> message,
      ) async {
        // var incomingMessage = json.decode(message["data"]["message"]);
        print("here we go onResume: $message");
        // HandleMessageFunction.saveIncomingMessage(
        //   message: message["data"]["message"],
        // );
        LocalNotification.showNotification();
        // try {
        //   AppNavigation.push(
        //     context,
        //     child: ChatSectionScreen(
        //       friendId: incomingMessage["hostId"],
        //       // fullname: message["data"]["message"]["fullName"],
        //       // picture: message["data"]["message"],
        //       // token: token,
        //     ),
        //   );
        // } catch (er) {
        //   print("here we go this is error: $er");
        // }
      },
      onBackgroundMessage: (Map<String, dynamic> message) async {
        print("here we go onBackground: $message");
        // HandleMessageFunction.saveIncomingMessage(
        //   message: message["data"]["message"],
        // );
        LocalNotification.showNotification();
      },
    );
    // onBackgroundMessage: myBackgroundMessageHandler;
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true,
        provisional: true,
      ),
    );
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  static Future<void> sendNotification({
    String token,
    String type = 'private',
    Message message,
  }) async {
    print("this message riched3 $message");
    final response = await http
        .post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$FIREBASE_API_KEY',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': message.message,
            'title': message.fullName,
            // 'image':
            //     "https://pbs.twimg.com/profile_images/1162267256157458433/m7s3Y6nj_400x400.jpg",
          },
          'priority': 'high',
          // 'data': <String, dynamic>{
          //   'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          //   'status': 'done',
          //   'type': 'private',
          //   'message': message
          // },
          "android": <String, dynamic>{
            "notification": {
              "image": "https://pbs.twimg.com/profile_images/1162267256157458433/m7s3Y6nj_400x400.jpg",
            }
          },
          "apns": <String, dynamic>{
            "payload": <String, dynamic>{
              "aps": {"mutable-content": 1}
            },
            "fcm_options": <String, dynamic>{"image": "https://pbs.twimg.com/profile_images/1162267256157458433/m7s3Y6nj_400x400.jpg"}
          },
          'to': token,
        },
      ),
    )
        .catchError((err) {
      print("is error toooooooooooooooooo $err");
    });
    print("this is response: ${response.body}");
  }
}
