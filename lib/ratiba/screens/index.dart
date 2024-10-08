import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kinyerezi/models/akaunti.dart';
import 'package:kinyerezi/models/ratiba_ibada.dart';
import 'package:kinyerezi/utils/TextStyles.dart';
import 'package:kinyerezi/utils/my_colors.dart';
import 'package:kinyerezi/utils/spacer.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class RatibaZaIbada extends StatefulWidget {
  const RatibaZaIbada({Key key}) : super(key: key);

  @override
  _RatibaZaIbadaState createState() => _RatibaZaIbadaState();
}

class _RatibaZaIbadaState extends State<RatibaZaIbada> {
  Future<List<IbadaRatiba>> getRatiba() async {
    String myApi = "http://kinyerezikkkt.or.tz/api/get_ibada.php";
    final response =
        await http.post(myApi, headers: {'Accept': 'application/json'});

    var barazaList = <IbadaRatiba>[];
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
        IbadaRatiba video = IbadaRatiba.fromJson(element);
        barazaList.add(video);
      },
    );
    return barazaList;
  }

  Future<List<AkauntiUsharikaPodo>> getAkaunti() async {
    print("data heere 1");
    String myApi = "http://kinyerezikkkt.or.tz/api/get_akaunti.php";
    final response =
        await http.post(myApi, headers: {'Accept': 'application/json'});

    var barazaList = <AkauntiUsharikaPodo>[];
    var baraza;

    print("data heere ${response.statusCode}");

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        baraza = json;
      }
    }
    print("data heere 2 $baraza");

    try {
      baraza.forEach(
        (element) {
          AkauntiUsharikaPodo video = AkauntiUsharikaPodo.fromJson(element);
          barazaList.add(video);
        },
      );
    } catch (e) {
      print("data error $e");
    }
    print("data here $barazaList");
    return barazaList;
  }

  Future<void> _pullRefresh() async {
    getRatiba().then((value) {
      setState(() {
        //finish
      });
      return;
    });
  }

  @override
  void initState() {
    super.initState();
    getAkaunti();
    getRatiba();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  "Ratiba Za Ibada",
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primaryLight,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "Akaunti za Kanisa",
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primaryLight,
                  ),
                ),
              ),
            ],
          ),
          // title: Text('Tabs Demo'),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                // Text(
                //   "Ratiba Za Ibada",
                //   style: TextStyles.headline(context).copyWith(
                //     fontSize: 18,
                //     fontWeight: FontWeight.bold,
                //     color: MyColors.primaryLight,
                //   ),
                // ),
                Expanded(
                  child: Container(
                    // height: deviceHeight(context) / 1,
                    child: RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: FutureBuilder(
                        future: getRatiba(),
                        builder: (context,
                            AsyncSnapshot<List<IbadaRatiba>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "inapanga taarifa",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0,
                                          color: MyColors.primaryLight,
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
                                        SizedBox(
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
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (_, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: MyColors.white, width: 2.0),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        height: 100,
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                left: 10,
                                                top: 10,
                                                bottom: 10,
                                              ),
                                              child: Row(children: <Widget>[
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Container(
                                                        width: 290,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      height:
                                                                          50,
                                                                      child:
                                                                          CircleAvatar(
                                                                        backgroundColor:
                                                                            MyColors.white,
                                                                        // backgroundImage: AssetImage("assets/images/viongozi.png"),
                                                                        child: Image
                                                                            .asset(
                                                                          "assets/images/kanisa.png",
                                                                          // color: MyColors.primaryLight,
                                                                          height:
                                                                              70,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                manualSpacer(
                                                                    step: 5),
                                                                Text(
                                                                  "${snapshot.data[index].jina}",
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  softWrap:
                                                                      false,
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: MyColors
                                                                        .primaryLight,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            manualStepper(
                                                                step: 10),
                                                            Row(
                                                              children: [
                                                                // Icon(
                                                                //   Icons.watch,
                                                                //   color: MyColors.primaryLight,
                                                                // ),
                                                                manualSpacer(
                                                                    step: 5),
                                                                Text(
                                                                  "${snapshot.data[index].muda}",
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  softWrap:
                                                                      false,
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: MyColors
                                                                        .primaryLight,
                                                                  ),
                                                                ),
                                                              ],
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
                                  ),
                                );
                              },
                            );
                          } else {
                            return Text("new videos");
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                // Text(
                //   "Ratiba Za Ibada",
                //   style: TextStyles.headline(context).copyWith(
                //     fontSize: 18,
                //     fontWeight: FontWeight.bold,
                //     color: MyColors.primaryLight,
                //   ),
                // ),
                Expanded(
                  child: Container(
                    // height: deviceHeight(context) / 1,
                    child: RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: FutureBuilder(
                        future: getAkaunti(),
                        builder: (context,
                            AsyncSnapshot<List<AkauntiUsharikaPodo>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "inapanga taarifa",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0,
                                          color: MyColors.primaryLight,
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
                                        SizedBox(
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
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (_, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: MyColors.white, width: 2.0),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        height: 100,
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                Clipboard.setData(
                                                  new ClipboardData(
                                                    text:
                                                        "${snapshot.data[index].namba}",
                                                  ),
                                                ).then((_) {
                                                  Scaffold.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          "Nambari ya akaunti imenakiliwa"),
                                                    ),
                                                  );
                                                });
                                              },
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor:
                                                      MyColors.white,
                                                  child: Image.asset(
                                                    snapshot.data[index].jina ==
                                                            "VODACOM"
                                                        ? "assets/payicons/mpesa.png"
                                                        : snapshot.data[index]
                                                                    .jina ==
                                                                "TIGO PESA"
                                                            ? "assets/payicons/tigopesa.png"
                                                            : "assets/payicons/cash.png",
                                                    height: 50,
                                                  ),
                                                ),
                                                title: Text(
                                                  "${snapshot.data[index].jina}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                                trailing: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${snapshot.data[index].namba}",
                                                    ),
                                                    Text(
                                                      "bonyeza kunakili",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            // Container(
                                            //   margin: EdgeInsets.only(
                                            //     left: 10,
                                            //     top: 10,
                                            //     bottom: 10,
                                            //   ),
                                            //   child: Row(children: <Widget>[
                                            //     Container(
                                            //       margin:
                                            //           EdgeInsets.only(left: 10),
                                            //       child: Column(
                                            //         crossAxisAlignment:
                                            //             CrossAxisAlignment
                                            //                 .start,
                                            //         children: <Widget>[
                                            //           Container(
                                            //             width: 290,
                                            //             child: Column(
                                            //               crossAxisAlignment:
                                            //                   CrossAxisAlignment
                                            //                       .start,
                                            //               mainAxisAlignment:
                                            //                   MainAxisAlignment
                                            //                       .start,
                                            //               children: [
                                            //                 Row(
                                            //                   children: [
                                            //                     Column(
                                            //                       children: <
                                            //                           Widget>[
                                            //                         Container(
                                            //                           height:
                                            //                               50,
                                            //                           child:
                                            //                               CircleAvatar(
                                            //                             backgroundColor:
                                            //                                 MyColors.white,
                                            //                             // backgroundImage: AssetImage("assets/images/viongozi.png"),
                                            //                             child: Image
                                            //                                 .asset(
                                            //                               snapshot.data[index].jina == "VODACOM"
                                            //                                   ? "assets/payicons/mpesa.png"
                                            //                                   : snapshot.data[index].jina == "TIGO PESA"
                                            //                                       ? "assets/payicons/tigopesa.png"
                                            //                                       : "assets/payicons/cash.png",
                                            //                               // color: MyColors.primaryLight,
                                            //                               height:
                                            //                                   50,
                                            //                             ),
                                            //                           ),
                                            //                         ),
                                            //                       ],
                                            //                     ),
                                            //                     manualSpacer(
                                            //                         step: 2),
                                            //                     Text(
                                            //                       ,
                                            //                       maxLines: 1,
                                            //                       overflow:
                                            //                           TextOverflow
                                            //                               .ellipsis,
                                            //                       softWrap:
                                            //                           false,
                                            //                       style: GoogleFonts
                                            //                           .montserrat(
                                            //                         fontSize:
                                            //                             12,
                                            //                         fontWeight:
                                            //                             FontWeight
                                            //                                 .normal,
                                            //                         color: MyColors
                                            //                             .primaryLight,
                                            //                       ),
                                            //                     ),
                                            //                   ],
                                            //                 ),
                                            //                 manualStepper(
                                            //                     step: 2),
                                            //                 Row(
                                            //                   children: [
                                            //                     manualSpacer(
                                            //                         step: 2),
                                            //                     Row(
                                            //                       mainAxisAlignment:
                                            //                           MainAxisAlignment
                                            //                               .spaceBetween,
                                            //                       children: [
                                            //                         Text(
                                            //                           "Akaunti : ${snapshot.data[index].namba}",
                                            //                           maxLines:
                                            //                               1,
                                            //                           overflow:
                                            //                               TextOverflow
                                            //                                   .ellipsis,
                                            //                           softWrap:
                                            //                               false,
                                            //                           style: GoogleFonts
                                            //                               .montserrat(
                                            //                             fontSize:
                                            //                                 12,
                                            //                             fontWeight:
                                            //                                 FontWeight.bold,
                                            //                             color: MyColors
                                            //                                 .primaryLight,
                                            //                           ),
                                            //                         ),
                                            //                       ],
                                            //                     ),
                                            //                     manualSpacer(
                                            //                         step: 3),
                                            //                     GestureDetector(
                                            //                       onTap: () {
                                            //                         Clipboard
                                            //                             .setData(
                                            //                           new ClipboardData(
                                            //                             text:
                                            //                                 "${snapshot.data[index].namba}",
                                            //                           ),
                                            //                         ).then((_) {
                                            //                           Scaffold.of(
                                            //                                   context)
                                            //                               .showSnackBar(
                                            //                                   SnackBar(content: Text("Nambari ya akaunti imenakiliwa")));
                                            //                         });
                                            //                       },
                                            //                       child: Icon(
                                            //                         Icons.copy,
                                            //                       ),
                                            //                     )
                                            //                   ],
                                            //                 ),

                                            //                 // Icon(
                                            //               ],
                                            //             ),
                                            //           ),
                                            //         ],
                                            //       ),
                                            //     )
                                            //   ]),
                                            // )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Text("new videos");
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
