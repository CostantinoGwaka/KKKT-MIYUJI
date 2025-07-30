import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/register_login/screens/login.dart';

class NoAuthBanner extends StatelessWidget {
  const NoAuthBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryLight.withOpacity(0.05),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: MyColors.primaryLight.withValues(alpha: (0.1 / 2)),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: MyColors.primaryLight.withValues(alpha: 0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(32),
                child: Image.asset(
                  'assets/images/lock.png',
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "Umezuiliwa!",
                style: GoogleFonts.montserrat(
                  fontSize: 28,
                  color: MyColors.darkText,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Tafadhali ingia kwenye akaunti yako ili kuendelea kutumia huduma.",
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  color: MyColors.grey_20,
                  letterSpacing: 0.15,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.login, color: Colors.white),
                  label: Text(
                    "Ingia",
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      color: MyColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryLight,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
