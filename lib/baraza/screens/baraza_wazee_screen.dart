import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miyuji/models/barazalawazee.dart';
import 'package:miyuji/utils/TextStyles.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:http/http.dart' as http;

import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class BarazaWazeeScreen extends StatefulWidget {
  const BarazaWazeeScreen({Key? key}) : super(key: key);

  @override
  _BarazaWazeeScreenState createState() => _BarazaWazeeScreenState();
}

class _BarazaWazeeScreenState extends State<BarazaWazeeScreen> {
  Future<List<BarazaLaWazeeData>> getBarazaWaZee() async {
    String myApi = "http://miyujikkkt.or.tz/api/get_barazawazee.php";
    final response = await http.post(myApi, headers: {'Accept': 'application/json'});

    var barazaList = <BarazaLaWazeeData>[];
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
        BarazaLaWazeeData video = BarazaLaWazeeData.fromJson(element);
        barazaList.add(video);
      },
    );
    return barazaList;
  }

  Future<void> _pullRefresh() async {
    getBarazaWaZee().then((value) {
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
          "Baraza la Wazee",
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
          stream: getBarazaWaZee().asStream(),
          builder: (context, AsyncSnapshot<List<BarazaLaWazeeData>> snapshot) {
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
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      title: Text(
                        snapshot.data![index].fname,
                        style: TextStyles.caption(context).copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MyColors.darkText,
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data![index].nambaYaSimu,
                        style: TextStyles.caption(context).copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: MyColors.darkText,
                        ),
                      ),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: MyColors.white,
                        child: Image.asset(
                          "assets/images/profile.png",
                        ),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          launch("tel://${snapshot.data![index].nambaYaSimu}");
                        },
                        child: CircleAvatar(
                          backgroundColor: MyColors.primaryLight,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.call,
                              size: 20,
                              color: MyColors.white,
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
      ),
    );
  }
}
