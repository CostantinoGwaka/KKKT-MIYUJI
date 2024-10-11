import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  Message({
    this.mediasize,
    this.readed,
    this.message,
    this.friendId,
    this.medianame,
    this.fullName,
    this.picUrl,
    this.docUrl,
    this.messageId,
    this.color,
    this.unseen,
    this.repliedContent,
    this.sentAt,
    this.createdAt,
    this.hostId,
    this.reply,
    this.status,
    this.type,
    this.access,
    this.isDeletedBy,
    this.readBy,
    this.caption,
  });

  int? mediasize;
  bool? readed;
  String? message;
  String? friendId;
  String? medianame;
  String? fullName;
  String? picUrl;
  String? docUrl;
  String? messageId;
  String? color;
  int? unseen;
  String? sentAt;
  String? createdAt;
  String? hostId;
  bool? reply;
  String? status;
  String? type;
  bool? access;
  String? caption;
  Map<String, dynamic>? repliedContent;
  var isDeletedBy;
  var readBy;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        mediasize: json["mediasize"],
        readed: json["readed"],
        message: json["message"],
        friendId: json["friendId"],
        medianame: json["medianame"],
        fullName: json["fullName"],
        picUrl: json["picUrl"],
        docUrl: json["docUrl"],
        messageId: json["messageId"],
        color: json["color"],
        unseen: json["unseen"],
        sentAt: json["sentAt"],
        createdAt: json["createdAt"],
        hostId: json["hostId"],
        reply: json["reply"],
        status: json["status"],
        type: json["type"],
        access: json["access"],
        repliedContent: json["json"],
        readBy: json["readBy"],
        caption: json["caption"],
      );

  Map<String, dynamic> toJson() => {
        "mediasize": mediasize,
        "readed": readed,
        "message": message,
        "friendId": friendId,
        "medianame": medianame,
        "fullName": fullName,
        "picUrl": picUrl,
        "docUrl": docUrl,
        "messageId": messageId,
        "color": color,
        "unseen": unseen,
        "repliedContent": repliedContent,
        "sentAt": sentAt,
        "createdAt": createdAt,
        "hostId": hostId,
        "reply": reply,
        "status": status,
        "type": type,
        "access": access,
        "readBy": readBy,
        "caption": caption,
      };

  handleSendMessage({
    String? messageId,
    String? convoId,
    String? userId,
  }) {
    FirebaseDatabase.instance.ref().child("Messages/$userId/$convoId/${messageId!}").set({
      "receiverId": friendId.toString(),
      "senderId": convoId,
      "picture": picUrl,
      "document": docUrl,
      "medianame": medianame,
      "color": "pink",
      "unseen": unseen,
      "messageId": messageId,
      "repliedContent": repliedContent,
      "reply": reply,
      "status": status,
      "type": type,
      "createdAt": DateTime.now().toString(),
      "sentAt": DateTime.now().toString(),
      "message": message,
      "isDeletedBy": isDeletedBy,
      "read": readed,
      "readBy": readBy,
      "access": access ?? true,
      "mediasize": mediasize,
      "caption": caption,
    });

    // .set(model.toMap());
  }
}
