import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:miyuji/utils/spacer.dart';
import 'package:miyuji/register_login/screens/login.dart';

class NoAuthBanner extends StatelessWidget {
  const NoAuthBanner({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              manualStepper(step: 30),
              SizedBox(
                  height: deviceHeight(context) * 0.4,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Image.asset('assets/images/lock.png'),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    "Umezuiliwa",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Tafadhali Ingia kwa akaunti yako kuendelea",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    FlatButton(
                      onPressed: () async {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
                      },
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 80,
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        "Ingia",
                        style: GoogleFonts.montserrat(
                          fontSize: 23,
                          color: Colors.white,
                          letterSpacing: 0.168,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      color: MyColors.primaryLight,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
