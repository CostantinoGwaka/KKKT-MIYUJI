// ignore_for_file: unused_element, avoid_unnecessary_containers, deprecated_member_use, prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'package:kanisaapp/akaunti/screens/change_password.dart';
import 'package:kanisaapp/akaunti/screens/constant.dart';
import 'package:kanisaapp/akaunti/screens/mapendekezo_screen.dart';
import 'package:kanisaapp/register_login/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kanisaapp/home/screens/index.dart';
import 'package:kanisaapp/shared/localstorage/index.dart';
import 'package:kanisaapp/utils/Alerts.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import 'package:kanisaapp/models/user_models.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  final FocusNode myFocusNode = FocusNode();

  BaseUser? currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    // Get current user using UserManager
    BaseUser? user = await UserManager.getCurrentUser();
    setState(() {
      currentUser = user;
    });

    // For backward compatibility, also check old storage format
    LocalStorage.getStringItem('mydata').then((value) {
      if (value.isNotEmpty) {
        var mydata = jsonDecode(value);
        setState(() {
          userData = mydata;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: MyColors.primaryLight,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      MyColors.primaryLight,
                      MyColors.primaryLight.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Hero(
                        tag: 'profile_avatar',
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 50.0,
                            backgroundImage: NetworkImage(
                                "https://user-images.githubusercontent.com/30195/34457818-8f7d8c76-ed82-11e7-8474-3825118a776d.png"),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        currentUser != null ? UserManager.getUserDisplayName(currentUser) : "Guest User",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (currentUser != null)
                        Text(
                          "No. Ahadi: ${(userData == null || userData!['namba_ya_ahadi'] == null) ? currentUser!.memberNo : userData!['namba_ya_ahadi']}",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildStatsCard(),
                  const SizedBox(height: 20),
                  const ProfileListItems(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    if (currentUser == null) {
      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.person_outline,
              size: 60,
              color: MyColors.primaryLight.withOpacity(0.5),
            ),
            const SizedBox(height: 15),
            Text(
              "Karibu kwenye KKKT Miyuji",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MyColors.primaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Mahala ambapo neno la Mungu linawafikia wengi mahala popote wakati wowote.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Login()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primaryLight,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Ingia Akaunti',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final money = NumberFormat("#,###.#", "en_US");

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Taarifa za Ahadi",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyColors.primaryLight,
            ),
          ),
          const SizedBox(height: 20),
          if (userData != null) ...[
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    "Mtaa",
                    userData!['jina_la_jumuiya'] ?? "N/A",
                    Icons.location_on,
                    MyColors.primaryLight,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildStatItem(
                    "Ahadi",
                    userData!['ahadi'] != null ? "${money.format(int.parse(userData!['ahadi']))} Tsh" : "N/A",
                    Icons.volunteer_activism,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildStatItem(
              "Jengo",
              userData!['jengo'] != null ? "${money.format(int.parse(userData!['jengo']))} Tsh" : "N/A",
              Icons.business,
              Colors.orange,
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: MyColors.primaryLight,
                    size: 30,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Taarifa za Ahadi",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: MyColors.primaryLight,
                          ),
                        ),
                        Text(
                          "Zitaonekana hapa baada ya usajili",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
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
    if (await canLaunch(url)) {
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
    return Column(
      children: [
        _buildSectionHeader("Mipangilio ya Akaunti"),
        const SizedBox(height: 15),
        _buildModernListItem(
          context,
          icon: Icons.help_outline_rounded,
          title: 'Msaada/Maelezo',
          subtitle: 'Pata msaada na maelezo',
          color: Colors.blue,
          onTap: () => _launchURL(),
        ),
        const SizedBox(height: 10),
        _buildModernListItem(
          context,
          icon: Icons.lock_outline_rounded,
          title: 'Badili Neno La Siri',
          subtitle: 'Badili neno lako la siri',
          color: Colors.orange,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChangePasswordScreen()));
          },
        ),
        const SizedBox(height: 10),
        _buildModernListItem(
          context,
          icon: Icons.share_rounded,
          title: 'Shirikisha Rafiki',
          subtitle: 'Shirikisha app na marafiki',
          color: Colors.green,
          onTap: () {
            String result = "https://play.google.com/store/apps/details?id=app.miyuji";
            Share.share(
                "Pakua Application yetu mpya ya KKKT miyuji uweze kujipatia Neno la Mungu na Huduma Mbali Mbali za Kiroho Mahala Popote Wakati Wowote. \n\n\nPakua kupitia Kiunganishi : $result");
          },
        ),
        const SizedBox(height: 10),
        _buildModernListItem(
          context,
          icon: Icons.feedback_outlined,
          title: 'Maoni/Mapendekezo',
          subtitle: 'Tupe maoni yako',
          color: Colors.purple,
          onTap: () async {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MapendekezoScreen()));
          },
        ),
        const SizedBox(height: 30),
        _buildSectionHeader("Mipangilio ya Mfumo"),
        const SizedBox(height: 15),
        _buildModernListItem(
          context,
          icon: Icons.logout_rounded,
          title: 'Toka kwenye akaunti',
          subtitle: 'Ondoka kwenye akaunti yako',
          color: Colors.red,
          showArrow: false,
          onTap: () async {
            _showLogoutDialog(context);
          },
        ),
        const SizedBox(height: 40),
        _buildFooter(),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildModernListItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (showArrow)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey[400],
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                color: Colors.red,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                "Crafted with love by",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            "iSoftTz",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: MyColors.primaryLight,
            ),
          ),
          Text(
            "© 2022",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                color: Colors.red,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                "Toka Akaunti",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            "Je, una uhakika unataka kutoka kwenye akaunti yako?",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Sitisha",
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Toka",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
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
