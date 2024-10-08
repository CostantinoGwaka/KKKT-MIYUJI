import 'dart:convert';
import 'dart:ui';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miyuji/bloc/addReply.dart';
import 'package:miyuji/chatroom/cloud/cloud.dart';
import 'package:miyuji/chatroom/widget/image_holder.dart';
import 'package:miyuji/shared/localstorage/index.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:miyuji/utils/spacer.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:miyuji/home/screens/index.dart';

class MessageBubble extends StatefulWidget {
  final Function scrollTo;
  final message;
  final String replymessageid;

  const MessageBubble({key, this.message, this.scrollTo, this.replymessageid}) : super(key: key);

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  void initState() {
    // TODO: implement initState
    // getdataLocal();
    super.initState();
  }

  // void getdataLocal() async {
  //   LocalStorage.getStringItem('member_no').then((value) {
  //     if (value != null) {
  //       var mydata = jsonDecode(value);
  //       setState(() {
  //         host = mydata;
  //       });
  //     }
  //   });
  // }

  _clearMyChat() async {
    LocalStorage.getStringItem('member_no').then((value) {
      if (value != null) {
        var mydata = jsonDecode(value);
        host = mydata;
      }
    });
    if (await DataConnectionChecker().hasConnection) {
      await FirebaseDatabase.instance.reference().child('Messages/${host['member_no']}/${widget.message['receiverId']}').once().then(
        (DataSnapshot snapshot) {
          Map<dynamic, dynamic> values = snapshot.value;
          values.forEach(
            (i, value) => {Cloud.delete(serverPath: "Messages/${host['member_no']}/${widget.message['receiverId']}/${value['messageId']}")},
          );
        },
      ).whenComplete(
        () {
          Cloud.update(
            checkSnap: false,
            serverPath: "RecentChat/${host['member_no']}/${widget.message['receiverId']}",
            value: {
              "lastmessage": " ",
              "unseen": 0,
            },
          );
        },
      );
    } else {
      //no internet connection
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: (widget.message['messageId'] == widget.replymessageid) ? Colors.grey : null),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: (host['member_no'] != widget.message['senderId']) ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Align(
            alignment: (host['member_no'] != widget.message['senderId']) ? Alignment.centerLeft : Alignment.centerRight,
            child: FocusedMenuHolder(
              menuWidth: MediaQuery.of(context).size.width * 0.50,
              blurSize: 5.0,
              menuItemExtent: 45,
              menuBoxDecoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              duration: Duration(milliseconds: 100),
              animateMenuItems: true,
              blurBackgroundColor: Colors.black54,
              openWithTap: false, // Open Focused-Menu on Tap rather than Long Press
              menuOffset: 10.0, // Offset value to show menuItem from the selected item
              bottomOffsetHeight:
                  80.0, // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
              menuItems: <FocusedMenuItem>[
                // Add Each FocusedMenuItem  for Menu Options
                FocusedMenuItem(
                    title: Text(
                      "Nakili",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    trailingIcon: Icon(
                      Icons.copy,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Clipboard.setData(
                        new ClipboardData(text: '${widget.message['message']}'),
                      );
                    }),
                FocusedMenuItem(
                  title: Text(
                    "Futa Ujumbe",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  trailingIcon: Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Cloud.delete(serverPath: "Messages/${host['member_no']}/${widget.message['receiverId']}/${widget.message['messageId']}").whenComplete(
                      () => {Cloud.delete(serverPath: "Messages/${widget.message['receiverId']}/${widget.message['senderId']}/${widget.message['messageId']}")},
                    );
                  },
                ),
                FocusedMenuItem(
                  title: Text(
                    "Jibu",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  trailingIcon: Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    try {
                      Provider.of<AddReplyData>(context, listen: false).setReplyData(widget.message);
                    } catch (er) {
                      print("hahahaha this is error: $er");
                    }
                  },
                ),
                FocusedMenuItem(
                  title: Text(
                    "Futa jumbe zote",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  trailingIcon: Icon(
                    Icons.clear,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    _clearMyChat();
                  },
                )
              ],
              onPressed: () {},
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 50,
                  maxWidth: deviceWidth(context) * 0.7,
                ),
                margin: EdgeInsets.only(bottom: 2.0, top: 2.0, left: 10, right: 10),
                padding: widget.message['type'] == "text" ? EdgeInsets.all(5) : EdgeInsets.all(0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 1.0,
                      spreadRadius: 0.0,
                      offset: Offset(1.0, 1.0),
                    )
                  ],
                  color: (host['member_no'] != widget.message['senderId']) ? Colors.white : MyColors.primaryLight,
                  borderRadius: (host['member_no'] == widget.message['senderId'])
                      ? BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(20.0),
                        )
                      : BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (widget.message["repliedContent"] != null)
                            ? GestureDetector(
                                onTap: widget.scrollTo,
                                child: Container(
                                  width: deviceWidth(context) * 0.7,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(bottom: 10),
                                  constraints: BoxConstraints(
                                    minWidth: 50,
                                    maxWidth: deviceWidth(context) * 0.7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    border: Border(
                                      left: BorderSide(width: 5, color: Colors.green[900]),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        host['member_no'].toString() == widget.message["repliedContent"]['sender'] ? "Wewe" : "Mtumishi",
                                        style: TextStyle(fontWeight: FontWeight.w900, color: Colors.green),
                                      ),
                                      Text(
                                        widget.message["repliedContent"]["message"],
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : manualStepper(step: 0),
                        //normal message render
                        (widget.message['type'] == "text")
                            ? Text(
                                "${widget.message['message']}",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: (host['member_no'] == widget.message['senderId']) ? MyColors.white : Colors.black,
                                ),
                              )
                            : manualStepper(step: 0),

                        //normal message render
                        (widget.message['type'] == "document")
                            ? GestureDetector(
                                onTap: () async {
                                  if (await canLaunch('${widget.message['mediaUrl']}')) {
                                    await launch('${widget.message['mediaUrl']}');
                                  } else {
                                    print('Could not launch ${widget.message['mediaUrl']}');
                                  }
                                },
                                child: Card(
                                  color: Colors.grey[200],
                                  margin: EdgeInsets.all(0.0),
                                  elevation: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Icon(
                                          Icons.description,
                                          color: widget.message['medianame'].toString().split('.').last == 'pdf'
                                              ? Colors.red
                                              : widget.message['medianame'].toString().split('.').last == 'doc'
                                                  ? Colors.blue
                                                  : Colors.grey,
                                        ),
                                        manualSpacer(),
                                        Expanded(
                                            child: Text(
                                          "${widget.message['medianame']}",
                                          style: TextStyle(color: Colors.black87, fontSize: 12),
                                        )),
                                      ]),
                                    ]),
                                  ),
                                ),
                              )
                            : manualStepper(step: 0),

