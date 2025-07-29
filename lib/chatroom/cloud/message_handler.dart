import 'package:kanisaapp/models/message.dart';
import './cloud.dart';
import './firebase_notification.dart';
import 'package:firebase_database/firebase_database.dart';

// const String token =
//     "epuw8ASHTVOiWxcE1w0465:APA91bFHSr7kI3OIt2xHiwJdcC6uWXBTck2TdlbG5-AsSOGJbJxMvuY3W4aRIzhpF0ZEgPTQvAP0B-WohzCw9OvDSVjrngdeAki4T8iIr-q8qBHFeevPY33ATSnKmSrKageyMjKJTcQQ";

// class MessageHandler {

//   static saveIncomingMessage() {}
// }

class HandleMessageFunction {
  static sendNormalText({Message? message, String? receiverId, String? senderId, String? token}) {
    Cloud.add(
      serverPath: "Messages/$senderId/$receiverId/${message!.messageId}",
      value: {
        "receiverId": receiverId,
        "senderId": message.hostId,
        "fullname": message.fullName,
        "color": message.color,
        "messageId": message.messageId,
        "reply": message.reply,
        "status": message.status,
        "type": message.type,
        "createdAt": message.createdAt,
        "medianame": message.medianame,
        "mediasize": message.mediasize,
        "picUrl": message.picUrl,
        "sentAt": message.sentAt,
        "message": message.message,
        "read": message.readed,
        "readBy": message.readBy,
        "access": message.access,
        "repliedContent": message.repliedContent,
      },
    ).whenComplete(() {
      saveIncomingMessage(message: message);

      FireibaseClass.sendNotification(
        message: message,
        token: token,
      ).catchError((err) {
        print("error occured: $err");
      });
      Cloud.update(
        checkSnap: false,
        serverPath: "RecentChat/$senderId/$receiverId",
        value: {
          "lastmessage": message.message,
          "unseen": ServerValue.increment(0),
          "time": message.sentAt,
        },
      );
    });
  }

  static saveIncomingMessage({message}) {
    // var incomingMessage = message;
    print("this is message: $message");
    Cloud.add(
      serverPath: "Messages/${message.friendId}/${message.hostId}/${message.messageId}",
      value: {
        "receiverId": message.friendId,
        "senderId": message.hostId,
        "color": message.color,
        "messageId": message.messageId,
        "reply": message.reply,
        "status": message.status,
        "type": message.type,
        "createdAt": message.createdAt,
        "sentAt": message.sentAt,
        "message": message.message,
        "read": message.readed,
        "readBy": message.readBy,
        "access": message.access,
        "mediaUrl": message.picUrl,
        "medianame": message.medianame,
        "mediasize": message.mediasize,
        "repliedContent": message.repliedContent,
        "caption": message.caption,
      },
    ).whenComplete(() {
      try {
        Cloud.update(
          checkSnap: true,
          serverPath: "RecentChat/${message.friendId}/${message.hostId}",
          value: {
            "color": message.color,
            "lastmessage": message.message,
            "unseen": ServerValue.increment(1),
            "time": message.sentAt,
            "userId": message.hostId,
            "fullname": message.fullName,
          },
        );
      } catch (err) {
        print("this is error $err");
      }
      print("this message riched2");
    });
  }
}
