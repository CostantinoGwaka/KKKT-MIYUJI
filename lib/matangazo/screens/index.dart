import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miyuji/matukio/screens/single_post_screen.dart';
import 'package:miyuji/utils/TextStyles.dart';
import 'package:miyuji/utils/image.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:miyuji/models/matangazo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lottie/lottie.dart';

class MatangazoScreen extends StatefulWidget {
  const MatangazoScreen({Key? key}) : super(key: key);

  @override
  _MatangazoScreenState createState() => _MatangazoScreenState();
}

class _MatangazoScreenState extends State<MatangazoScreen> {
  List<Matangazo> listmatangazo = <Matangazo>[];

  Future<List<Matangazo>> getMatangazoNew() async {
    String myApi = "http://miyujikkkt.or.tz/api/get_matangazo.php";
    final response = await http.post(myApi, headers: {'Accept': 'application/json'});

    var matangazoList = <Matangazo>[];
    var tangazo;

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        tangazo = json;
      }
    }

    tangazo.forEach(
      (element) {
        Matangazo video = Matangazo.fromJson(element);
        matangazoList.add(video);
      },
    );
    return matangazoList;
  }

  Future<void> _pullRefresh() async {
    getMatangazoNew().then((value) {
      setState(() {
        //finish
      });
      return;
    });
  }

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
          "Matangazo",
          style: TextStyles.headline(context).copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MyColors.primaryLight,
          ),
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: StreamBuilder(
          //Error number 2
          stream: getMatangazoNew().asStream(),
          builder: (context, AsyncSnapshot<List<Matangazo>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(90.0),
                    child: Column(
                      children: [
                        SizedBox(
                          child: Lottie.asset(
                            'assets/animation/fetching.json',
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Material(
                          child: Text(
                            "Inapanga taarifa",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              color: MyColors.primaryLight,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError || !snapshot.hasData) {
              return RefreshIndicator(
                onRefresh: _pullRefresh,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(70.0),
                      child: Column(
                        children: [
                          SizedBox(
                            child: Lottie.asset(
                              'assets/animation/nodata.json',
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Material(
                            child: Text(
                              "Hakuna taarifa zilizopatikana",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                color: MyColors.primaryLight,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: MyColors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SinglePostScreen(postdata: snapshot.data![index])));
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
                                    child: ImagePreview(
                                      img: 'http://miyujikkkt.or.tz/admin/matangazo/${snapshot.data![index].image}',
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                      height: 200,
                                    ),
                                    // Image.network(
                                    //   'http://miyujikkkt.or.tz/admin/matangazo/${snapshot.data![index].image}',
                                    //   fit: BoxFit.fill,
                                    //   width: double.infinity,
                                    //   height: 200,
                                    // ),
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 290,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data![index].title,
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
                                            Text(
                                              DateFormat('dd-MM-yyyy').format(snapshot.data![index].tarehe),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              style: const TextStyle(
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
                                )
                              ]),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Text("new videos");
            }
          },
        ),
      ),
    );
  }
}
