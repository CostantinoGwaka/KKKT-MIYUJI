// ignore_for_file: depend_on_referenced_packages, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:kanisaapp/bloc/addReply.dart';
import 'package:kanisaapp/chatroom/cloud/message_handler.dart';
import 'package:kanisaapp/chatroom/widget/reply_navigator.dart';
import 'package:kanisaapp/models/message.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MessageInput extends StatefulWidget {
  final String? friendId;
  final bool? showSelectMedia;
  final Function? showIcon;
  final String? token;
  final String? fullname;
  final ItemScrollController? scrollTo;
  const MessageInput({
    super.key,
    this.friendId,
    this.showSelectMedia,
    this.showIcon,
    this.token,
    this.fullname,
    this.scrollTo,
  });
  @override
  // ignore: library_private_types_in_public_api
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  TextEditingController controller = TextEditingController();
  BaseUser? currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      currentUser = await UserManager.getCurrentUser();
      setState(() {});
    } catch (e) {
      // Handle error
    }
  }

  String _getUserDisplayName() {
    if (currentUser == null) return "Mtumiaji";

    if (currentUser is BaseUser && currentUser!.userType == 'ADMIN') {
      return (currentUser as BaseUser).fullName;
    } else if (currentUser is BaseUser && currentUser!.userType == 'MZEE') {
      return (currentUser as BaseUser).jina;
    } else if (currentUser is BaseUser && currentUser!.userType == 'KATIBU') {
      return (currentUser as BaseUser).jina;
    } else if (currentUser is BaseUser && currentUser!.userType == 'MSHARIKA') {
      return (currentUser as BaseUser).msharikaRecords.isNotEmpty
          ? (currentUser as BaseUser).msharikaRecords[0].jinaLaMsharika
          : "Mtumiaji";
    }
    return "Mtumiaji";
  }

  Future<void> sendMessage(List replyData) async {
    if (currentUser == null) return;

    String textMessage = controller.text;
    String id = const Uuid().v4();
    print("size# ${textMessage.length} $textMessage");
    if (controller.text.isEmpty || textMessage == "" || textMessage.isEmpty) {
      return;
    }
    HandleMessageFunction.sendNormalText(
      message: Message(
        access: true,
        readed: false,
        message: textMessage,
        friendId: widget.friendId,
        fullName: _getUserDisplayName(),
        messageId: id,
        color: "green",
        sentAt: DateTime.now().toString(),
        createdAt: DateTime.now().toString(),
        hostId: currentUser!.memberNo,
        reply: false,
        type: "text",
        repliedContent: (replyData.isNotEmpty) ? replyData[0] : null,
      ),
      receiverId: widget.friendId,
      senderId: currentUser!.memberNo,
      token: widget.token,
    );
  }

  @override
  Widget build(BuildContext context) {
    List replyData = context.watch<AddReplyData>().getReplyData;

    return Column(
      children: [
        (context.watch<AddReplyData>().getReplyData.isNotEmpty)
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
            : const SizedBox.shrink(),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                widget.showIcon!();
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  child: (widget.showSelectMedia!)
                      ? const Icon(
                          Icons.close,
                          size: 32,
                        )
                      : const Icon(
                          Icons.attach_file,
                          size: 30,
                        ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                margin: const EdgeInsets.only(left: 2, right: 2, bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: controller,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  minLines: 1,
                  // maxLength: 65000,
                  // maxLengthEnforced: true,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "andika ujumbe wako"),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => sendMessage(replyData).whenComplete(() {
                widget.scrollTo!.scrollTo(
                  index: 0,
                  duration: const Duration(milliseconds: 200),
                );
                controller.clear();
                Provider.of<AddReplyData>(context, listen: false).unsetReply();
              }),
              child: Container(
                padding: const EdgeInsets.all(5.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: MyColors.primaryLight,
                  child: const Center(
                    child:
                        Icon(Icons.send_rounded, color: Colors.white, size: 25),
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
