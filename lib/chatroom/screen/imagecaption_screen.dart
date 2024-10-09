import 'dart:io';
import 'package:flutter/material.dart';
import 'package:miyuji/bloc/addReply.dart';
import 'package:miyuji/chatroom/cloud/media_handler.dart';
import 'package:miyuji/utils/inputs.dart';
import 'package:miyuji/utils/spacer.dart';
import 'package:provider/provider.dart';

class ImageCaption extends StatefulWidget {
  final File imagefile;
  var widgetData;
  ImageCaption({super.key, required this.imagefile, this.widgetData});

  @override
  _ImageCaptionState createState() => _ImageCaptionState();
}

class _ImageCaptionState extends State<ImageCaption> {
  TextEditingController caption = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List replyData = context.watch<AddReplyData>().getReplyData;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.file(
              widget.imagefile,
              // fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 40,
            child: Container(
              decoration: BoxDecoration(color: Colors.white60, borderRadius: BorderRadius.circular(10)),
              // padding: EdgeInsets.all(4),
              width: deviceWidth(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InputField(
                      controller: caption,
                      label: "andika ujumbe wako",
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle, // You can use like this way or like the below line
                      //borderRadius: new BorderRadius.circular(30.0),
                      color: Colors.green,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        MediaHandler.getImage(
                          context,
                          widget.widgetData,
                          replyData,
                          widget.imagefile,
                          caption.text,
                        ).whenComplete(
                          () {
                            Provider.of<AddReplyData>(context, listen: false).unsetReply();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
