import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miyuji/home/screens/index.dart';
import 'package:miyuji/utils/TextStyles.dart';
import 'package:miyuji/utils/Utility.dart';
import 'package:miyuji/utils/dimension.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:lottie/lottie.dart';

class MatoleoScreen extends StatefulWidget {
  const MatoleoScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<MatoleoScreen> {
  Future<dynamic> getSadakaZako() async {
    String myApi = "http://miyujikkkt.or.tz/api/get_sadaka.php";
    final response = await http.post(
      Uri.parse(myApi),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        "member_no": host['member_no'],
      },
    );

    var baraza;
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        baraza = json;
      }
    } else {}

    return baraza;
  }

  Future<dynamic> getJumlaAhadi() async {
    print("dataz");
    String myApi = "http://miyujikkkt.or.tz/api/get_jumla_ahadi_sadaka.php";
    final response = await http.post(
      Uri.parse(myApi),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        "member_no": host['member_no'],
      },
    );

    var baraza;
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        baraza = json;
      }
    }

    return baraza;
  }

  Future<dynamic> getJumlaJengo() async {
    print("dataz");
    String myApi = "http://miyujikkkt.or.tz/api/get_jumla_jengo_sadaka.php";
    final response = await http.post(
      Uri.parse(myApi),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        "member_no": host['member_no'],
      },
    );

    var baraza;
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        baraza = json;
      }
    }

    return baraza;
  }

  @override
  void initState() {
    getSadakaZako();
    getJumlaAhadi();
    getJumlaJengo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat("#,###.#", "en_US");

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          middle: Text(
            "Matoleo Yako",
            style: TextStyles.headline(context).copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyColors.primaryLight,
            ),
          ),
        ),
        child: Scaffold(
          // backgroundColor: const Color(0xffE5E5E5),
          // appBar: AppBar(
          //   foregroundColor: Colors.black,
          //   elevation: 0,
          //   backgroundColor: Colors.transparent,
          //   centerTitle: true,
          //   title: Text(
          //     "",
          //     style: TextStyle(
          //       fontSize: 16,
          //       color: MyColors.primaryLight,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: jtdeviceHeight(context) / 8),
              child: Column(
                children: [
                  SizedBox(
                    height: jtdeviceHeight(context) / 5,
                    width: jtdeviceWidth(context),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ahadi",
                                  style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                                        fontSize: 15,
                                        color: MyColors.primaryLight,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                jtmanualStepper(),
                                Text(
                                  "Tsh ${currency.format(int.parse(data['ahadi']))}",
                                  style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                                        fontSize: 17,
                                        color: MyColors.primaryLight,
                                      ),
                                ),
                                jtmanualStepper(step: jtdeviceHeight(context) ~/ 30),
                                Text(
                                  "Jengo",
                                  style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                                        fontSize: 15,
                                        color: MyColors.primaryLight,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                jtmanualStepper(),
                                Text(
                                  "Tsh ${currency.format(int.parse(data['jengo']))}",
                                  style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                                        fontSize: 17,
                                        color: MyColors.primaryLight,
                                      ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "",
                                  style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                                        fontSize: 15,
                                        color: MyColors.primaryLight,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                jtmanualStepper(),
                                FutureBuilder(
                                  //Error number 2
                                  future: getJumlaAhadi(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text("...");
                                    } else if (snapshot.hasData) {
                                      return Text(
                                        "Tsh ${currency.format(snapshot.data)}/=",
                                        style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                                              fontSize: 17,
                                              color: MyColors.primaryLight,
                                            ),
                                      );
                                    } else {
                                      return Text("hakuna");
                                    }
                                  },
                                ),
                                jtmanualStepper(step: jtdeviceHeight(context) ~/ 30),
                                Text(
                                  "",
                                  style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                                        fontSize: 15,
                                        color: MyColors.primaryLight,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                jtmanualStepper(),
                                FutureBuilder(
                                  //Error number 2
                                  future: getJumlaJengo(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text("...");
                                    } else if (snapshot.hasData) {
                                      return Text(
                                        "Tsh ${currency.format(snapshot.data)}/=",
                                        style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                                              fontSize: 17,
                                              color: MyColors.primaryLight,
                                            ),
                                      );
                                    } else {
                                      return Text("hakuna");
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  jtmanualStepper(step: jtdeviceHeight(context) ~/ 40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Matoleo",
                      style: Theme.of(context).textTheme.headline1.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: MyColors.primaryLight,
                          ),
                    ),
                  ),
                  jtmanualStepper(),
                  Container(
                    height: 500,
                    child: Column(
                      children: [
                        Expanded(
                          child: FutureBuilder(
                              //Error number 2
                              future: getSadakaZako(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 50.0),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(90.0),
                                        child: Column(
                                          children: [
                                            Lottie.asset(
                                              'assets/animation/fetching.json',
                                            ),
                                            SizedBox(
                                              height: 5,
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
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              Lottie.asset('assets/animation/nodata.json'),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Material(
                                                child: Text(
                                                  "Hakuna taarifa zilizopatikana",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.0,
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
                                      physics: BouncingScrollPhysics(),
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (_, index) {
                                        return GestureDetector(
                                          onTap: () {},
                                          child: SizedBox(
                                            height: jtdeviceHeight(context) / 7,
                                            width: jtdeviceWidth(context),
                                            child: Card(
                                                elevation: 0,
                                                color: Theme.of(context).cardColor,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Ahadi",
                                                            style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "TZS ",
                                                                  style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 10),
                                                                ),
                                                                Text(
                                                                  currency.format(int.parse(snapshot.data[index]['ahadi'])),
                                                                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                                                                        fontSize: 17,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Jengo",
                                                            style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "TZS ",
                                                                  style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 10),
                                                                ),
                                                                Text(
                                                                  currency.format(int.parse(snapshot.data[index]['jengo'])),
                                                                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                                                                        fontSize: 17,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      jtmanualStepper(step: 8),
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 8.0),
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              "",
                                                              style: Theme.of(context).textTheme.subtitle1.copyWith(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                            ),
                                                            Text(
                                                              "2022-03-13",
                                                              style: Theme.of(context).textTheme.subtitle1.copyWith(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        );
                                      });
                                } else {
                                  return Text("no data");
                                }
                              }),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
