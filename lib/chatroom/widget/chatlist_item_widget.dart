import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:miyuji/chatroom/screen/chat_section_screen.dart';
import 'package:miyuji/utils/spacer.dart';

enum MessageType { normal, photo, video, document, contact }

class ChatListItem extends StatefulWidget {
  final String name;
  final String uid;
  final String picture;
  final bool online;
  final bool selected;
  final int count;
  final MessageType type;
  final String text;
  final String time;
  final String lastMessage;
  final String friendId;
  final String detpId;

  const ChatListItem(
      {super.key, @required this.name,
      this.friendId,
      this.detpId,
      this.uid,
      @required this.picture,
      this.online,
      @required this.count,
      @required this.type,
      this.text,
      this.selected,
      this.lastMessage,
      @required this.time});

  @override
  _ChatListItemState createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  TextStyle media = const TextStyle(fontSize: 14);
  TextStyle small = const TextStyle(fontSize: 10);
  double iconSize = 18;
  String token = null;

  @override
  void initState() {
    FirebaseDatabase.instance.reference().child("users/${widget.friendId}/token").once().then((snap) {
      setState(() {
        token = snap.value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatSectionScreen(
              friendId: widget.friendId,
              fullname: widget.name,
              picture: widget.picture,
              deptId: widget.detpId,
              token: token,
            ),
          ),
        );
      },
      //  Navigator().push(
      //   context,
      //   child: ,
      // ),
      // onLongPress: widget.onLongPress,
      leading: const CircleAvatar(
        radius: 30,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage("assets/images/profile.png"),
        // child: _renderOnline(),
      ),
      title: Text(
        widget.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: deviceWidth(context) / 25),
      ),
      subtitle: _renderSubtitle(context),
      trailing: _renderTailing(context),
    );
  }

  Widget _count(BuildContext context) {
    return CircleAvatar(
      radius: deviceWidth(context) / 45,
      backgroundColor: Colors.green,
      child: Text(
        widget.count < 100 ? widget.count.toString() : "99+",
        style: TextStyle(
          color: Colors.white,
          fontSize: deviceWidth(context) / 40,
        ),
      ),
    );
  }

  Widget _renderTailing(BuildContext context) {
    if (widget.count > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          manualStepper(step: 5),
          _count(context),
          manualStepper(step: 5),
          Text(
            widget.time,
            style: small,
          )
        ],
      );
    } else {
      return Text(
        widget.time,
        style: small,
      );
    }
  }

  Widget _renderSubtitle(BuildContext context) {
    switch (widget.type) {
      case MessageType.normal:
        return RichText(
          softWrap: false,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          strutStyle: const StrutStyle(fontSize: 12.0),
          text: TextSpan(
              style: const TextStyle(
                color: Colors.black,
              ),
              text: widget.lastMessage),
        );
        break;
      case MessageType.photo:
        return Row(
          children: <Widget>[
            Icon(
              Icons.photo,
              size: iconSize,
            ),
            Text(
              "Photo",
              style: media,
            )
          ],
        );
        break;
      case MessageType.video:
        return Row(
          children: <Widget>[
            Icon(
              Icons.video_call,
              size: iconSize,
            ),
            Text(
              "Video",
              style: media,
            )
          ],
        );
        break;
      case MessageType.document:
        return Row(
          children: <Widget>[
            Icon(
              Icons.file_copy,
              size: iconSize,
            ),
            Text(
              "Fail",
              style: media,
            )
          ],
        );
        break;
      case MessageType.contact:
        return Row(
          children: <Widget>[
            Icon(
              Icons.contact_page,
              size: iconSize,
            ),
            Text(
              "Phone",
              style: media,
            )
          ],
        );
        break;
      default:
        return Text(
          "Ujumbe",
          style: media,
        );
    }
  }
}
