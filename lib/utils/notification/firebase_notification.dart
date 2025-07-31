// ignore_for_file: constant_identifier_names

import 'package:firebase_messaging/firebase_messaging.dart';

const String FIREBASE_API_KEY =
    "AAAALyZj0Vk:APA91bEqBoRtW2GE3C1eskeylHPa6LWevFEAAf0eLhaOMD_-LtaztYOWy9UfNBxH8-li3djS67SM3cIeAdb_zmidp35WjeW3BrZwLatnfUmiratajmq0HO4m54fuMP_tmF54ZNdKNrLQ";

class FireibaseClass {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static Future<String?> getUserToken() async {
    String? token = await _firebaseMessaging.getToken();
    return token;
  }

  static Future<void> initialize({context}) async {
    // For handling foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // setState(() {
      //   messageTitle = message.notification?.title ?? 'No Title';
      //   notificationAlert = "New Notification Alert";
      // });
    });

    // For handling when the app is opened via a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // setState(() {
      //   messageTitle = message.data['title'] ?? 'No Title';
      //   notificationAlert = "Application opened from Notification";
      // });
    });
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("here we go onMessage: $message");
    //     // HandleMessageFunction.saveIncomingMessage(
    //     //   message: message["data"]["message"],
    //     // );
    //     LocalNotification.showNotification();
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("here we go onLaunch: $message");
    //     // HandleMessageFunction.saveIncomingMessage(
    //     //   message: message["data"]["message"],
    //     // );
    //     LocalNotification.showNotification();
    //   },
    //   onResume: (
    //     Map<String, dynamic> message,
    //   ) async {
    //     // var incomingMessage = json.decode(message["data"]["message"]);
    //     print("here we go onResume: $message");
    //     // HandleMessageFunction.saveIncomingMessage(
    //     //   message: message["data"]["message"],
    //     // );
    //     LocalNotification.showNotification();
    //     // try {
    //     //   AppNavigation.push(
    //     //     context,
    //     //     child: ChatSectionScreen(
    //     //       friendId: incomingMessage["hostId"],
    //     //       // fullname: message["data"]["message"]["fullName"],
    //     //       // picture: message["data"]["message"],
    //     //       // token: token,
    //     //     ),
    //     //   );
    //     // } catch (er) {
    //     //   print("here we go this is error: $er");
    //     // }
    //   },
    //   onBackgroundMessage: (Map<String, dynamic> message) async {
    //     print("here we go onBackground: $message");
    //     // HandleMessageFunction.saveIncomingMessage(
    //     //   message: message["data"]["message"],
    //     // );
    //     LocalNotification.showNotification();
    //   },
    // );
    // // onBackgroundMessage: myBackgroundMessageHandler;
    // _firebaseMessaging.requestNotificationPermissions(
    //   const IosNotificationSettings(
    //     sound: true,
    //     badge: true,
    //     alert: true,
    //     provisional: true,
    //   ),
    // );
    // _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
    //   print("Settings registered: $settings");
    // });
  }
}
