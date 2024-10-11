import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:miyuji/chatroom/widget/chatlist_item_widget.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:miyuji/utils/spacer.dart';
import 'package:lottie/lottie.dart';
import 'package:miyuji/home/screens/index.dart';

// var host;
var query;

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  var valueQuery;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getdataLocal();
  }

  // void getdataLocal() async {
  //   await LocalStorage.getStringItem('member_no').then((value) {
  //     if (value != null) {
  //       var mydata = jsonDecode(value);
  //       setState(() {
  //         host = mydata;
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseDatabase.instance.ref().child("RecentChat/${host['member_no']}").onValue,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.hasData && !snapshot.hasError && snapshot.data.snapshot.value != null) {
              List listItem = [];
              Map<dynamic, dynamic> item = snapshot.data.snapshot.value;
              final now = DateTime.now();
              item.forEach(
                (key, value) {
                  listItem.add(value);
                },
              );
              listItem.sort((a, b) => b["time"].compareTo(a["time"]));
              return ListView.builder(
                itemCount: listItem.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Expanded(
                        child: ChatListItem(
                          name: listItem[index]["fullname"],
                          friendId: listItem[index]["userId"],
                          detpId: listItem[index]["deptId"],
                          uid: listItem[index]["userId"],
                          picture: listItem[index]["picture"],
                          count: listItem[index]["unseen"],
                          type: MessageType.normal,
                          time: DateTime.parse(listItem[index]['time']).day == now.day
                              ? DateFormat.jm().format(DateTime.parse(listItem[index]['time'])).toString()
                              : DateFormat.yMMMd().format(DateTime.parse(listItem[index]['time'])).toString(),
                          lastMessage: listItem[index]["lastmessage"],
                          text: listItem[index]["lastmessage"],
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(top: deviceHeight(context) * .4),
                child: Center(
                  child: SizedBox(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: deviceHeight(context) * .2,
                          child: Lottie.asset(
                            'assets/animation/nochat.json',
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
          } else {
            return Center(
              child: SizedBox(
                height: 280,
                child: Lottie.asset(
                  'assets/animation/fetching.json',
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}

// class ChatListScreen extends StatefulWidget {
//   const ChatListScreen({key}) : super(key: key);

//   @override
//   _ChatListScreenState createState() => _ChatListScreenState();
// }

// class _ChatListScreenState extends State<ChatListScreen> {
//   //get my chat list
// var _query = FirebaseDatabase.instance
//     .reference()
//     .child("RecentChat/${User.userDetailHolder.userNumber}");

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

// @override
// Widget build(BuildContext context) {
//   var valueQuery = _query;
//   return Scaffold(
//     body: StreamBuilder(
//       stream: valueQuery.onValue,
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         if (snapshot.hasData) {
//           if (snapshot.hasData &&
//               !snapshot.hasError &&
//               snapshot.data.snapshot.value != null) {
//             List listItem = [];
//             Map<dynamic, dynamic> item = snapshot.data.snapshot.value;
//             final now = DateTime.now();
//             item.forEach(
//               (key, value) {
//                 listItem.add(value);
//               },
//             );
//             listItem.sort((a, b) => b["time"].compareTo(a["time"]));
//             return ListView.builder(
//               itemCount: listItem.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return Row(
//                   children: [

//                     Expanded(
//                       child: ChatListItem(
//                         name: listItem[index]["fullname"],
//                         uid: listItem[index]["userId"],
//                         picture: listItem[index]["picture"],
//                         count: listItem[index]["unseen"],
//                         type: MessageType.normal,
//                         time: DateTime.parse(listItem[index]['time']).day ==
//                                 now.day
//                             ? DateFormat.jm()
//                                 .format(
//                                     DateTime.parse(listItem[index]['time']))
//                                 .toString()
//                             : DateFormat.yMMMd()
//                                 .format(
//                                     DateTime.parse(listItem[index]['time']))
//                                 .toString(),
//                         lastMessage: listItem[index]["lastmessage"],
//                         text: listItem[index]["lastmessage"],
//                         onLongPress: () => {},
//                         onTap: () async {
//                           AppNavigation.push(
//                             context,
//                             child: ChatSectionScreen(
//                               friendId: listItem[index]["userId"],
//                               fullname: listItem[index]["fullname"],
//                               picture: listItem[index]["picture"],
//                               deptId: listItem[index]["deptId"] ,
//                               token: "token",
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             );
//           } else {
//             return Center(
//               child: UniversalFeedback(
//                 error: true,
//                 customLabel: "You have no recent chat",
//               ),
//             );
//           }
//         } else {
//           return Center(
//             child: UniversalFeedback(
//               customLabel: "Fetching your chat lists",
//             ),
//           );
//         }
//       },
//     ),
//   );
// }
// }
