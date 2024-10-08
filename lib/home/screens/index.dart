import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:miyuji/akaunti/screens/_old_index.dart';
import 'package:miyuji/baraza/screens/index.dart';
import 'package:miyuji/chatroom/screen/chat_screen.dart';
import 'package:miyuji/jumuiyazetu/screens/index.dart';
import 'package:miyuji/kwayazetu/screens/index.dart';
import 'package:miyuji/livestream/screens/index.dart';
import 'package:miyuji/mahubiri/screens/index.dart';
import 'package:miyuji/matangazo/screens/index.dart';
import 'package:miyuji/matoleo/index.dart';
import 'package:miyuji/models/neno_lasiku.dart';
import 'package:miyuji/neno/screens/index.dart';
import 'package:miyuji/ratiba/screens/index.dart';
import 'package:miyuji/register_login/screens/login.dart';
import 'package:miyuji/shared/localstorage/index.dart';
import 'package:miyuji/uongozi/screens/index.dart';
import 'package:miyuji/usajili/screens/index.dart';
import 'package:miyuji/utils/Alerts.dart';
import 'package:miyuji/utils/TextStyles.dart';
import 'package:miyuji/utils/dimension.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:miyuji/utils/spacer.dart';
import 'package:lottie/lottie.dart';
import 'package:miyuji/utils/no_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../akaunti/screens/index.dart';

