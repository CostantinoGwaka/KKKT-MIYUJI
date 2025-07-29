import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/spacer.dart';
import 'package:kanisaapp/register_login/screens/login.dart';

class NoAuthBanner extends StatelessWidget {
  const NoAuthBanner({super.key});

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
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Image.asset('assets/images/lock.png'),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    "Umezuiliwa",
                    style: GoogleFonts.montserrat(
                      fontSize: 23,
                      color: MyColors.darkText,
                      letterSpacing: 0.168,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Tafadhali Ingia kwa akaunti yako kuendelea",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: MyColors.grey_20,
                    letterSpacing: 0.168,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Login()));
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
