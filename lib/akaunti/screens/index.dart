import 'dart:convert';
import 'dart:io';
import 'package:kinyerezi/akaunti/screens/change_password.dart';
import 'package:kinyerezi/akaunti/screens/constant.dart';
import 'package:kinyerezi/akaunti/screens/mapendekezo_screen.dart';
import 'package:kinyerezi/akaunti/screens/profile_list.dart';
import 'package:kinyerezi/matoleo/index.dart';
import 'package:kinyerezi/register_login/screens/login.dart';
import 'package:kinyerezi/utils/TextStyles.dart';
import 'package:kinyerezi/utils/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kinyerezi/home/screens/index.dart';
import 'package:kinyerezi/shared/localstorage/index.dart';
import 'package:kinyerezi/utils/Alerts.dart';
import 'package:kinyerezi/utils/my_colors.dart';
import 'package:kinyerezi/utils/spacer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = false;
  final FocusNode myFocusNode = FocusNode();
  bool _isObscureOld = true;
  bool _isObscureNew = true;
  TextEditingController oldp = TextEditingController();
  TextEditingController newp = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
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

    LocalStorage.getStringItem('mydata').then((value) {
      if (value.isNotEmpty && value != null) {
        var mydata = jsonDecode(value);
        setState(() {
          data = mydata;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAppPrimaryColor,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // AppBarButton(
                      //   icon: Icons.arrow_back,
                      // ),
                      // SvgPicture.asset("assets/icons/menu.svg"),
                    ],
                  ),
                ),
                AvatarImage(),
                SizedBox(
                  height: 10,
                ),
                // SizedBox(height: 10),
                // Text(
                //   '${host['fname']}',
                //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                // ),
                // Text(
                //   'Member ID : ${host['member_no']} | Mtaa : ${(data == null || data['namba_ya_ahadi'] == null) ? host != null ? host['member_no'] : "N/A" : "${data['jina_la_jumuiya']}"}',
                //   style: TextStyle(fontWeight: FontWeight.w300),
                // ),
                // SizedBox(height: 10),
                ProfileListItems(),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Future<void> updatePassword(
      String member_no, String oldpassword, String newpassword) async {
    //get my data
    Alerts.showProgressDialog(
        context, "Tafadhari Subiri,neno lako linabadilishwa");
    setState(() {
      _status = true;
    });

    String mydataApi = "http://kinyerezikkkt.or.tz/api/change_password.php";

    final response = await http.post(
      mydataApi,
      headers: {
        'Accept': 'application/json',
      },
      body: {
        "member_no": "$member_no",
        "oldpassword": "$oldpassword",
        "newpassword": "$newpassword",
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _status = false;
      });
      //remove loader
      Navigator.of(context).pop();
      //end here
      dynamic jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404 && jsonResponse != 500) {
        var json = jsonDecode(response.body);

        String mydata = jsonEncode(json[0]);

        await LocalStorage.setStringItem("mydata", mydata);

        setState(() {
          oldp.clear();
          newp.clear();
        });

        return Fluttertoast.showToast(
          msg: "Neno la siri limebadilishwa",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: MyColors.primaryLight,
          textColor: Colors.white,
        );
      } else {
        setState(() {
          _status = false;
        });

        Fluttertoast.showToast(
          msg: "Neno lako la siri la zamani limekosewa",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: MyColors.primaryLight,
          textColor: Colors.white,
        );
      }
    } else {
      setState(() {
        _status = false;
      });

      Fluttertoast.showToast(
        msg: "Neno lako la siri la zamani limekosewa",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: MyColors.primaryLight,
        textColor: Colors.white,
      );
    }

    //end here
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16.0,
                    ),
                    manualSpacer(step: 5),
                    new Text("Badili"),
                  ],
                ),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  // setState(() {
                  //   _status = true;
                  //   FocusScope.of(context).requestFocus(new FocusNode());
                  // });
                  if (oldp.text.isNotEmpty && newp.text.isNotEmpty) {
                    updatePassword(host['member_no'], oldp.text, newp.text);
                  } else {
                    return Fluttertoast.showToast(
                      msg: "Weka neno lako la siri jipya na lazamani",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: MyColors.primaryLight,
                      textColor: Colors.white,
                    );
                  }
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                      size: 16.0,
                    ),
                    manualSpacer(step: 5),
                    new Text("Toka"),
                  ],
                ),
                textColor: Colors.white,
                color: MyColors.primaryDark,
                onPressed: () async {
                  Alerts.showProgressDialog(
                      context, "Inatoka kwenye akaunt yako");

                  await LocalStorage.removeItem("member_no")
                      .whenComplete(() async {
                    await LocalStorage.removeItem("mydata")
                        .whenComplete(() async {
                      await LocalStorage.removeItem("mtumishi")
                          .whenComplete(() {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomePage()));
                        SystemNavigator.pop();
                        return Fluttertoast.showToast(
                          msg: "Umefanikiwa kutoka kwenye akaunt yako",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: MyColors.primaryLight,
                          textColor: Colors.white,
                        );
                      });
                    });
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}

class AvatarImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final money = new NumberFormat("#,###.#", "en_US");

    return Container(
      decoration: BoxDecoration(
        color: MyColors.background,
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
                          backgroundImage: NetworkImage(
                              "https://user-images.githubusercontent.com/30195/34457818-8f7d8c76-ed82-11e7-8474-3825118a776d.png"),
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
                                    style:
                                        TextStyles.headline(context).copyWith(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "No. Ahadi : ",
                                        style: TextStyles.headline(context)
                                            .copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: MyColors.primaryLight,
                                        ),
                                      ),
                                      Text(
                                        (data == null ||
                                                data['namba_ya_ahadi'] == null)
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => Login()));
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
                                        borderRadius: BorderRadius.circular(
                                            12), // <-- Radius
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Mtaa wako,",
                                          style: TextStyles.headline(context)
                                              .copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.primaryLight,
                                          ),
                                        ),
                                        manualStepper(step: 2),
                                        Text(
                                          (data == null ||
                                                  data['namba_ya_ahadi'] ==
                                                      null)
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Ahadi : ",
                                              style:
                                                  TextStyles.headline(context)
                                                      .copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: MyColors.primaryLight,
                                              ),
                                            ),
                                            //
                                            Text(
                                              (data == null ||
                                                      data['ahadi'] == null)
                                                  ? "N/A"
                                                  : "${money.format(int.parse(data['ahadi']))} Tsh",
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
                                              style:
                                                  TextStyles.headline(context)
                                                      .copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: MyColors.primaryLight,
                                              ),
                                            ),
                                            Text(
                                              (data == null ||
                                                      data['jengo'] == null)
                                                  ? "N/A"
                                                  : "${money.format(int.parse(data['jengo']))}  Tsh",
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
                            "Karibu, kwenye mfumo wa KKKT KINYEREZI mahala ambapo neno la Mungu linawafikia wengi mahala popote wakati wowote.",
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
            // ((host != null))
            //     ? Padding(
            //         padding: const EdgeInsets.only(left: 10.0),
            //         child: ElevatedButton(
            //           onPressed: () {
            //             Navigator.of(context).push(MaterialPageRoute(
            //                 builder: (context) => MatoleoScreen()));
            //           },
            //           child: Text(
            //             'Matoleo yako',
            //             style: GoogleFonts.montserrat(
            //               fontSize: 12,
            //               fontWeight: FontWeight.bold,
            //               color: MyColors.white,
            //             ),
            //           ),
            //           style: ElevatedButton.styleFrom(
            //             primary: MyColors.primaryLight,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(12), // <-- Radius
            //             ),
            //           ),
            //         ),
            //       )
            //     : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  final Color color;
  final IconData iconData;
  final Function onPressed;

  SocialIcon({this.color, this.iconData, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Container(
        width: 45.0,
        height: 45.0,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: RawMaterialButton(
          shape: CircleBorder(),
          onPressed: onPressed,
          child: Icon(iconData, color: Colors.white),
        ),
      ),
    );
  }
}

class ProfileListItems extends StatelessWidget {
  _launchURL() async {
    String url = Platform.isIOS ? 'tel://0659515042' : 'tel:0659515042';
    if (await canLaunch(url)) {
      await launch("tel://0659515042");
    } else {
      Fluttertoast.showToast(
        msg: "Piga : +255 659 515 042",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: MyColors.primaryLight,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          InkWell(
            onTap: () {
              _launchURL();
            },
            child: ProfileListItem(
              icon: LineAwesomeIcons.question_circle,
              text: 'Msaada/Maelezo',
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChangePasswordScreen()));
            },
            child: ProfileListItem(
              icon: LineAwesomeIcons.cog,
              text: 'Badili Neno La Siri',
            ),
          ),
          InkWell(
            onTap: () {
              String result =
                  "https://play.google.com/store/apps/details?id=app.kinyerezi";
              if (result != null) {
                Share.share(
                    "Pakua Application yetu mpya ya KKKT KINYEREZI uweze kujipatia Neno la Mungu na Huduma Mbali Mbali za Kiroho Mahala Popote Wakati Wowote. \n\n\nPakua kupitia Kiunganishi : $result");
              }
            },
            child: ProfileListItem(
              icon: LineAwesomeIcons.user_plus,
              text: 'Shirikisha Rafiki',
            ),
          ),
          InkWell(
            onTap: () async {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MapendekezoScreen()));
            },
            child: ProfileListItem(
              icon: LineAwesomeIcons.question,
              text: 'Maoni/Mapendekezo',
            ),
          ),
          jtmanualStepper(step: 10),
          InkWell(
            onTap: () async {
              Alerts.showProgressDialog(context, "Inatoka kwenye akaunt yako");

              await LocalStorage.removeItem("member_no").whenComplete(() async {
                await LocalStorage.removeItem("mydata").whenComplete(() async {
                  await LocalStorage.removeItem("mtumishi").whenComplete(() {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()));
                    SystemNavigator.pop();
                    return Fluttertoast.showToast(
                      msg: "Umefanikiwa kutoka kwenye akaunt yako",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: MyColors.primaryLight,
                      textColor: Colors.white,
                    );
                  });
                });
              });
            },
            child: ProfileListItem(
              icon: LineAwesomeIcons.alternate_sign_out,
              text: 'Toka kwenye akaunti',
              hasNavigation: false,
            ),
          ),
          jtmanualStepper(step: 30),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Crafted By iSoftTz",
                  style: GoogleFonts.gochiHand(
                    textStyle: TextStyle(
                        color: Colors.black, letterSpacing: .5, fontSize: 14),
                  ),
                ),
                Text(
                  "© 2022",
                  style: GoogleFonts.gochiHand(
                    textStyle: TextStyle(
                        color: Colors.black, letterSpacing: .5, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppBarButton extends StatelessWidget {
  final IconData icon;

  const AppBarButton({this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kAppPrimaryColor,
          boxShadow: [
            BoxShadow(
              color: kLightBlack,
              offset: Offset(1, 1),
              blurRadius: 10,
            ),
            BoxShadow(
              color: kWhite,
              offset: Offset(-1, -1),
              blurRadius: 10,
            ),
          ]),
      child: Icon(
        icon,
        color: fCL,
      ),
    );
  }
}
