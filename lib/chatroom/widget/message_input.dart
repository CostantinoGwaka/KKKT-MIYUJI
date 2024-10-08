import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kinyerezi/bloc/addReply.dart';
import 'package:kinyerezi/chatroom/cloud/message_handler.dart';
import 'package:kinyerezi/chatroom/widget/reply_navigator.dart';
import 'package:kinyerezi/models/message.dart';
import 'package:kinyerezi/shared/localstorage/index.dart';
import 'package:kinyerezi/utils/my_colors.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:kinyerezi/home/screens/index.dart';


class MessageInput extends StatefulWidget {
  final String friendId;
  final bool showSelectMedia;
  final Function showIcon;
  final String token;
  final String fullname;
  final ItemScrollController scrollTo;
  MessageInput({
    this.friendId,
    this.showSelectMedia,
    this.showIcon,
    this.token,
    this.fullname,
    this.scrollTo,
  });
  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  TextEditingController controller = TextEditingController();
  Future<void> sendMessage(List replyData) async {
    // LocalStorage.getStringItem('member_no').then((value) {
    //   if (value != null) {
    //     var mydata = jsonDecode(value);
    //     setState(() {
    //       host = mydata;
    //     });
    //   }
    // });
    String textMessage = controller.text;
    String id = Uuid().v4();
    print("size# ${textMessage.length} $textMessage");
    if (controller.text.isEmpty || textMessage == "" || textMessage == null || textMessage.length == 0) return;
    HandleMessageFunction.sendNormalText(
      message: Message(
        access: true,
        readed: false,
        message: textMessage,
        friendId: widget.friendId,
        fullName: host['fname'],
        messageId: id,
        color: "green",
        sentAt: DateTime.now().toString(),
        createdAt: DateTime.now().toString(),
        hostId: host['member_no'],
        reply: false,
        type: "text",
        repliedContent: (replyData.length > 0) ? replyData[0] : null,
      ),
      receiverId: widget.friendId,
      senderId: host['member_no'],
      token: widget.token,
    );
  }

  @override
  Widget build(BuildContext context) {
    List replyData = context.watch<AddReplyData>().getReplyData;

    return Column(
      children: [
        (context.watch<AddReplyData>().getReplyData.length > 0)
            ? ReplyMessageIndicator(
                messageData: context.watch<AddReplyData>().getReplyData[0],
              )
            // Container(
            //     decoration: BoxDecoration(
            //       border: Border(
            //         top: BorderSide(color: Colors.grey[200], width: 1),
            //       ),
            //     ),
            //     padding: EdgeInsets.all(8),
            //     child: Row(
            //       children: [
            //         Text(
            //           context.watch<AddReplyData>().getReplyData[0]["message"],
            //           maxLines: 1,
            //           overflow: TextOverflow.ellipsis,
            //         ),
            //       ],
            //     ),
            //   )
            : SizedBox.shrink(),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                widget.showIcon();
              },
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: SizedBox(
                  child: (widget.showSelectMedia)
                      ? Icon(
                          Icons.close,
                          size: 32,
                        )
                      : Icon(
                          Icons.attach_file,
                          size: 30,
                        ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: controller,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  minLines: 1,
                  // maxLength: 65000,
                  // maxLengthEnforced: true,
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "andika ujumbe wako"),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => sendMessage(replyData).whenComplete(() {
                widget.scrollTo.scrollTo(
                  index: 0,
                  duration: Duration(milliseconds: 200),
                );
                controller.clear();
                Provider.of<AddReplyData>(context, listen: false).unsetReply();
              }),
              child: Container(
                padding: EdgeInsets.all(5.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: MyColors.primaryLight,
                  child: Center(
                    child: Icon(Icons.send_rounded, color: Colors.white, size: 25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
