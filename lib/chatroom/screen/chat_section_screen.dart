import 'dart:io';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miyuji/bloc/addReply.dart';
import 'package:miyuji/bloc/pointer.dart';
import 'package:miyuji/chatroom/cloud/cloud.dart';
import 'package:miyuji/chatroom/cloud/media_handler.dart';
import 'package:miyuji/chatroom/widget/message_bubble.dart';
import 'package:miyuji/chatroom/widget/message_input.dart';
import 'package:miyuji/models/message.dart';
import 'package:miyuji/models/recent_chat.dart';
import 'package:miyuji/utils/TextStyles.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:miyuji/utils/spacer.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import './imagecaption_screen.dart';
import 'package:miyuji/home/screens/index.dart';

class ChatSectionScreen extends StatefulWidget {
  const ChatSectionScreen(
      {super.key,
      required this.fullname,
      required this.picture,
      this.fromFriends = false,
      this.friendId,
      this.deptId,
      this.token});

  final String? fullname;
  final String? friendId;
  final bool? fromFriends;
  final String? picture;
  final String? deptId;
  final String? token;

  @override
  _ChatSectionScreenState createState() => _ChatSectionScreenState();
}

class _ChatSectionScreenState extends State<ChatSectionScreen> {
  var readBy = [];
  bool showSelectMedia = false;
  static final picker = ImagePicker();
  String replymessageid = '';
  final ItemScrollController _scrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  bool? needToPaginate;

