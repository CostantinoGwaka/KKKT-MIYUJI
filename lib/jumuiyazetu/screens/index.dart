// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kanisaapp/jumuiyazetu/screens/viongozi_wajumuiya_screen.dart';
import 'package:kanisaapp/models/Jumuiya.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/TextStyles.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/spacer.dart';

import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class JumuiyaZetu extends StatefulWidget {
  const JumuiyaZetu({super.key});

  @override
  _JumuiyaZetuState createState() => _JumuiyaZetuState();
}

class _JumuiyaZetuState extends State<JumuiyaZetu> {
  Future<List<JumuiyaData>> getJumuiya() async {
    String myApi = "${ApiUrl.BASEURL}getjumuiya.php";
    final response = await http.post(Uri.parse(myApi), headers: {'Accept': 'application/json'});

    var barazaList = <JumuiyaData>[];

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
        JumuiyaData video = JumuiyaData.fromJson(element);
        barazaList.add(video);
      },
    );
    return barazaList;
  }

  Future<void> _pullRefresh() async {
    getJumuiya().then((value) {
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
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitDown,
                DeviceOrientation.portraitUp,
              ]);
              Navigator.pop(context);
            },
          ),
          middle: Text(
            "Jumuiya Zetu",
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
            stream: getJumuiya().asStream(),
            builder: (context, AsyncSnapshot<List<JumuiyaData>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: Padding(
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
                            const Text(
                              "Hakuna taarifa zi",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0, color: Colors.black38),
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
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) {
                    return Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ViongoziJumuiya(
                                jumuiya: snapshot.data![index],
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: MyColors.white,
                            ),
                            width: double.infinity,
                            height: 80,
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: MyColors.primaryLight, width: 2.0),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 10,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  children: [
                                    // Center(
                                    //   child: Image.asset(
                                    //     "assets/images/kwaya_logo.png",
                                    //     fit: BoxFit.cover,
                                    //     width: double.infinity,
                                    //   ),
                                    // ),
                                    Container(
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: MyColors.white,
                                        // gradient: LinearGradient(
                                        //   colors: [
                                        //     Color(0xFF343434).withOpacity(0.4),
                                        //     Color(0xFF343434).withOpacity(0.15),
                                        //   ],
                                        // ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: deviceWidth(context) / 50,
                                        vertical: deviceWidth(context) / 30,
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              snapshot.data![index].jumuiyaName!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: MyColors.primaryLight,
                                                fontSize: deviceHeight(context) / 30,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            manualStepper(step: deviceWidth(context) ~/ 50),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
        ));
  }
}
