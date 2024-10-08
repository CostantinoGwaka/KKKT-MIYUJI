import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:miyuji/bloc/addReply.dart';
import 'package:miyuji/shared/localstorage/index.dart';
import 'package:provider/provider.dart';
import 'package:miyuji/home/screens/index.dart';

// var host;

class ReplyMessageIndicator extends StatefulWidget {
  const ReplyMessageIndicator({key, this.messageData}) : super(key: key);
  final dynamic messageData;

  @override
  _ReplyMessageIndicatorState createState() => _ReplyMessageIndicatorState();
}

class _ReplyMessageIndicatorState extends State<ReplyMessageIndicator> {
  @override
  void initState() {
    // TODO: implement initState
    // checkLogin();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[200], width: 1))),
      padding: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.reply_all,
                textDirection: TextDirection.rtl,
                color: Colors.green,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.messageData['sender'] == host['member_no'] ? "Wewe" : "Mtumishi",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      () {
                        return Container(
                          child: Text(
                            '${widget.messageData['message']}',
                            style: TextStyle(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }(),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Provider.of<AddReplyData>(context, listen: false).unsetReply();
                },
                child: Icon(
                  Icons.close,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
