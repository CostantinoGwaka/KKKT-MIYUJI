import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miyuji/matukio/screens/single_post_screen.dart';
import 'package:miyuji/utils/TextStyles.dart';
import 'package:miyuji/utils/my_colors.dart';

class MatukioScreen extends StatefulWidget {
  const MatukioScreen({Key? key}) : super(key: key);

  @override
  _MatukioScreenState createState() => _MatukioScreenState();
}

class _MatukioScreenState extends State<MatukioScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        middle: Text(
          "Matukio",
          style: TextStyles.headline(context).copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MyColors.primaryLight,
          ),
        ),
      ),
      child: ListView.builder(
        itemCount: 20,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: MyColors.white, width: 2.0),
              borderRadius: BorderRadius.circular(15),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SinglePostScreen()));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: [
                        Card(
                          elevation: 5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/miyuji.jpg',
                              fit: BoxFit.fill,
                              width: double.infinity,
                              height: 200,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      child: Row(children: <Widget>[
                        Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 35,
                              child: CircleAvatar(
                                backgroundImage: AssetImage("assets/images/logo.png"),
                              ),
                            ),
                            Container()
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 290,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "POST TITLE",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Helvetica",
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "12-02-2021 09:30 AM",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "Helvetica",
                                        color: Colors.black87,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Container(
                              //   child: Row(
                              //     children: <Widget>[
                              //       Text("@${widget.video.user}", style: TextStyle(fontSize: 14, fontFamily: "Helvetica", color: Color(0xFF909090))),
                              //       Text(" ∙ ", style: TextStyle(fontSize: 14, fontFamily: "Helvetica", color: Color(0xFF909090))),
                              //       SizedBox(
                              //         width: 5,
                              //       ),
                              //       Icon(
                              //         TikTokIcons.heart,
                              //         color: Colors.black54,
                              //         size: 15,
                              //       ),
                              //       SizedBox(
                              //         width: 5,
                              //       ),
                              //       Text("${widget.video.likes}" + " likes",
                              //           style: TextStyle(fontSize: 14, fontFamily: "Helvetica", color: Color(0xFF909090))),
                              //       Text(" ∙ ", style: TextStyle(fontSize: 14, fontFamily: "Helvetica", color: Color(0xFF909090))),
                              //       SizedBox(
                              //         width: 5,
                              //       ),
                              //       Icon(
                              //         TikTokIcons.chat_bubble,
                              //         color: Colors.black54,
                              //         size: 15,
                              //       ),
                              //       SizedBox(
                              //         width: 5,
                              //       ),
                              //       Text(
                              //         "${widget.video.comments}" + " coments",
                              //         style: TextStyle(fontSize: 14, fontFamily: "Helvetica", color: Color(0xFF909090)),
                              //       ),
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                        )
                      ]),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
