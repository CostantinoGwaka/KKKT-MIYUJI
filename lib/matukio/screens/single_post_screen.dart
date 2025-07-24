import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miyuji/utils/TextStyles.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:miyuji/utils/spacer.dart';
import 'package:intl/intl.dart';

class SinglePostScreen extends StatefulWidget {
  final dynamic postdata;
  const SinglePostScreen({super.key, this.postdata});

  @override
  _SinglePostScreenState createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
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
          "${widget.postdata.title}",
          style: TextStyles.headline(context).copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MyColors.primaryLight,
          ),
        ),
      ),
      child: Stack(
        children: [
          CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: deviceHeight(context) / 3,
              pinned: false,
              stretch: true,
              backgroundColor: MyColors.primaryLight,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: "msimu",
                  child: Image.network(
                    "https://kkktmiyuji.nitusue.com/admin/matangazo/${widget.postdata.image}",
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: deviceHeight(context) / 200),
                  Material(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.postdata.title}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Helvetica",
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                manualStepper(step: 5),
                                Text(
                                  DateFormat('dd-MM-yyyy').format(widget.postdata.tarehe),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Helvetica",
                                    color: Colors.black87,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                manualStepper(step: 5),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${widget.postdata.descp}",
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  letterSpacing: 1.4,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                manualStepper(step: 5),
                                const Text(
                                  "Imetumwa na @admin",
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ])
        ],
      ),
    );
  }
}
