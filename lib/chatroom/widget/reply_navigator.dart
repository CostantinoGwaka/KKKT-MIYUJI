// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:kanisaapp/bloc/addReply.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:provider/provider.dart';

// var host;

class ReplyMessageIndicator extends StatefulWidget {
  const ReplyMessageIndicator({key, this.messageData}) : super(key: key);
  final dynamic messageData;

  @override
  _ReplyMessageIndicatorState createState() => _ReplyMessageIndicatorState();
}

class _ReplyMessageIndicatorState extends State<ReplyMessageIndicator> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1))),
      padding: const EdgeInsets.all(8),
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
              const Icon(
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
                        widget.messageData['sender'] == currentUser?.memberNo ? "Wewe" : "Mtumishi",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      () {
                        return Text(
                          '${widget.messageData['message']}',
                          style: const TextStyle(color: Colors.black),
                          overflow: TextOverflow.ellipsis,
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
                child: const Icon(
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
