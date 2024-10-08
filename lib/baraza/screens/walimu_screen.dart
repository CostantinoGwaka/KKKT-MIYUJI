import 'dart:convert';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miyuji/models/walimu_washarika.dart';
import 'package:miyuji/utils/TextStyles.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:miyuji/utils/spacer.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class WalimuScreen extends StatefulWidget {
  const WalimuScreen({Key? key}) : super(key: key);

  @override
  _WalimuScreenState createState() => _WalimuScreenState();
}

class _WalimuScreenState extends State<WalimuScreen> {
  Future<List<WalimuUsharika>> getWalimuWasharika() async {
    String myApi = "http://miyujikkkt.or.tz/api/get_walimu.php";
    final response = await http.post(myApi as Uri, headers: {'Accept': 'application/json'});

    var barazaList = <WalimuUsharika>[];
    var baraza;

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        baraza = json;
      }
    }

    baraza.forEach(
      (element) {
        WalimuUsharika video = WalimuUsharika.fromJson(element);
        barazaList.add(video);
      },
    );
    return barazaList;
  }

  Future<void> _pullRefresh() async {
    getWalimuWasharika().then((value) {
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
          "Walimu",
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
          stream: getWalimuWasharika().asStream(),
          builder: (context, AsyncSnapshot<List<WalimuUsharika>> snapshot) {
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
                        const Text(
                          "Ingapanga taarifa",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0, color: Colors.black38),
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
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ExpansionTileCard(
                      baseColor: MyColors.white,
                      expandedColor: Colors.red[50],
                      // key: "$cardA",
                      leading: CircleAvatar(
                        backgroundColor: MyColors.white,
                        radius: 25,
                        child: Image.asset("assets/images/profile.png"),
                      ),
                      title: Text(snapshot.data![index].fname),
                      subtitle: Text(snapshot.data![index].wadhifa),
                      children: <Widget>[
                        const Divider(
                          thickness: 1.0,
                          height: 1.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "${snapshot.data![index].wadhifa} : ",
                                      style: TextStyles.caption(context).copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: MyColors.primaryLight,
                                      ),
                                    ),
                                    manualSpacer(step: 5),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data![index].fname,
                                          style: TextStyles.caption(context).copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.primaryLight,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data![index].phoneNo,
                                          style: TextStyles.caption(context).copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.primaryLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                    manualSpacer(step: 5),
                                    InkWell(
                                      onTap: () {
                                        launch("tel://${snapshot.data![index].phoneNo}");
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: MyColors.primaryLight,
                                        radius: 20,
                                        child: const Icon(
                                          Icons.call,
                                          size: 20,
                                          color: MyColors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                manualStepper(step: 5),
                                const Divider(
                                  thickness: 5,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
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