  Future<void> sendImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    File image = File(pickedFile!.path);
    if (image.lengthSync() <= 8000000) {
      //create file to be uploaded to the server
      image = await File(pickedFile.path).create();

      return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
          ),
          child: ImageCaption(
            imagefile: image,
            widgetData: widget,
          ),
        ),
      );
    }
  }

  List messages = [];

  @override
  void initState() {
    super.initState();
    // checkLogin();
    sendFirstMessage();
    Cloud.update(
      checkSnap: false,
      serverPath: "RecentChat/${host['member_no']}/${widget.friendId}/",
      value: {
        "unseen": 0,
      },
    );
    Provider.of<AddReplyData>(context, listen: false).unsetReply();

    itemPositionsListener.itemPositions.addListener(() {
      // doSomethingWith(itemPositionsListener.itemPositions.value);
      final positions = itemPositionsListener.itemPositions.value;
      final firstPosition = positions.first;
      final elevated = firstPosition.index != 0 || firstPosition.itemLeadingEdge != 0;
      setDataToPointerProvider(elevated, context);
    });
  }

  // void checkLogin() async {
  //   LocalStorage.getStringItem('member_no').then((value) {
  //     if (value != null) {
  //       var mydata = jsonDecode(value);
  //       setState(() {
  //         host = mydata;
  //       });
  //     }
  //   });
  // }

  setDataToPointerProvider(bool position, BuildContext context) {
    bool check = context.read<AddPointerData>().getitem;
    if ((check == false) && (position == true)) {
      Provider.of<AddPointerData>(context, listen: false).setItem(true);
    } else if ((check == true) && (position == false)) {
      Provider.of<AddPointerData>(context, listen: false).setItem(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    // _scrollController.removeListener(_scrollListener);
    Provider.of<AddReplyData>(context, listen: false).unsetReply();
    Cloud.update(
      checkSnap: false,
      serverPath: "RecentChat/${host['member_no']}/${widget.friendId}/",
      value: {
        "unseen": 0,
      },
    );
    super.deactivate();
  }

  showIcon() {
    setState(() {
      showSelectMedia = !showSelectMedia;
    });
  }

  sendFirstMessage() {
    Object? userId;
    final databaseRef = FirebaseDatabase.instance.ref();

    databaseRef.child('RecentChat/${host['member_no']}/${widget.friendId}').once().then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            userId = snapshot.child('userId').value;
          }

          //add first message when user click to this item at first
          if (userId == null) {
            String id = const Uuid().v4();
            readBy.add(host['member_no']);

            //send message here
            Message(
              readBy: readBy,
              friendId: widget.friendId,
              hostId: host['member_no'],
              createdAt: DateTime.now().toString(),
              sentAt: DateTime.now().toString(),
              color: "green",
              message:
                  "Karibu ndugu ${host['fname']}, hapa upo kwa ${widget.fullname} tafadhari uliza chochote nitakusaidia",
              messageId: id,
              status: "sent",
              reply: false,
              type: "text",
              repliedContent: null,
              unseen: 0,
            ).handleSendMessage(
              convoId: widget.friendId,
              userId: host['member_no'],
              messageId: id,
            );

            //update recent chat
            Cloud.add(
              serverPath: "RecentChat/${host['member_no']}/${widget.friendId}",
              value: RecentChat(
                lastMessage: "Karibu KKKT miyuji",
                fullName: widget.fullname,
                picUrl: widget.picture,
                color: "pink",
                unseen: ServerValue.increment(0),
                time: DateTime.now().toString(),
                friendId: widget.friendId,
              ).toMap(),
            );
          }
        } as FutureOr Function(DatabaseEvent value));
  }

  @override
  Widget build(BuildContext context) {
    List replyData = context.watch<AddReplyData>().getReplyData;
    bool check = context.watch<AddPointerData>().getitem;

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: GestureDetector(
            child: const Icon(Icons.arrow_back_ios),
            onTap: () {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitDown,
                DeviceOrientation.portraitUp,
              ]);
              Navigator.pop(context);
            },
          ),
          middle: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage("assets/images/profile.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  widget.fullname!.toString(),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyles.headline(context).copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primaryLight,
                  ),
                ),
              ),
            ],
          ),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          // resizeToAvoidBottomPadding: false,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/chat_back.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/chat_back.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(children: [
                      StreamBuilder(
                        stream: FirebaseDatabase.instance
                            .ref()
                            .child("Messages/${host['member_no']}/${widget.friendId}")
                            .orderByChild('createdAt')
                            .onValue,
                        builder: (_, snap) {
                          if (snap.hasData) {
                            var data = [];

                            if (snap.data!.snapshot.value != null) {
                              Map<dynamic, dynamic> map = Map.from(snap.data!.snapshot.value as Map);
                              data = map.values.toList()..sort((a, b) => b['sentAt'].compareTo(a['sentAt']));
                            }
                            return snap.data!.snapshot.value == null && data.isEmpty
                                ? const Center(
                                    child: Text("no chats"),
                                  )
                                : ScrollablePositionedList.builder(
                                    physics: const BouncingScrollPhysics(),
                                    reverse: true,
                                    itemCount: data.length,
                                    itemScrollController: _scrollController,
                                    itemPositionsListener: itemPositionsListener,
                                    itemBuilder: (_, i) {
                                      var snap = data[i];
                                      // item.setItem(
                                      //     _scrollController.position.pixels);
                                      return Column(
                                        children: [
                                          MessageBubble(
                                            message: snap,
                                            replymessageid: replymessageid,
                                            scrollTo: () {
                                              int index = data.indexWhere((element) =>
                                                  element["messageId"] == snap["repliedContent"]["messageId"]);
                                              if (index > 0) {
                                                _scrollController.scrollTo(
                                                  index: index,
                                                  duration: const Duration(milliseconds: 500),
                                                );

                                                //set replymessageId
                                                setState(() {
                                                  replymessageid = snap['repliedContent'] != null
                                                      ? snap['repliedContent']['messageId']
                                                      : null;
                                                });

                                                //unset
                                                Timer(
                                                  const Duration(seconds: 3),
                                                  () {
                                                    setState(() {
                                                      replymessageid = "";
                                                    });
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                          //bottom of message bubble
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: (host['member_no'] != snap['senderId'])
                                                ? MainAxisAlignment.start
                                                : MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5.0, right: 10, left: 10),
                                                child: Align(
                                                  alignment: Alignment.bottomRight,
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text: DateFormat.jm()
                                                          .format(
                                                            DateTime.parse(snap['sentAt']),
                                                          )
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    },
                                  );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                      // scroll down to message button
                      (check == true)
                          ? Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(deviceHeight(context) / 30),
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: deviceHeight(context) / 40,
                                    backgroundColor: Colors.green[100],
                                    child: IconButton(
                                      onPressed: () {
                                        Provider.of<AddPointerData>(context, listen: false).setItem(false);
                                        _scrollController.scrollTo(
                                          index: 0,
                                          duration: const Duration(milliseconds: 500),
                                        );
                                      },
                                      icon: const Icon(Icons.arrow_circle_down),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : manualSpacer(step: 0)
                    ]),
                  ),
                ),
                MessageInput(
                  friendId: widget.friendId.toString(),
                  showSelectMedia: showSelectMedia,
                  showIcon: showIcon,
                  token: widget.token.toString(),
                  fullname: widget.fullname.toString(),
                  scrollTo: _scrollController,
                ),
              ],
            ),
          ),
          floatingActionButton: showSelectMedia
              ? Padding(
                  padding: const EdgeInsets.only(right: 275.0, bottom: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        backgroundColor: MyColors.primaryLight,
                        onPressed: () => sendImage(context).whenComplete(() {
                          _scrollController.scrollTo(
                            index: 0,
                            duration: const Duration(milliseconds: 200),
                          );
                          Provider.of<AddReplyData>(context, listen: false).unsetReply();
                          setState(() {
                            showSelectMedia = false;
                          });
                        }),
                        child: const Tooltip(
                          message: "Picha",
                          child: Icon(Icons.image),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      FloatingActionButton(
                        backgroundColor: MyColors.primaryLight,
                        onPressed: () {
                          MediaHandler.getDocument(context, widget, widget.token.toString(), replyData)
                              .whenComplete(() {
                            _scrollController.scrollTo(
                              index: 0,
                              duration: const Duration(milliseconds: 200),
                            );
                            // ignore: use_build_context_synchronously
                            Provider.of<AddReplyData>(context, listen: false).unsetReply();
                          });
                          setState(() {
                            showSelectMedia = false;
                          });
                        },
                        child: const Tooltip(
                          message: "faili",
                          child: Icon(Icons.file_present),
                        ),
                      ),
                      // SizedBox(
                      //   height: 8,
                      // ),
                      // FloatingActionButton(
                      //   onPressed: () {},
                      //   child: Icon(Icons.play_arrow_rounded),
                      // ),
                    ],
                  ),
                )
              : manualStepper(step: 0),
        ));
  }
}
