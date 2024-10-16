import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:google_fonts/google_fonts.dart';
import 'package:miyuji/chatroom/cloud/cloud.dart';
import 'package:miyuji/chatroom/cloud/firebase_notification.dart';
import 'package:miyuji/home/screens/index.dart';
import 'package:miyuji/shared/localstorage/index.dart';
import 'package:miyuji/usajili/screens/index.dart';
import 'package:miyuji/utils/Alerts.dart';
import 'package:miyuji/utils/ApiUrl.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:miyuji/utils/spacer.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController memberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isregistered = false;
  bool _isObscure = true;

  Future<void> checkGetMyData(String memberNo) async {
    //get my data

    String mydataApi = "${ApiUrl.BASEURL}get_mydata.php/";

    final response = await http.post(
      Uri.parse(mydataApi),
      headers: {'Accept': 'application/json'},
      body: {
        "member_no": memberNo,
      },
    );

    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404 && jsonResponse != 500) {
        var json = jsonDecode(response.body);

        String mydata = jsonEncode(json[0]);

        await LocalStorage.setStringItem("mydata", mydata);
      }
    }

    //end here
  }

  Future<void> checkMtumish(String memberNo) async {
    // //check mtumishi permission

    String mtumishApi = "${ApiUrl.BASEURL}check_mtumish.php/";
    final response2 = await http.post(
      mtumishApi as Uri,
      headers: {'Accept': 'application/json'},
      body: {
        "member_no": memberNo,
      },
    );

    if (response2.statusCode == 200) {
      var jsonResponse = json.decode(response2.body);
      if (jsonResponse != null && jsonResponse != 404 && jsonResponse != 500) {
        var json2 = jsonDecode(response2.body);

        String mtumishi = jsonEncode(json2[0]);

        await LocalStorage.setStringItem("mtumishi", mtumishi);
      }
    }

    // //end here
  }

  Future<dynamic> login(String memberNo, String password) async {
    Alerts.showProgressDialog(context, "Tafadhari Subiri,Inatafuta akaunti yako");
    if (memberNo == "" || password == "") {
      setState(() {
        isregistered = true;
      });

      return Fluttertoast.showToast(
          msg: "Tafadhari weka taarifa zote", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: MyColors.primaryLight, textColor: Colors.white);
    }

    FireibaseClass.getUserToken().then((tokens) async {
      String myApi = "${ApiUrl.BASEURL}login.php/";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {'Accept': 'application/json'},
        body: {
          "member_no": memberNo,
          "password": password,
          "token": tokens,
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse != null && jsonResponse != 404 && jsonResponse != 500) {
          var json = jsonDecode(response.body);
          setState(
            () {
              isregistered = false;
              memberController.text = "";
              passwordController.text = "";
            },
          );

          String mtumishi = jsonEncode(json[0]);

          FireibaseClass.getUserToken().then((token) {
            Cloud.add(
              serverPath: "users/${json[0]['member_no']}",
              value: {
                "id": '${json[0]['member_no']}',
                "firstname": '${json[0]['fname']}',
                "username": '${json[0]['fname']}',
                "picture": 'picture',
                "phone": '${json[0]['namba_ya_simu']}',
                "token": token
              },
            ).whenComplete(() {
              Cloud.updateStafToken(
                serverPath: "staffs/${json[0]['member_no']}",
                value: {
                  "token": token,
                },
              );
            });
          });
          //add user to firebase database

          await LocalStorage.setStringItem("member_no", mtumishi);

          await checkGetMyData(memberNo);

          await checkMtumish(memberNo);

          //remove loader
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
          //end here

          // ignore: use_build_context_synchronously
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));

          return Fluttertoast.showToast(
            msg: "Umefanikiwa kuingia kwenye akaunti",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        } else if (jsonResponse == 404) {
          setState(
            () {
              isregistered = false;
            },
          );
          //remove loader
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
          //end here

          setState(
            () {
              isregistered = false;
              memberController.clear();
              passwordController.clear();
            },
          );
          return Fluttertoast.showToast(
            msg: "Taarifa zako hazijapatikana",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        } else if (jsonResponse == 500) {
          setState(() {
            isregistered = false;
          });
          //remove loader
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
          //end here
          setState(
            () {
              isregistered = false;
              memberController.clear();
              passwordController.clear();
            },
          );
          return Fluttertoast.showToast(
            msg: "Server Error Please Try Again Later",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        setState(
          () {
            isregistered = false;
          },
        );
        // ignore: avoid_print
        print("no data");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[_topBar, _bottomBar(context)],
        ),
      ),
    );
  }

  Widget get _topBar => Container(
        child: Column(
          children: [
            Image.asset(
              "assets/images/banner.png",
              fit: BoxFit.fitHeight,
            ),
          ],
        ),
      );

  Widget _bottomBar(context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(1))),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text("Ingia Kwenye Akaunti",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: const Color(0xff205072),
                        fontWeight: FontWeight.w500,
                      )),
                ),
                const SizedBox(height: 20),
                _inputField1(),
                _inputField2(),
                const SizedBox(height: 15),
                _loginbtn(context),
                const SizedBox(height: 40),
                _passCode(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField1() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 25,
            offset: Offset(0, 5),
            spreadRadius: -25,
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: memberController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: GoogleFonts.poppins(fontSize: 20, color: Colors.black, letterSpacing: 0.24, fontWeight: FontWeight.w500),
        decoration: const InputDecoration(
          hintText: "Namba yako ya Ahadi",
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
        ),
      ),
    );
  }

  Widget _inputField2() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 25,
            offset: Offset(0, 5),
            spreadRadius: -25,
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 20),
      child: TextField(
        style: GoogleFonts.poppins(
          fontSize: 20,
          color: Colors.black,
          letterSpacing: 0.24,
          fontWeight: FontWeight.w500,
        ),
        controller: passwordController,
        decoration: InputDecoration(
          hintText: "Neno la siri",
          hintStyle: const TextStyle(
            color: Color(0xffA6B0BD),
          ),
          fillColor: Colors.white,
          filled: true,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isObscure ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
            color: Theme.of(context).primaryColor,
          ),
        ),
        obscureText: _isObscure,
      ),
    );
  }

  Widget _loginbtn(context) {
    // ignore: deprecated_member_use
    return Center(
      // ignore: deprecated_member_use
      child: ElevatedButton(
        onPressed: () async {
          if (memberController.text.isEmpty || passwordController.text.isEmpty) {
            Fluttertoast.showToast(
              msg: "Tafadhari weka taarifa zote",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: MyColors.primaryLight,
              textColor: Colors.white,
            );
          } else {
            await login(memberController.text, passwordController.text);
          }
        },
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          elevation: 1,
          backgroundColor: MyColors.primaryLight,
        ),
        child: Text(
          "Ingia",
          style: GoogleFonts.montserrat(
            fontSize: 23,
            color: MyColors.white,
            letterSpacing: 0.168,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

Widget _passCode(context) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Je! Hauna akaunti? ",
            style: GoogleFonts.montserrat(fontSize: 20, color: Colors.black),
          ),
          InkWell(
            child: Text(
              "Jisajili",
              style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegistrationScreen()));
            },
          )
        ],
      ),
      manualStepper(step: 10),
      InkWell(
        child: Text(
          "Rudi nyuma",
          style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
        ),
        onTap: () {
          Navigator.of(context).pop();
        },
      )
    ],
  );
}
