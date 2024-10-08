import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miyuji/chatroom/screen/chat_list_screen.dart';
import 'package:miyuji/chatroom/widget/new_chat_bottom_sheet.dart';
import 'package:miyuji/utils/TextStyles.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  AnimationController _controller;

  static const List<IconData> icons = const [Icons.sms, Icons.phone];

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  void resetBtn() {
    //reset button
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitDown,
                DeviceOrientation.portraitUp,
              ]);
              Navigator.pop(context);
            },
          ),
          middle: Text(
            "Mazungumzo",
            style: TextStyles.headline(context).copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyColors.primaryLight,
            ),
          ),
        ),
        child: Scaffold(
          body: ChatListScreen(),
          floatingActionButton: new Column(
            mainAxisSize: MainAxisSize.min,
            children: new List.generate(icons.length, (int index) {
              Widget child = new Container(
                height: 70.0,
                width: 56.0,
                alignment: FractionalOffset.topCenter,
                child: new ScaleTransition(
                  scale: new CurvedAnimation(
                    parent: _controller,
                    curve: new Interval(0.0, 1.0 - index / icons.length / 2.0, curve: Curves.easeOut),
                  ),
                  child: new FloatingActionButton(
                    heroTag: null,
                    backgroundColor: MyColors.primaryLight,
                    mini: true,
                    child: new Icon(icons[index], color: MyColors.white),
                    onPressed: () {
                      if (index == 0) {
                        resetBtn();
                        return showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Colors.black,
                          context: context,
                          builder: (context) => ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                              ),
                              child: NewChatBottomSheet(),
                            ),
                          ),
                        );
                      } else {
                        resetBtn();
                        launch("tel://+255 659 515 042");
                      }
                    },
                  ),
                ),
              );
              return child;
            }).toList()
              ..add(
                new FloatingActionButton(
                  backgroundColor: MyColors.primaryLight,
                  heroTag: null,
                  child: new AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget child) {
                      return new Transform(
                        transform: new Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                        alignment: FractionalOffset.center,
                        child: new Icon(_controller.isDismissed ? Icons.add : Icons.close),
                      );
                    },
                  ),
                  onPressed: () {
                    if (_controller.isDismissed) {
                      _controller.forward();
                    } else {
                      _controller.reverse();
                    }
                  },
                ),
              ),
          ),
        ));

    // floatingActionButton: FloatingActionButton(
    //   onPressed: () => showModalBottomSheet(
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10.0),
    //     ),
    //     backgroundColor: Colors.transparent,
    //     context: context,
    //     builder: (context) => Container(
    //       decoration: BoxDecoration(
    //         color: Colors.grey[100],
    //       ),
    //       child: NewChatBottomSheet(),
    //     ),
    //   ),
    //   child: Icon(Icons.comment_rounded),
    // ),
    // );
  }
}
