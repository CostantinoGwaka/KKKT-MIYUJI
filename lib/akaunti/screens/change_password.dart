import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:miyuji/home/screens/index.dart';
import 'package:miyuji/shared/localstorage/index.dart';
import 'package:miyuji/usajili/screens/index.dart';
import 'package:miyuji/utils/Alerts.dart';
import 'package:miyuji/utils/ApiUrl.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:miyuji/utils/spacer.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController oldp = TextEditingController();
  TextEditingController newp = TextEditingController();
  bool isregistered = false;
  bool _isObscure = true;
  bool status = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text(
          "Badili neno la siri",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SizedBox(
        child: Column(
          children: <Widget>[
            _bottomBar(context),
          ],
        ),
      ),
    );
  }

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
                // Center(
                //   child: Text("Badili Neno Lako La Siri",
                //       style: GoogleFonts.poppins(
                //         fontSize: 20,
                //         color: const Color(0xff205072),
                //         fontWeight: FontWeight.w500,
                //       )),
                // ),
                const SizedBox(height: 20),
                _inputField1(),
                _inputField2(),
                const SizedBox(height: 15),
                _loginbtn(context),
                const SizedBox(height: 40),
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
        controller: oldp,
        keyboardType: TextInputType.text,
        style: GoogleFonts.poppins(fontSize: 20, color: Colors.black, letterSpacing: 0.24, fontWeight: FontWeight.w500),
        decoration: const InputDecoration(
          hintText: "Neno la siri lazamani",
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
        obscureText: _isObscure,
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
        controller: newp,
        decoration: InputDecoration(
          hintText: "Neno la siri jipya",
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

  Future<Future<bool?>> updatePassword(
    String? memberNo,
    String? oldpassword,
    String? newpassword,
  ) async {
    //get my data
    Alerts.showProgressDialog(context, "Tafadhari Subiri,neno lako linabadilishwa");
    setState(() {
      status = true;
    });

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
        status = false;
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
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        return Fluttertoast.showToast(
          msg: "Neno la siri limebadilishwa",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: MyColors.primaryLight,
          textColor: Colors.white,
        );
      } else {
        setState(() {
          status = false;
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
        status = false;
      });

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

  Widget _loginbtn(context) {
    // ignore: deprecated_member_use
    return Center(
      // ignore: deprecated_member_use
      child: ElevatedButton(
        onPressed: () async {
          if (oldp.text.isEmpty || newp.text.isEmpty) {
            Fluttertoast.showToast(
              msg: "Tafadhari weka taarifa zote",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: MyColors.primaryLight,
              textColor: Colors.white,
            );
          } else {
            await updatePassword(host['member_no'], oldp.text, newp.text);
          }
        },
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          elevation: 1,
          backgroundColor: MyColors.primaryLight,
        ),
        child: Text(
          "Badili",
          style: GoogleFonts.montserrat(
            fontSize: 23,
            color: MyColors.white,
            letterSpacing: 0.168,
            fontWeight: FontWeight.w500,
          ),
        ),
        // color: MyColors.primaryLight,
      ),
    );
  }
}

// ignore: unused_element
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
