import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miyuji/models/viongozi_wakanisa.dart';
import 'package:miyuji/utils/TextStyles.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:miyuji/utils/spacer.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class ViongoziWaKanisa extends StatefulWidget {
  const ViongoziWaKanisa({Key? key}) : super(key: key);

  @override
  _ViongoziWaKanisaState createState() => _ViongoziWaKanisaState();
}

class _ViongoziWaKanisaState extends State<ViongoziWaKanisa> {
  Future<List<ViongoziWaKanisaData>> getViongozi() async {
    String myApi = "http://miyujikkkt.or.tz/api/get_viongozi_wakanisa.php";
    final response = await http.post(myApi, headers: {'Accept': 'application/json'});

    var barazaList = <ViongoziWaKanisaData>[];
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
        ViongoziWaKanisaData video = ViongoziWaKanisaData.fromJson(element);
        barazaList.add(video);
      },
    );
    print("data here $barazaList");
    return barazaList;
  }

  Future<void> _pullRefresh() async {
    getViongozi().then((value) {
      setState(() {
        //finish
      });
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.only(top: deviceHeight(context) / 10),
          child: Column(
            children: [
              Text(
                "Viongozi Wa Kanisa",
                style: TextStyles.headline(context).copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MyColors.primaryLight,
                ),
              ),
              SizedBox(
                height: deviceHeight(context) / 1,
                child: RefreshIndicator(
                  onRefresh: _pullRefresh,
                  child: FutureBuilder(
                    //Error number 2
                    future: getViongozi(),
                    builder: (context, AsyncSnapshot<List<ViongoziWaKanisaData>> snapshot) {
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
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: MyColors.white, width: 2.0),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  height: 70,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(
                                          // left: 10,
                                          top: 10,
                                          bottom: 10,
                                        ),
                                        child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 50,
                                                child: CircleAvatar(
                                                  backgroundColor: MyColors.white,
                                                  // backgroundImage: AssetImage("assets/images/viongozi.png"),
                                                  child: Image.asset(
                                                    "assets/images/useravatar.png",
                                                    // color: MyColors.primaryLight,
                                                    height: 70,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(left: 10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 200,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        snapshot.data![index].fname,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        softWrap: false,
                                                        style: GoogleFonts.montserrat(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold,
                                                          color: MyColors.primaryLight,
                                                        ),
                                                      ),
                                                      manualStepper(step: 10),
                                                      Text(
                                                        snapshot.data![index].wadhifa,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        softWrap: false,
                                                        style: GoogleFonts.montserrat(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.normal,
                                                          color: MyColors.primaryLight,
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
                        return const Text("error problem");
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
