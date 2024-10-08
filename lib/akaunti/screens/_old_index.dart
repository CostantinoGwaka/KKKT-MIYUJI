import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miyuji/home/screens/index.dart';
import 'package:miyuji/shared/localstorage/index.dart';
import 'package:miyuji/utils/Alerts.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:miyuji/utils/spacer.dart';
import 'package:http/http.dart' as http;

class ProfilePages extends StatefulWidget {
  @override
  MapScreensState createState() => MapScreensState();
}

class MapScreensState extends State<ProfilePages> with SingleTickerProviderStateMixin {
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
        body: Container(
      color: Colors.white,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Akaunti",
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: MyColors.primaryLight,
                    ),
                  ),
                  Container(
                    height: 180.0,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Stack(fit: StackFit.loose, children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    width: 120.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: ExactAssetImage('assets/images/profile.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ],
                            ),
                            // Padding(
                            //     padding: EdgeInsets.only(top: 90.0, right: 100.0),
                            //     child: new Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: <Widget>[
                            //         new CircleAvatar(
                            //           backgroundColor: Colors.red,
                            //           radius: 25.0,
                            //           child: new Icon(
                            //             Icons.camera_alt,
                            //             color: Colors.white,
                            //           ),
                            //         )
                            //       ],
                            //     )),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Padding(
                        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                '${host['fname']} - ${host['member_no']}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.primaryLight,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: MyColors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          color: Color(0xffFFFFFF),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              'Taarifa zako',
                                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),

                                        // new Column(
                                        //   mainAxisAlignment: MainAxisAlignment.end,
                                        //   mainAxisSize: MainAxisSize.min,
                                        //   children: <Widget>[
                                        //     _status ? _getEditIcon() : new Container(),
                                        //   ],
                                        // )
                                      ],
                                    )),
                                Divider(
                                  thickness: 2,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              'Jina Kamili',
                                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(
                                            '${host['fname']}',
                                            style: TextStyle(fontSize: 13.0),
                                          ),
                                        ),
                                      ],
                                    )),
                                Divider(
                                  thickness: 2,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              'Namba ya Ahadi',
                                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(
                                            '${host['member_no']}',
                                            style: TextStyle(fontSize: 13.0),
                                          ),
                                        ),
                                      ],
                                    )),
                                Divider(
                                  thickness: 2,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              'Jumuiya',
                                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(
                                            (data == null || data['namba_ya_ahadi'] == null)
                                                ? host != null
                                                    ? host['member_no']
                                                    : "N/A"
                                                : "${data['jina_la_jumuiya']}",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                Divider(
                                  thickness: 2,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              'Neno la siri',
                                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          flex: 2,
                                        ),
                                        // Expanded(
                                        //   child: Container(
                                        //     child: new Text(
                                        //       'State',
                                        //       style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                        //     ),
                                        //   ),
                                        //   flex: 2,
                                        // ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 10.0),
                                            child: Column(
                                              children: [
                                                TextField(
                                                  controller: oldp,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    letterSpacing: 0.24,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  // controller: passwordController,
                                                  decoration: InputDecoration(
                                                    hintText: "Neno la siri la zamani",
                                                    hintStyle: TextStyle(
                                                      color: Color(0xffA6B0BD),
                                                    ),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                      borderSide: BorderSide(color: Colors.white),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                      borderSide: BorderSide(color: Colors.white),
                                                    ),
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        _isObscureOld ? Icons.visibility : Icons.visibility_off,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _isObscureOld = !_isObscureOld;
                                                        });
                                                      },
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                  ),
                                                  obscureText: _isObscureOld,
                                                ),
                                                manualStepper(step: 5),
                                                TextField(
                                                  controller: newp,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    letterSpacing: 0.24,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  // controller: passwordController,
                                                  decoration: InputDecoration(
                                                    hintText: "Neno la siri jipya",
                                                    hintStyle: TextStyle(
                                                      color: Color(0xffA6B0BD),
                                                    ),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                      borderSide: BorderSide(color: Colors.white),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                      borderSide: BorderSide(color: Colors.white),
                                                    ),
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        _isObscureNew ? Icons.visibility : Icons.visibility_off,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _isObscureNew = !_isObscureNew;
                                                        });
                                                      },
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                  ),
                                                  obscureText: _isObscureNew,
                                                ),
                                              ],
                                            ),
                                          ),
                                          flex: 2,
                                        ),
                                        // Flexible(
                                        //   child: new TextField(
                                        //     decoration: const InputDecoration(hintText: "Enter State"),
                                        //     enabled: !_status,
                                        //   ),
                                        //   flex: 2,
                                        // ),
                                      ],
                                    )),
                                _getActionButtons(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  // ignore: non_constant_identifier_names
  Future<Future<bool?>> updatePassword(
    String? member_no,
    String? oldpassword,
    String? newpassword,
  ) async {
    //get my data
    Alerts.showProgressDialog(context, "Tafadhari Subiri,neno lako linabadilishwa");
    setState(() {
      _status = true;
    });

    String mydataApi = "http://miyujikkkt.or.tz/api/change_password.php";

    final response = await http.post(
      mydataApi as Uri,
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
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            // ignore: sort_child_properties_last
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
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
                    Text("Badili"),
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
                    // return Fluttertoast.showToast(
                    //   msg: "Weka neno lako la siri jipya na lazamani",
                    //   toastLength: Toast.LENGTH_LONG,
                    //   gravity: ToastGravity.BOTTOM,
                    //   backgroundColor: MyColors.primaryLight,
                    //   textColor: Colors.white,
                    // );
                  }
                },
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            // ignore: sort_child_properties_last
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                  child: ElevatedButton(
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
                    Text("Toka"),
                  ],
                ),
                // textColor: Colors.white,
                // color: MyColors.primaryDark,
                onPressed: () async {
                  Alerts.showProgressDialog(context, "Inatoka kwenye akaunt yako");

                  await LocalStorage.removeItem("member_no").whenComplete(() async {
                    await LocalStorage.removeItem("mydata").whenComplete(() async {
                      await LocalStorage.removeItem("mtumishi").whenComplete(() {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
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
