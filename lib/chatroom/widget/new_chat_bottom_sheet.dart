import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanisaapp/chatroom/screen/chat_section_screen.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/spacer.dart';
import 'package:lottie/lottie.dart';

import 'package:firebase_database/firebase_database.dart';

class NewChatBottomSheet extends StatelessWidget {
  var readBy = [];

  NewChatBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseDatabase.instance.ref().child("staffs").onValue,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && !snapshot.hasError && snapshot.data.snapshot.value != null) {
          List listItem = [];
          Map<dynamic, dynamic> item = snapshot.data.snapshot.value;
          item.forEach(
            (key, value) {
              listItem.add(value);
            },
          );
          // listItem.sort((a, b) => b["time"].compareTo(a["time"]));
          return Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ListView.builder(
              itemCount: listItem.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 2,
                    right: 10,
                    left: 10,
                    top: 2,
                  ),
                  child: GestureDetector(
                    onTap: () async => {
                      Navigator.pop(context),
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatSectionScreen(
                            friendId: listItem[index]["id"],
                            fullname: listItem[index]["type"],
                            picture: listItem[index]["picture"],
                            deptId: listItem[index]["deptId"],
                            token: listItem[index]["token"],
                          ),
                        ),
                      )
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0.0, 2.0), //(x,y)
                            blurRadius: 3.0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage("assets/images/profile.png"),
                          ),
                          manualSpacer(),
                          Text(
                            "${listItem[index]["type"]}",
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: SizedBox(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: deviceHeight(context) * .2,
                      child: Lottie.asset(
                        'assets/animation/loadchat.json',
                      ),
                    ),
                    Text(
                      "Hakuna ujumbe mazungumzo yeyote",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: MyColors.primaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
