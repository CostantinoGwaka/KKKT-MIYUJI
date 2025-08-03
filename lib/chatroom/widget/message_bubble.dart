// ignore_for_file: prefer_typing_uninitialized_variables, library_private_types_in_public_api, deprecated_member_use, avoid_print, avoid_unnecessary_containers

import 'dart:ui';

// import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanisaapp/bloc/addReply.dart';
import 'package:kanisaapp/chatroom/cloud/cloud.dart';
import 'package:kanisaapp/chatroom/widget/image_holder.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/spacer.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import 'package:kanisaapp/models/user_models.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageBubble extends StatefulWidget {
  final GestureTapCallback scrollTo;
  final message;
  final String? replymessageid;

  // ignore: use_super_parameters
  const MessageBubble({key, this.message, required this.scrollTo, this.replymessageid}) : super(key: key);

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  BaseUser? currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      currentUser = await UserManager.getCurrentUser();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  _clearMyChat() async {
    if (currentUser == null) return;

    // if (await DataConnectionChecker().hasConnection) {
    final databaseRef = FirebaseDatabase.instance.ref();

    databaseRef
        .child('Messages/${currentUser!.memberNo}/${widget.message['receiverId']}')
        .once()
        .then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;

      // Check if snapshot contains data
      if (snapshot.exists && snapshot.value != null) {
        // Cast snapshot value to a Map
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;

        values.forEach((key, value) {
          // Ensure value is a Map before accessing keys
          if (value is Map<dynamic, dynamic>) {
            Cloud.delete(
                serverPath: "Messages/${currentUser!.memberNo}/${widget.message['receiverId']}/${value['messageId']}");
          }
        });
      }
    }).whenComplete(() {
      // After completion, update RecentChat
      Cloud.update(
        checkSnap: false,
        serverPath: "RecentChat/${currentUser!.memberNo}/${widget.message['receiverId']}",
        value: {
          "lastmessage": " ",
          "unseen": 0,
        },
      );
    });

    // } else {
    //   //no internet connection
    // }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: (widget.message['messageId'] == widget.replymessageid) ? Colors.grey : null),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            (currentUser?.memberNo != widget.message['senderId']) ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Align(
            alignment:
                (currentUser?.memberNo != widget.message['senderId']) ? Alignment.centerLeft : Alignment.centerRight,
            child: FocusedMenuHolder(
              menuWidth: MediaQuery.of(context).size.width * 0.50,
              blurSize: 5.0,
              menuItemExtent: 45,
              menuBoxDecoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              duration: const Duration(milliseconds: 100),
              animateMenuItems: true,
              blurBackgroundColor: Colors.black54,
              openWithTap: false, // Open Focused-Menu on Tap rather than Long Press
              menuOffset: 10.0, // Offset value to show menuItem from the selected item
              bottomOffsetHeight:
                  80.0, // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
              menuItems: <FocusedMenuItem>[
                // Add Each FocusedMenuItem  for Menu Options
                FocusedMenuItem(
                    title: const Text(
                      "Nakili",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    trailingIcon: const Icon(
                      Icons.copy,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: '${widget.message['message']}'),
                      );
                    }),
                FocusedMenuItem(
                  title: const Text(
                    "Futa Ujumbe",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  trailingIcon: const Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Cloud.delete(
                            serverPath:
                                "Messages/${currentUser?.memberNo}/${widget.message['receiverId']}/${widget.message['messageId']}")
                        .whenComplete(
                      () {
                        Cloud.delete(
                            serverPath:
                                "Messages/${widget.message['receiverId']}/${widget.message['senderId']}/${widget.message['messageId']}");
                      },
                    );
                  },
                ),
                FocusedMenuItem(
                  title: const Text(
                    "Jibu",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  trailingIcon: const Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    try {
                      Provider.of<AddReplyData>(context, listen: false).setReplyData(widget.message);
                    } catch (er) {
                      if (kDebugMode) {
                        print("hahahaha this is error: $er");
                      }
                    }
                  },
                ),
                FocusedMenuItem(
                  title: const Text(
                    "Futa jumbe zote",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  trailingIcon: const Icon(
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
                margin: const EdgeInsets.only(bottom: 2.0, top: 2.0, left: 10, right: 10),
                padding: widget.message['type'] == "text" ? const EdgeInsets.all(5) : const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 1.0,
                      spreadRadius: 0.0,
                      offset: Offset(1.0, 1.0),
                    )
                  ],
                  color: (currentUser?.memberNo != widget.message['senderId']) ? Colors.white : MyColors.primaryLight,
                  borderRadius: (currentUser?.memberNo == widget.message['senderId'])
                      ? const BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(20.0),
                        )
                      : const BorderRadius.only(
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
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  constraints: BoxConstraints(
                                    minWidth: 50,
                                    maxWidth: deviceWidth(context) * 0.7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    border: Border(
                                      left: BorderSide(
                                        width: 5,
                                        color: Colors.green[900]!,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentUser?.memberNo.toString() == widget.message["repliedContent"]['sender']
                                            ? "Wewe"
                                            : "Mtumishi",
                                        style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.green),
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
                                  color: (currentUser?.memberNo == widget.message['senderId'])
                                      ? MyColors.white
                                      : Colors.black,
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
                                  margin: const EdgeInsets.all(0.0),
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
                                          style: const TextStyle(color: Colors.black87, fontSize: 12),
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
                                                          style: TextStyle(
                                                              fontSize: deviceWidth(context) / 25, color: Colors.white),
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
                                child: SizedBox(
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
