import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:kinyerezi/chatroom/cloud/cloud.dart';
import 'package:kinyerezi/chatroom/cloud/firebase_notification.dart';
import 'package:kinyerezi/models/message.dart';
import 'package:kinyerezi/shared/localstorage/index.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
import './message_handler.dart';

class MediaHandler {
  static final picker = ImagePicker();
  static File _image;
  static var basNameWithExtension;
  static var newmessage;
  static var mtumishi;

  static uploadMedia(id, size, _image, widget, Message message, token, type) async {
    await LocalStorage.getStringItem('member_no').then((value) {
      if (value != null) {
        var mymtumishi = jsonDecode(value);
        mtumishi = mymtumishi;
      }
    });

    //upload image to server
    if (message.type == "photo") {}
    final firebase_storage.Reference _ref =
        firebase_storage.FirebaseStorage.instance.ref().child('Message${message.type}/$id-${_image.path.split('/').last}');

    //upload task listen when upload image to server
    UploadTask uploadTask = _ref.putFile(_image);
    uploadTask.snapshotEvents.listen((event) {
      // ignore: unused_local_variable
      int percentage = (((uploadTask.snapshot.bytesTransferred) / size) * 100).round();
    });

    //after finish upload image to server
    uploadTask.then((res) async {
      res.ref.getDownloadURL().then((value) {
        //update picurl
        updateMediaUrl(value, widget.friendId, id).whenComplete(() => {
              newmessage = message,
              message.picUrl = value,
              HandleMessageFunction.saveIncomingMessage(message: message),
              FireibaseClass.sendNotification(
                message: message,
                token: token,
              ).catchError((err) {
                print("error occured: $err");
              }),
              Cloud.update(
                checkSnap: false,
                serverPath: "RecentChat/${mtumishi['member_no']}/${widget.friendId}",
                value: {
                  "lastmessage": message.message,
                  "unseen": 0,
                  "time": message.sentAt,
                },
              )
            });
      });
    });
  }

  static Future<dynamic> updateMediaUrl(value, friendId, id) async {
    await Cloud.update(
      checkSnap: false,
      serverPath: "Messages/${mtumishi['member_no']}/$friendId/$id",
      value: {'mediaUrl': value, 'access': true},
    );
  }

  static Future getImage(
    BuildContext context,
    dynamic widget,
    List replyData,
    File _image,
    String caption,
  ) async {
    print("here we go :caption $caption");
    //create file to be uploaded to the server
    //create message id
    String id = Uuid().v4();

    //media size
    int size = await _image.length();

    //media name
    basNameWithExtension = path.basename(_image.path);
    //IMAGE caption
    // AppNavigation.pushReplacement(
    //   context,
    //   child: ImageCaption(

    //   ),
    // );

    sendMedia(
      message: Message(
        mediasize: size,
        access: false,
        readed: false,
        message: "📸 Photo",
        friendId: widget.friendId,
        messageId: id,
        medianame: basNameWithExtension,
        picUrl: '',
        color: "green",
        sentAt: DateTime.now().toString(),
        createdAt: DateTime.now().toString(),
        hostId: mtumishi['member_no'],
        reply: false,
        type: "photo",
        repliedContent: (replyData.length > 0) ? replyData[0] : null,
        caption: caption,
      ),
      receiverId: widget.friendId,
      senderId: mtumishi['member_no'],
    ).whenComplete(() {
      uploadMedia(
          id,
          size,
          _image,
          widget,
          Message(
            mediasize: size,
            access: false,
            readed: false,
            message: "📸 Photo",
            friendId: widget.friendId,
            messageId: id,
            medianame: basNameWithExtension,
            picUrl: '',
            color: "green",
            sentAt: DateTime.now().toString(),
            createdAt: DateTime.now().toString(),
            hostId: mtumishi['member_no'],
            reply: false,
            type: "photo",
            repliedContent: (replyData.length > 0) ? replyData[0] : null,
            caption: caption,
          ),
          widget.token,
          "photo");
    });
  }

  static Future getDocument(BuildContext context, dynamic widget, String token, List replyData) async {
    print("hahahaahah : $replyData");
    File _file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', '.doc', 'txt', 'xlsx'],
    );

    if (_file == null) return;
    if (_file.lengthSync() <= 8000000) {
      //create file to be uploaded to the server
      _image = await File(_file.path).create();

      //create message id
      String id = Uuid().v4();

      //server time
      DateTime serverTime = Timestamp.now().toDate().toLocal();

      //media size
      int size = await _file.length();

      //media name
      basNameWithExtension = path.basename(_file.path);

      sendMedia(
        message: Message(
          mediasize: size,
          access: false,
          readed: false,
          message: "📄 Document",
          friendId: widget.friendId,
          messageId: id,
          medianame: basNameWithExtension,
          picUrl: '',
          color: "green",
          sentAt: DateTime.now().toString(),
          createdAt: DateTime.now().toString(),
          hostId: mtumishi['member_no'],
          reply: false,
          type: "document",
          repliedContent: (replyData.length > 0) ? replyData[0] : null,
        ),
        receiverId: widget.friendId,
        senderId: mtumishi['member_no'],
      ).whenComplete(() {
        uploadMedia(
            id,
            size,
            _image,
            widget,
            Message(
              mediasize: size,
              access: false,
              readed: false,
              message: "📄 Document",
              friendId: widget.friendId,
              messageId: id,
              medianame: basNameWithExtension,
              picUrl: '',
              color: "green",
              sentAt: DateTime.now().toString(),
              createdAt: DateTime.now().toString(),
              hostId: mtumishi['member_no'],
              reply: false,
              type: "document",
              repliedContent: (replyData.length > 0) ? replyData[0] : null,
            ),
            token,
            "document");
      });
    }
  }

  //universal function send media fucntion
  static Future<dynamic> sendMedia({Message message, String receiverId, String senderId}) async {
    Cloud.add(
      serverPath: "Messages/$senderId/$receiverId/${message.messageId}",
      value: {
        "receiverId": receiverId,
        "senderId": message.hostId,
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
        "caption": message.caption,
      },
    );
  }
}
