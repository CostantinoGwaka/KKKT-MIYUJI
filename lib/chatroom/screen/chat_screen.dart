// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kanisaapp/chatroom/screen/chat_list_screen.dart';
import 'package:kanisaapp/chatroom/widget/new_chat_bottom_sheet.dart';
import 'package:kanisaapp/utils/TextStyles.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  late AnimationController _controller;

  static const List<IconData> icons = [Icons.sms, Icons.phone];

  @override
  void initState() {
    _controller = AnimationController(
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
            child: const Icon(Icons.arrow_back_ios),
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
          body: const ChatListScreen(),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(icons.length, (int index) {
              Widget child = Container(
                height: 70.0,
                width: 56.0,
                alignment: FractionalOffset.topCenter,
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _controller,
                    curve: Interval(0.0, 1.0 - index / icons.length / 2.0, curve: Curves.easeOut),
                  ),
                  child: FloatingActionButton(
                    heroTag: null,
                    backgroundColor: MyColors.primaryLight,
                    mini: true,
                    child: Icon(icons[index], color: MyColors.white),
                    onPressed: () {
                      if (index == 0) {
                        resetBtn();
                        showModalBottomSheet(
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
                        // ignore: deprecated_member_use
                        launch("tel://+255 659 515 042");
                      }
                    },
                  ),
                ),
              );
              return child;
            }).toList()
              ..add(
                FloatingActionButton(
                  backgroundColor: MyColors.white,
                  heroTag: null,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget? child) {
                      return Transform(
                        transform: Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                        alignment: FractionalOffset.center,
                        child: Icon(
                          _controller.isDismissed ? Icons.add : Icons.close,
                          color: Colors.black,
                        ),
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
