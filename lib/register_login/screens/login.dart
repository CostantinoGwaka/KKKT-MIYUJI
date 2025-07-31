// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:google_fonts/google_fonts.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/chatroom/cloud/cloud.dart';
import 'package:kanisaapp/chatroom/cloud/firebase_notification.dart';
import 'package:kanisaapp/home/screens/index.dart';
import 'package:kanisaapp/shared/localstorage/index.dart';
import 'package:kanisaapp/usajili/screens/index.dart';
import 'package:kanisaapp/utils/Alerts.dart';

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
          msg: "Tafadhari weka taarifa zote",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: MyColors.primaryLight,
          textColor: Colors.white);
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
      body: Column(
        children: <Widget>[_topBar, _bottomBar(context)],
      ),
    );
  }

  Widget get _topBar => Container(
        height: MediaQuery.of(context).size.height * 0.35,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: MyColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Text(
                      "KANISANI",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Karibu kwenye akaunti yako",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: MyColors.primaryLight.withOpacity(0.9),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _bottomBar(context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Ingia Kwenye Akaunti",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: MyColors.primaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Weka taarifa zako za kuingia",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 32),
                _inputField1(),
                const SizedBox(height: 16),
                _inputField2(),
                const SizedBox(height: 24),
                _loginbtn(context),
                const SizedBox(height: 32),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: MyColors.primaryLight.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: memberController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: "Namba yako ya Ahadi",
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey.shade500,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.badge_outlined,
              color: MyColors.primaryLight,
              size: 20,
            ),
          ),
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: MyColors.primaryLight, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _inputField2() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: MyColors.primaryLight.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        controller: passwordController,
        decoration: InputDecoration(
          hintText: "Neno la siri",
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey.shade500,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.lock_outline,
              color: MyColors.primaryLight,
              size: 20,
            ),
          ),
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: MyColors.primaryLight, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isObscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey.shade500,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          ),
        ),
        obscureText: _isObscure,
      ),
    );
  }

  Widget _loginbtn(context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
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
          backgroundColor: MyColors.primaryLight,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: MyColors.primaryLight.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Ingia",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 20,
            ),
          ],
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
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w400,
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegistrationScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                "Jisajili",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: MyColors.primaryLight,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          )
        ],
      ),
      const SizedBox(height: 24),
      InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                "Rudi nyuma",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      )
    ],
  );
}