var host;
var data;
var mtumishi;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  // final List _children = [];

  String messageTitle = "Empty";
  String notificationAlert = "alert";

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    checkLogin();
    getdataLocal();
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (message) async {
        setState(() {
          messageTitle = message["notification"]["title"];
          notificationAlert = "New Notification Alert";
        });
      },
      onResume: (message) async {
        setState(() {
          messageTitle = message["data"]["title"];
          notificationAlert = "Application opened from Notification";
        });
      },
    );
  }

  Future<List<NenoLaSikuData>> getRatiba() async {
    String myApi = "http://miyujikkkt.or.tz/api/get_nenolasiku.php";
    final response = await http.post(myApi, headers: {'Accept': 'application/json'});

    var barazaList = <NenoLaSikuData>[];
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
        NenoLaSikuData video = NenoLaSikuData.fromJson(element);
        barazaList.add(video);
      },
    );
    return barazaList;
  }

  void checkLogin() async {
    LocalStorage.getStringItem('member_no').then((value) {
      if (value.isNotEmpty && value != null) {
        var mydata = jsonDecode(value);
        setState(() {
          host = mydata;
        });
      }
    });
  }

  void getdataLocal() async {
    LocalStorage.getStringItem('mydata').then((value) {
      if (value.isNotEmpty && value != null) {
        var mydata = jsonDecode(value);
        setState(() {
          data = mydata;
        });
      }
    });

    LocalStorage.getStringItem('mtumishi').then((value) {
      if (value.isNotEmpty && value != null) {
        var mymtumishi = jsonDecode(value);
        setState(() {
          mtumishi = mymtumishi;
        });
      }
    });
  }

  final menuList = <Map<String, dynamic>>[
    // {
    //   'name': 'BARAZA LA WAZEE',
    //   'image': 'assets/images/connect.png',
    //   'selected': true,
    //   'pushTo': 'BARAZA WAZEE',
    // },
    {
      'name': 'MAZUNGUMZO',
      'image': 'assets/images/testimonials.png',
      'selected': false,
      'pushTo': 'MAZUNGUMZO',
    },
    {
      'name': 'MATANGAZO',
      'image': 'assets/images/announcement.png',
      'selected': false,
      'pushTo': 'MATANGAZO',
    },
    {
      'name': 'KWAYA ZETU',
      'image': 'assets/images/connect.png',
      'selected': false,
      'pushTo': 'KWAYA ZETU',
    },
    {
      'name': 'JISAJILI MSHARIKA',
      'image': 'assets/images/program.png',
      'selected': false,
      'pushTo': 'JISAJILI MSHARIKA',
    },
    {
      'name': 'JUMUIYA ZETU',
      'image': 'assets/images/connect.png',
      'selected': false,
      'pushTo': 'JUMUIYA ZETU',
    },
    {
      'name': 'MUBASHARA',
      'image': 'assets/images/youtube.png',
      'selected': false,
      'pushTo': 'MUBASHARA',
    }
  ];

  Widget buildMenu(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: menuList?.length,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext cxt, int index) {
        // if ((mtumishi == null) &&
        //     (menuList[index]['name'] == "BARAZA LA WAZEE")) {
        //   return Card(
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(15.0),
        //       side: BorderSide(color: MyColors.white, width: 2.0),
        //     ),
        //     elevation: 2,
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: <Widget>[
        //         IconButton(
        //           iconSize: 45,
        //           icon: Lottie.asset(
        //             'assets/animation/access_denided.json',
        //           ),
        //           onPressed: () {
        //             Alerts.showCupertinoAlert(
        //               context,
        //               "BARAZA LA WAZEE(Guest)",
        //               "Hauna Vigezo vya kuingia kwenye huduma hii tafadhari endelea na huduma zilizopo, ahsante",
        //             );
        //           },
        //         ),
        //         Center(
        //           child: Text(
        //             "BARAZA LA WAZEE(Guest)",
        //             style: GoogleFonts.montserrat(
        //               fontSize: 8,
        //               fontWeight: FontWeight.bold,
        //               color: MyColors.primaryLight,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   );
        // }

        if ((host == null) && (menuList[index]['name'] == "MAZUNGUMZO")) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: MyColors.white, width: 2.0),
            ),
            elevation: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  iconSize: 45,
                  icon: Lottie.asset(
                    'assets/animation/access_denided.json',
                  ),
                  onPressed: () {
                    Alerts.showCupertinoAlert(
                      context,
                      "MAZUNGUMZO(Guest)",
                      "Tafadahari Ingia kwenye akaunti yako ilikuweza kupata huduma hii na mtu ambaye hauna akaunti ya msharika tafadhari jisajili, Ahsante.",
                    );
                  },
                ),
                Center(
                  child: Text(
                    "MAZUNGUMZO(Guest)",
                    style: GoogleFonts.montserrat(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: MyColors.primaryLight,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if ((host == null) && (menuList[index]['name'] == "MATANGAZO")) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: MyColors.white, width: 2.0),
            ),
            elevation: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  iconSize: 45,
                  icon: Lottie.asset(
                    'assets/animation/access_denided.json',
                  ),
                  onPressed: () {
                    Alerts.showCupertinoAlert(
                      context,
                      "MATANGAZO(Guest)",
                      "Tafadahari Ingia kwenye akaunti yako ilikuweza kupata huduma hii na mtu ambaye hauna akaunti ya msharika tafadhari jisajili, Ahsante.",
                    );
                  },
                ),
                Center(
                  child: Text(
                    "MATANGAZO(Guest)",
                    style: GoogleFonts.montserrat(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: MyColors.primaryLight,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return InkWell(
          splashColor: Colors.grey[350],
          onTap: () {
            //check naviagtio
            if (menuList[index]['pushTo'] == "BARAZA WAZEE") {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => BarazaLaWazee()));
            } else if (menuList[index]['pushTo'] == "MUBASHARA") {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => LiveYoutubePlayer()));
            } else if (menuList[index]['pushTo'] == "MATANGAZO") {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MatangazoScreen()));
            } else if (menuList[index]['pushTo'] == "JISAJILI MSHARIKA") {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegistrationScreen()));
            } else if (menuList[index]['pushTo'] == "KWAYA ZETU") {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => KwayaZetu()));
            } else if (menuList[index]['pushTo'] == "MAZUNGUMZO") {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen()));
            } else if (menuList[index]['pushTo'] == "JUMUIYA ZETU") {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen()));
            }
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: MyColors.white, width: 2.0),
            ),
            elevation: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    //check naviagtio
                    if (menuList[index]['pushTo'] == "BARAZA WAZEE") {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => BarazaLaWazee()));
                    } else if (menuList[index]['pushTo'] == "MUBASHARA") {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LiveYoutubePlayer()));
                    } else if (menuList[index]['pushTo'] == "MATANGAZO") {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MatangazoScreen()));
                    } else if (menuList[index]['pushTo'] == "JISAJILI MSHARIKA") {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => RegistrationScreen()),
                      );
                    } else if (menuList[index]['pushTo'] == "KWAYA ZETU") {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => KwayaZetu()));
                    } else if (menuList[index]['pushTo'] == "MAZUNGUMZO") {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen()));
                    } else if (menuList[index]['pushTo'] == "JUMUIYA ZETU") {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => JumuiyaZetu()));
                    }
                  },
                  iconSize: (menuList[index]['pushTo'] == "MUBASHARA") ? 60 : 20,
                  icon: Image.asset(
                    menuList[index]['image'],
                    color: MyColors.primaryLight,
                  ),
                ),
                Center(
                  child: Text(
                    menuList[index]['name'],
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: MyColors.primaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final money = new NumberFormat("#,###.#", "en_US");

    final List _children = [
      LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: deviceHeight(context) / 20),
                    child: Container(
                      // decoration: BoxDecoration(color: MyColors.primaryLight),
                      height: 30,
                      child: Center(
                        child: Text(
                          "KKKT miyuji",
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: MyColors.primaryLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Container(
                    decoration: BoxDecoration(
                      color: MyColors.white,
                    ),
                    width: double.infinity,
                    height: 200,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(color: MyColors.white, width: 1.0),
                      ),
                      color: MyColors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 25.0,
                                        backgroundImage: NetworkImage("https://user-images.githubusercontent.com/30195/34457818-8f7d8c76-ed82-11e7-8474-3825118a776d.png"),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      manualSpacer(step: 5),
                                      ((host != null))
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Karibu,",
                                                  style: TextStyles.headline(context).copyWith(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: MyColors.primaryLight,
                                                  ),
                                                ),
                                                Text(
                                                  host != null ? "${host['fname']}" : "N/A",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                manualStepper(step: 10),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "No. Ahadi : ",
                                                      style: TextStyles.headline(context).copyWith(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                        color: MyColors.primaryLight,
                                                      ),
                                                    ),
                                                    Text(
                                                      (data == null || data['namba_ya_ahadi'] == null)
                                                          ? host != null
                                                              ? host['member_no']
                                                              : "N/A"
                                                          : "${data['namba_ya_ahadi']}",
                                                      style: GoogleFonts.montserrat(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Text(
                                                  "Guest User",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                manualSpacer(step: 5),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
                                                  },
                                                  child: Text(
                                                    'Ingia Akaunti',
                                                    style: GoogleFonts.montserrat(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: MyColors.white,
                                                    ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    primary: MyColors.primaryLight,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12), // <-- Radius
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          manualStepper(step: 2),
                          (host != null)
                              ? Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      (data != null)
                                          ? Expanded(
                                              child: Row(
                                                children: [
                                                  manualSpacer(step: 20),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Jumuiya yako,",
                                                        style: TextStyles.headline(context).copyWith(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: MyColors.primaryLight,
                                                        ),
                                                      ),
                                                      manualStepper(step: 2),
                                                      Text(
                                                        (data == null || data['namba_ya_ahadi'] == null)
                                                            ? host != null
                                                                ? host['member_no']
                                                                : "N/A"
                                                            : "${data['jina_la_jumuiya']}",
                                                        style: GoogleFonts.montserrat(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  manualSpacer(step: 50),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Ahadi : ",
                                                            style: TextStyles.headline(context).copyWith(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color: MyColors.primaryLight,
                                                            ),
                                                          ),
                                                          //
                                                          Text(
                                                            (data == null || data['ahadi'] == null) ? "N/A" : "${money.format(int.parse(data['ahadi']))} Tsh",
                                                            style: GoogleFonts.montserrat(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      manualStepper(step: 2),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Jengo : ",
                                                            style: TextStyles.headline(context).copyWith(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color: MyColors.primaryLight,
                                                            ),
                                                          ),
                                                          Text(
                                                            (data == null || data['jengo'] == null) ? "N/A" : "${money.format(int.parse(data['jengo']))}  Tsh",
                                                            style: GoogleFonts.montserrat(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Taarifa zako za Ahadi zitaonekana hapa.",
                                                    style: GoogleFonts.montserrat(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Baada ya usajili.",
                                                    style: GoogleFonts.montserrat(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SingleChildScrollView(
                                        child: Text(
                                          "Karibu, kwenye mfumo wa KKKT miyuji mahala ambapo neno la Mungu linawafikia wengi mahala popote wakati wowote.",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          manualSpacer(step: 5),
                          ((host != null))
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MatoleoScreen()));
                                    },
                                    child: Text(
                                      'Matoleo yako',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: MyColors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: MyColors.primaryLight,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12), // <-- Radius
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                  manualStepper(step: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: MyColors.white,
                    ),
                    width: double.infinity,
                    height: 220,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: MyColors.white, width: 1.0),
                      ),
                      color: MyColors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              "Neno la siku",
                              style: GoogleFonts.montserrat(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Divider(),
                            FutureBuilder(
                              future: getRatiba(),
                              builder: (context, AsyncSnapshot<List<NenoLaSikuData>> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          child: Lottie.asset(
                                            'assets/animation/load_neno.json',
                                            height: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (snapshot.hasError || !snapshot.hasData) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(50.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 30,
                                            child: Lottie.asset('assets/animation/load_neno.json', height: 20),
                                          ),
                                          SizedBox(
                                            height: 2.0,
                                          ),
                                          Text(
                                            "Hakuna taarifa zilizopatiakana",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0, color: Colors.black38),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                } else if (snapshot.hasData) {
                                  return Container(
                                    height: 120,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (_, index) {
                                        return Text(
                                          "${snapshot.data[index].neno}",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return Text("new videos");
                                }
                              },
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => NenoLaSiku()));
                                },
                                child: Text(
                                  'Tazama yote',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.primaryLight,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  manualStepper(step: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: MyColors.white,
                    ),
                    width: double.infinity,
                    height: 150,
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: MyColors.white, width: 1.0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            Center(
                              child: Image.asset(
                                "assets/images/miyuji.jpg",
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF343434).withOpacity(0.4),
                                    Color(0xFF343434).withOpacity(0.15),
                                  ],
                                ),
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
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: MyColors.primaryLight,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Mahubiri ya tarehe 23-02-2021',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.montserrat(
                                              fontSize: deviceHeight(context) / 50,
                                              fontWeight: FontWeight.bold,
                                              color: MyColors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    manualStepper(step: deviceWidth(context) ~/ 50),
                                    Text(
                                      'Na Mch. Moses',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                        color: MyColors.white,
                                      ),
                                    ),
                                    manualStepper(step: deviceWidth(context) ~/ 50),
                                    Align(
                                      alignment: Alignment.center,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MahubiriScreen()));
                                        },
                                        child: Text(
                                          'Tazama zote',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.white,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: MyColors.primaryLight,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12), // <-- Radius
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  manualStepper(step: 2),
                  Container(
                    width: double.infinity,
                    height: jtdeviceHeight(context) * .44,
                    color: Colors.white,
                    padding: EdgeInsets.all(2.0),
                    child: buildMenu(context),
                  )
                ],
              ),
            ),
          ),
        );
      }),
      (host == null) ? NoAuthBanner() : ViongoziWaKanisa(),
      (host == null) ? NoAuthBanner() : RatibaZaIbada(),
      (host == null) ? NoAuthBanner() : ProfilePage()
    ];
    void _onItemTapped(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          // backgroundColor: MyColors.primaryLight,
          selectedItemColor: MyColors.primaryDark,
          unselectedItemColor: MyColors.primaryLight,
          // type: BottomNavigationBarType.shifting,
          // currentIndex: _selectedIndex,
          // selectedItemColor: Colors.black,
          // iconSize: 40,
          onTap: _onItemTapped,
          // elevation: 2,
          items: [
            new BottomNavigationBarItem(
              icon: _currentIndex == 0
                  ? CircleAvatar(
                      backgroundColor: MyColors.primaryLight,
                      child: Icon(
                        Icons.home,
                        color: MyColors.white,
                      ),
                    )
                  : Icon(Icons.home),
              label: "Nyumbani",
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 1
                  ? CircleAvatar(
                      backgroundColor: MyColors.primaryLight,
                      child: Icon(
                        Icons.people,
                        color: MyColors.white,
                      ),
                    )
                  : Icon(Icons.people),
              label: 'Uongozi',
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 2
                  ? CircleAvatar(
                      backgroundColor: MyColors.primaryLight,
                      child: Icon(
                        Icons.extension,
                        color: MyColors.white,
                      ),
                    )
                  : Icon(
                      Icons.extension,
                    ),
              label: 'Mengineyo',
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 3
                  ? CircleAvatar(
                      backgroundColor: MyColors.primaryLight,
                      child: Icon(
                        Icons.person_outline_outlined,
                        color: MyColors.white,
                      ),
                    )
                  : Icon(
                      Icons.person_outline_outlined,
                    ),
              label: 'Akaunti',
            ),
          ],
        ),
      ),
    );
  }
}