                        //photo message render
                        (widget.message['type'] == "photo")
                            ? GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    isScrollControlled: true,
                                    isDismissible: true,
                                    builder: (BuildContext context) {
                                      return BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 50.0),
                                          child: Container(
                                            child: DraggableScrollableSheet(
                                                initialChildSize: 0.75,
                                                maxChildSize: 0.75,
                                                minChildSize: 0.75,
                                                expand: true,
                                                builder: (context, scrollController) {
                                                  return SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          child: Image.network(
                                                            '${widget.message['mediaUrl']}',
                                                            fit: BoxFit.fitWidth,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: deviceWidth(context) / 20,
                                                        ),
                                                        Text(
                                                          "${widget.message['caption']}",
                                                          style: TextStyle(fontSize: deviceWidth(context) / 25, color: Colors.white),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                    width: deviceWidth(context) * 0.65,
                                    height: 200.0,
                                    child: Hero(
                                      tag: "${widget.message['mediaUrl']}",
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: ImageView(fit: BoxFit.cover, img: '${widget.message['mediaUrl']}'),
                                      ),
                                    )),
                              )
                            : manualStepper(step: 0),
                        (widget.message["caption"] != null && widget.message["caption"] != "")
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.message["caption"]),
                              )
                            : manualStepper(step: 0)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
