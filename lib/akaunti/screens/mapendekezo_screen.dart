import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:kinyerezi/akaunti/screens/index.dart';
import 'package:kinyerezi/home/screens/index.dart';
import 'package:kinyerezi/shared/localstorage/index.dart';
import 'package:kinyerezi/utils/Alerts.dart';
import 'package:kinyerezi/utils/my_colors.dart';

class MapendekezoScreen extends StatefulWidget {
  @override
  _MapendekezoScreenState createState() => _MapendekezoScreenState();
}

class _MapendekezoScreenState extends State<MapendekezoScreen> {
  TextEditingController xsuggestion = TextEditingController();
  bool isregistered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "Maoni/Mapendekezo",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
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
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(1))),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    "Mapendekezo yako au maoni yako kuhusu mfumo wetu huu yanaweza kusaida wengi sana na kusaidia kuboresha mfumo wetu tuandikie chochote kuhusu mfumo ama changamoto yeyote unayokutana nayo nasi tutaishughulikia ndani ya muda muafaka.",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: xsuggestion,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 1,
                  maxLines: 10,
                  autofocus: true,
                ),
                SizedBox(height: 15),
                _loginbtn(context),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> send_suggestion(
    String member_no,
    String suggestion,
  ) async {
    //get my data
    Alerts.showProgressDialog(
        context, "Tafadhari Subiri,inatuma maoni yako...");

    String mydataApi = "http://kinyerezikkkt.or.tz/api/mapendekezo.php";

    final response = await http.post(
      mydataApi,
      headers: {
        'Accept': 'application/json',
      },
      body: {
        "member_no": "$member_no",
        "maoni": "$suggestion",
      },
    );

    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404 && jsonResponse != 500) {
        setState(() {
          xsuggestion.clear();
        });

        Navigator.of(context).pop();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomePage()));
        return Fluttertoast.showToast(
          msg: "Maoni yako yamepokelewa, Ahsante",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: MyColors.primaryLight,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Kuna makosa kwenye kutuma maoni...",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: MyColors.primaryLight,
          textColor: Colors.white,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Weka Maoni yako tafadhari..",
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
      child: FlatButton(
        onPressed: () async {
          if (xsuggestion.text.isEmpty || xsuggestion.text.isEmpty) {
            return Fluttertoast.showToast(
              msg: "Tafadhari weka maoni au mapendekezo yako..",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: MyColors.primaryLight,
              textColor: Colors.white,
            );
          } else {
            await send_suggestion(host['member_no'], xsuggestion.text);
          }
        },
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 80,
        ),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(20.0),
        ),
        child: Text(
          "Tuma",
          style: GoogleFonts.montserrat(
            fontSize: 23,
            color: Colors.white,
            letterSpacing: 0.168,
            fontWeight: FontWeight.w500,
          ),
        ),
        color: MyColors.primaryLight,
      ),
    );
  }
}
