import 'dart:convert';
import 'dart:io';
import 'package:miyuji/akaunti/screens/change_password.dart';
import 'package:miyuji/akaunti/screens/constant.dart';
import 'package:miyuji/akaunti/screens/mapendekezo_screen.dart';
import 'package:miyuji/akaunti/screens/profile_list.dart';
import 'package:miyuji/register_login/screens/login.dart';
import 'package:miyuji/utils/ApiUrl.dart';
import 'package:miyuji/utils/TextStyles.dart';
import 'package:miyuji/utils/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:miyuji/home/screens/index.dart';
import 'package:miyuji/shared/localstorage/index.dart';
import 'package:miyuji/utils/Alerts.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:miyuji/utils/spacer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  bool _status = false;
  final FocusNode myFocusNode = FocusNode();
  final bool _isObscureOld = true;
  final bool _isObscureNew = true;
  TextEditingController oldp = TextEditingController();
  TextEditingController newp = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    LocalStorage.getStringItem('member_no').then((value) {
      if (value.isNotEmpty) {
        var mydata = jsonDecode(value);
        setState(() {
          host = mydata;
        });
      }
    });

    LocalStorage.getStringItem('mydata').then((value) {
      if (value.isNotEmpty) {
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
      body: const Stack(
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

  Future<Future<bool?>> updatePassword(
    String? memberNo,
    String? oldpassword,
    String? newpassword,
  ) async {
    //get my data
    Alerts.showProgressDialog(context, "Tafadhari Subiri,neno lako linabadilishwa");
    setState(() {
      _status = true;
    });

    try {
      String mydataApi = "${ApiUrl.BASEURL}change_password.php";

      final response = await http.post(
        Uri.parse(mydataApi),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          "member_no": memberNo,
          "oldpassword": oldpassword,
          "newpassword": newpassword,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _status = false;
        });
        //remove loader
        // ignore: use_build_context_synchronously
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

          return Fluttertoast.showToast(
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

        return Fluttertoast.showToast(
          msg: "Neno lako la siri la zamani limekosewa",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: MyColors.primaryLight,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      return Fluttertoast.showToast(
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
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: ElevatedButton(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16.0,
                    ),
                    manualSpacer(step: 5),
                    const Text("Badili"),
                  ],
                ),
                // textColor: Colors.white,
                // color: Colors.green,
                onPressed: () {
                  // setState(() {
                  //   _status = true;
                  //   FocusScope.of(context).requestFocus(new FocusNode());
                  // });
                  if (oldp.text.isNotEmpty && newp.text.isNotEmpty) {
                    updatePassword(host['member_no'], oldp.text, newp.text);
                  } else {
                    Fluttertoast.showToast(
                      msg: "Weka neno lako la siri jipya na lazamani",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: MyColors.primaryLight,
                      textColor: Colors.white,
                    );
                  }
                },
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ElevatedButton(
                // ignore: sort_child_properties_last
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                      size: 16.0,
                    ),
                    manualSpacer(step: 5),
                    const Text("Toka"),
                  ],
                ),
                // textColor: Colors.white,
                // color: MyColors.primaryDark,
                onPressed: () async {
                  Alerts.showProgressDialog(context, "Inatoka kwenye akaunt yako");

                  await LocalStorage.removeItem("member_no").whenComplete(() async {
                    await LocalStorage.removeItem("mydata").whenComplete(() async {
                      // ignore: void_checks
                      await LocalStorage.removeItem("mtumishi").whenComplete(() {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
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
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: const CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: Icon(
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
  const AvatarImage({super.key});

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat("#,###.#", "en_US");

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
          side: const BorderSide(color: MyColors.white, width: 1.0),
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
                        const CircleAvatar(
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
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(builder: (context) => const Login()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MyColors.primaryLight,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12), // <-- Radius
                                      ),
                                    ),
                                    child: Text(
                                      'Ingia Akaunti',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: MyColors.white,
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
                                          "Mtaa wako,",
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
                                              (data == null || data['ahadi'] == null)
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
                                              style: TextStyles.headline(context).copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: MyColors.primaryLight,
                                              ),
                                            ),
                                            Text(
                                              (data == null || data['jengo'] == null)
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
  final Color? color;
  final IconData? iconData;
  final VoidCallback onPressed;

  const SocialIcon({super.key, this.color, this.iconData, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Container(
        width: 45.0,
        height: 45.0,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: RawMaterialButton(
          shape: const CircleBorder(),
          onPressed: onPressed,
          child: Icon(iconData, color: Colors.white),
        ),
      ),
    );
  }
}

class ProfileListItems extends StatelessWidget {
  const ProfileListItems({super.key});

  _launchURL() async {
    String url = Platform.isIOS ? 'tel://0659515042' : 'tel:0659515042';
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
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
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          InkWell(
            onTap: () {
              _launchURL();
            },
            child: const ProfileListItem(
              icon: LineAwesomeIcons.question_circle,
              text: 'Msaada/Maelezo',
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChangePasswordScreen()));
            },
            // ignore: prefer_const_constructors
            child: ProfileListItem(
              icon: LineAwesomeIcons.sleigh_solid,
              text: 'Badili Neno La Siri',
            ),
          ),
          InkWell(
            onTap: () {
              String result = "https://play.google.com/store/apps/details?id=app.miyuji";
              Share.share(
                  "Pakua Application yetu mpya ya KKKT miyuji uweze kujipatia Neno la Mungu na Huduma Mbali Mbali za Kiroho Mahala Popote Wakati Wowote. \n\n\nPakua kupitia Kiunganishi : $result");
            },
            child: const ProfileListItem(
              icon: LineAwesomeIcons.user,
              text: 'Shirikisha Rafiki',
            ),
          ),
          InkWell(
            onTap: () async {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MapendekezoScreen()));
            },
            child: const ProfileListItem(
              icon: LineAwesomeIcons.question_circle,
              text: 'Maoni/Mapendekezo',
            ),
          ),
          jtmanualStepper(step: 10),
          InkWell(
            onTap: () async {
              Alerts.showProgressDialog(context, "Inatoka kwenye akaunt yako");

              await LocalStorage.removeItem("member_no").whenComplete(() async {
                await LocalStorage.removeItem("mydata").whenComplete(() async {
                  // ignore: void_checks
                  await LocalStorage.removeItem("mtumishi").whenComplete(() {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
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
            child: const ProfileListItem(
              icon: LineAwesomeIcons.sign_out_alt_solid,
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
                    textStyle: const TextStyle(
                      color: Colors.black,
                      letterSpacing: .5,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  "© 2022",
                  style: GoogleFonts.gochiHand(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      letterSpacing: .5,
                      fontSize: 14,
                    ),
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
  final IconData? icon;

  const AppBarButton({super.key, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(shape: BoxShape.circle, color: kAppPrimaryColor, boxShadow: [
        BoxShadow(
          color: kLightBlack,
          offset: const Offset(1, 1),
          blurRadius: 10,
        ),
        BoxShadow(
          color: kWhite,
          offset: const Offset(-1, -1),
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
