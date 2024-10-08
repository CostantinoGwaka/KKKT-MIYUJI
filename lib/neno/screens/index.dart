import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kinyerezi/models/manenosiku.dart';
import 'package:kinyerezi/utils/TextStyles.dart';
import 'package:kinyerezi/utils/my_colors.dart';
import 'package:kinyerezi/utils/spacer.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class NenoLaSiku extends StatefulWidget {
  const NenoLaSiku({Key key}) : super(key: key);

  @override
  _NenoLaSikuState createState() => _NenoLaSikuState();
}

class _NenoLaSikuState extends State<NenoLaSiku> {
  Future<List<Manenosiku>> getManeno() async {
    String myApi = "http://kinyerezikkkt.or.tz/api/get_maneno.php";
    final response = await http.post(myApi, headers: {'Accept': 'application/json'});

    var barazaList = <Manenosiku>[];
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
        Manenosiku video = Manenosiku.fromJson(element);
        barazaList.add(video);
      },
    );
    return barazaList;
  }

  Future<void> _pullRefresh() async {
    getManeno().then((value) {
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
          child: Icon(Icons.arrow_back_ios),
          onTap: () {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitDown,
              DeviceOrientation.portraitUp,
            ]);
            Navigator.pop(context);
          },
        ),
        middle: Text(
          "Maneno ya siku",
          style: TextStyles.headline(context).copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MyColors.primaryLight,
          ),
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: FutureBuilder(
          future: getManeno(),
          builder: (context, AsyncSnapshot<List<Manenosiku>> snapshot) {
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
                        SizedBox(
                          height: 20,
                        ),
                        Material(
                          child: Text(
                            "inapanga taarifa",
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
                itemBuilder: (cintext, index) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: MyColors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${snapshot.data[index].neno}",
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              wordSpacing: 1.5,
                            ),
                          ),
                          manualStepper(step: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: MyColors.primaryLight,
                                    size: 15,
                                  ),
                                  manualSpacer(step: 5),
                                  Text(
                                    "${snapshot.data[index].tarehe}",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      wordSpacing: 1.5,
                                      color: MyColors.primaryLight,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: MyColors.primaryLight,
                                    size: 15,
                                  ),
                                  manualSpacer(step: 5),
                                  Text(
                                    "@mchungaji",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      wordSpacing: 1.5,
                                      color: MyColors.primaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
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
    );
  }
}
