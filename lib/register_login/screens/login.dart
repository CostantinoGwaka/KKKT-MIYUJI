// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, deprecated_member_use

import 'dart:convert';
import 'package:flutter/foundation.dart';
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
import 'package:kanisaapp/usajili/screens/index.dart';
import 'package:kanisaapp/utils/Alerts.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/services/user_service.dart';
import 'package:kanisaapp/utils/user_manager.dart';

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

  Future<void> checkMtumishi(String memberNo) async {
    // Check mtumishi permission using the service
    bool hasMtumishiPermission = await UserService.checkMtumishi(memberNo);

    if (hasMtumishiPermission) {
      // Get detailed mtumishi data if needed
      String mtumishApi = "${ApiUrl.BASEURL}check_mtumish.php/";
      final response2 = await http.post(
        Uri.parse(mtumishApi),
        headers: {'Accept': 'application/json'},
        body: {
          "member_no": memberNo,
        },
      );

      if (response2.statusCode == 200) {
        var jsonResponse = json.decode(response2.body);
        if (jsonResponse != null &&
            jsonResponse != 404 &&
            jsonResponse != 500) {
          var json2 = jsonDecode(response2.body);
          if (json2 is List && json2.isNotEmpty) {
            await UserManager.saveMtumishiData(json2[0]);
          }
        }
      }
    }
  }

  Future<dynamic> login(String memberNo, String password) async {
    Alerts.showProgressDialog(
        context, "Tafadhari Subiri,Inatafuta akaunti yako");

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

    try {
      // Get Firebase token
      String token = await FireibaseClass.getUserToken();

      // Call the login service
      LoginResponse loginResponse =
          await UserService.login(memberNo, password, token);

      if (loginResponse.status == 200 && loginResponse.data != null) {
        // Login successful
        setState(() {
          isregistered = false;
          memberController.text = "";
          passwordController.text = "";
        });

        BaseUser user = loginResponse.data!;

        // Store user data using UserManager
        await UserManager.saveCurrentUser(user);

        // Remove loader
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();

        // Add user to Firebase database based on user type
        await _addUserToFirebase(user, token);

        // Check mtumishi permissions
        await checkMtumishi(user.memberNo);

        // Navigate to home page
        // ignore: use_build_context_synchronously
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomePage()));

        return Fluttertoast.showToast(
          msg: "Umefanikiwa kuingia kwenye akaunti",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else if (loginResponse.status == 404) {
        // setState(() {
        //   isregistered = false;
        //   memberController.clear();
        //   passwordController.clear();
        // });
        // Remove loader
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();

        return Fluttertoast.showToast(
          msg: loginResponse.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else if (loginResponse.status == 500) {
        // setState(() {
        //   isregistered = false;
        //   memberController.clear();
        //   passwordController.clear();
        // });
        // Remove loader
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();

        return Fluttertoast.showToast(
          msg: loginResponse.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        setState(() {
          isregistered = false;
        });
        // Remove loader
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();

        return Fluttertoast.showToast(
          msg: loginResponse.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      // Remove loader on error
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();

      setState(() {
        isregistered = false;
      });

      return Fluttertoast.showToast(
        msg: "Hitilafu imetokea. Jaribu tena.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _addUserToFirebase(BaseUser user, String token) async {
    try {
      String userId = user.memberNo;
      String? userName;
      String? phoneNumber;

      // Extract user info based on user type
      if (user.userType == 'ADMIN') {
        userName = user.fullName;
        phoneNumber = user.phonenumber;
      } else if (user.userType == 'MZEE') {
        userName = user.jina;
        phoneNumber = user.nambaYaSimu;
      } else if (user.userType == 'KATIBU') {
        userName = user.jina;
        phoneNumber = user.nambaYaSimu;
      } else if (user.userType == 'MSHARIKA') {
        userName = user.jina;
        phoneNumber = user.nambaYaSimu;
      }

      // Add user to Firebase
      await Cloud.add(
        serverPath: "users/$userId",
        value: {
          "id": userId,
          "firstname": userName ?? '',
          "username": userName ?? '',
          "picture": 'picture',
          "phone": phoneNumber ?? '',
          "token": token,
          "user_type": user.userType,
        },
      );

      // Update staff token
      await Cloud.updateStafToken(
        serverPath: "staffs/$userId",
        value: {
          "token": token,
        },
      );
    } catch (e) {
      // Handle Firebase error silently or log it
      if (kDebugMode) {
        print("Firebase error: $e");
      }
    }
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: "Namba yako ya simu",
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey.shade500,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.phone_android_rounded,
              color: MyColors.primaryLight,
              size: 20,
            ),
          ),
          fillColor: Colors.white,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
        onChanged: (value) {
          if (value.length == 1 && !(value.startsWith('0'))) {
            memberController.clear();
          } else if (value.length == 2 &&
              !(value.startsWith('06') || value.startsWith('07'))) {
            memberController.clear();
          }
        },
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
          if (memberController.text.isEmpty ||
              passwordController.text.isEmpty) {
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RegistrationPageScreen()));
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
