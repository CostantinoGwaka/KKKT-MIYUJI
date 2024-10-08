import 'package:flutter/material.dart';

class AddReplyData extends ChangeNotifier {
  final List _reply = [];

  List get getReplyData => _reply;

  void setReplyData(var replyData) {
    _reply.clear();
    _reply.add({
      "message": replyData["message"],
      "sender": replyData["senderId"],
      "messageId": replyData["messageId"],
      "type": replyData["type"]
    });
    notifyListeners();
  }

  void unsetReply() {
    _reply.clear();
    notifyListeners();
  }
}
