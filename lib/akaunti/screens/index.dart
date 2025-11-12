// ignore_for_file: unused_element, avoid_unnecessary_containers, deprecated_member_use, prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:kanisaapp/admin/screens/msharika_info_card.dart';
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

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
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
            automaticallyImplyLeading: false,
            expandedHeight:
                (MediaQuery.of(context).size.height * 0.25).clamp(150.0, 280.0),
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: MyColors.primaryLight,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // scroll offset height
                var top = constraints.biggest.height;
                bool showTitle = top <= kToolbarHeight + 20;

                return FlexibleSpaceBar(
                  centerTitle: true,
                  title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: showTitle ? 1.0 : 0.0,
                    child: Text(
                      UserManager.getUserDisplayName(currentUser),
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MyColors.white,
                      ),
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: (MediaQuery.of(context).size.width *
                                              0.08)
                                          .clamp(16.0, 40.0)
                                          .toDouble(),
                                      top: (MediaQuery.of(context).size.height *
                                              0.01)
                                          .clamp(4.0, 20.0)
                                          .toDouble(),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Hero(
                                          tag: 'profile_avatar',
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 4),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.25),
                                                  blurRadius: 20,
                                                  offset: const Offset(0, 10),
                                                ),
                                              ],
                                            ),
                                            child: CircleAvatar(
                                              radius: 5.0,
                                              backgroundImage: NetworkImage(
                                                "https://user-images.githubusercontent.com/30195/34457818-8f7d8c76-ed82-11e7-8474-3825118a776d.png",
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          UserManager.getUserDisplayName(
                                              currentUser),
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.badge,
                                                color: Colors.white70,
                                                size: 18),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'Mtumiaji: ${currentUser!.userType}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(Icons.person,
                                                color: Colors.white70,
                                                size: 18),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'Jina: ${UserManager.getUserDisplayName(currentUser)}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(Icons.phone_android,
                                                color: Colors.white70,
                                                size: 18),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'Simu: ${UserManager.getUserPhoneNumber(currentUser)}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(Icons.confirmation_number,
                                                color: Colors.white70,
                                                size: 18),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'No. Ahadi: ${currentUser!.msharikaRecords.isEmpty ? currentUser!.memberNo : currentUser!.msharikaRecords[0].nambaYaAhadi}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on,
                                                color: Colors.white70,
                                                size: 18),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'Kanisa: ${currentUser!.kanisaName}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildStatsCard(),
                  const SizedBox(height: 10),
                  _buildInfoCard(),
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

  Widget _buildAdminInfo(BaseUser admin) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Taarifa za Admin',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Barua Pepe: ${admin.email}'),
              Text('Level: ${admin.level}'),
              // ignore: unrelated_type_equality_checks
              Text('Hali: ${admin.status == 1 ? "Active" : "Inactive"}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMzeeInfo(BaseUser mzee) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Taarifa za Mzee',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Eneo: ${mzee.eneo}'),
              Text('Jumuiya: ${mzee.jumuiya}'),
              Text('Mwaka: ${mzee.mwaka}'),
              Text('Hali: ${mzee.status == 1 ? "Active" : "Inactive"}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKatibuInfo(BaseUser katibu) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Taarifa za Katibu',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Jumuiya: ${katibu.jumuiya}'),
              Text('Mwaka: ${katibu.mwaka}'),
              Text('Hali: ${katibu.status == 1 ? "Active" : "Inactive"}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMsharikaInfo(BaseUser msharika) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Msharika Information',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                'Jinsia: ${msharika.msharikaRecords.isNotEmpty ? msharika.msharikaRecords[0].jinsia : ''}'),
            Text(
                'Umri: ${msharika.msharikaRecords.isNotEmpty ? msharika.msharikaRecords[0].umri : ''}'),
            Text(
                'Hali ya Ndoa: ${msharika.msharikaRecords.isNotEmpty ? msharika.msharikaRecords[0].haliYaNdoa : ''}'),
            Text(
                'Jumuiya: ${msharika.msharikaRecords.isNotEmpty ? msharika.msharikaRecords[0].jinaLaJumuiya : ''}'),
            Text(
                'Kazi: ${msharika.msharikaRecords.isNotEmpty ? msharika.msharikaRecords[0].kazi : ''}'),
            Text(
                'Ahadi: ${msharika.msharikaRecords.isNotEmpty ? msharika.msharikaRecords[0].ahadi : ''}'),
          ],
        ),
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
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Login()));
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
          if (currentUser != null) ...[
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    "Mtaa",
                    currentUser!.msharikaRecords.isNotEmpty
                        ? currentUser!.msharikaRecords[0].jinaLaJumuiya
                        : "N/A",
                    Icons.location_on,
                    MyColors.primaryLight,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildStatItem(
                    "Ahadi",
                    currentUser!.msharikaRecords.isNotEmpty
                        ? "${money.format(int.parse(currentUser!.msharikaRecords[0].ahadi))} Tsh"
                        : "N/A",
                    Icons.volunteer_activism,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildStatItem(
              "Jengo",
              currentUser!.msharikaRecords.isNotEmpty
                  ? "${money.format(int.parse(currentUser!.msharikaRecords[0].jengo))} Tsh"
                  : "N/A",
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

  Widget _buildInfoCard() {
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
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Login()));
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
            "Taarifa za Msharika",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyColors.primaryLight,
            ),
          ),
          const SizedBox(height: 5),
          if (currentUser != null) ...[
            MsharikaInfoCard(
              msharika: currentUser!.msharikaRecords[0],
            ),
            SizedBox(height: 16),

            // User type specific information
            if (UserManager.isAdmin(currentUser))
              _buildAdminInfo(currentUser as BaseUser)
            else if (UserManager.isMzee(currentUser))
              _buildMzeeInfo(currentUser as BaseUser)
            else if (UserManager.isKatibu(currentUser))
              _buildKatibuInfo(currentUser as BaseUser)
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

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
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

  const SocialIcon(
      {super.key, this.color, this.iconData, required this.onPressed});

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
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ChangePasswordScreen()));
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
            String result =
                "https://play.google.com/store/apps/details?id=app.miyuji";
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
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const MapendekezoScreen()));
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
                Navigator.of(context).pop(); // Close dialog
                Alerts.showProgressDialog(
                    context, "Inatoka kwenye akaunt yako");

                try {
                  // Clear all user related data
                  await Future.wait([
                    LocalStorage.removeItem("current_user"),
                    LocalStorage.removeItem("member_no"),
                    LocalStorage.removeItem("mtumishi"),
                    LocalStorage.removeItem("mydata"),
                  ]);

                  // Navigate and show success message
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false, // Clear navigation stack
                  );

                  Fluttertoast.showToast(
                    msg: "Umefanikiwa kutoka kwenye akaunt yako",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: MyColors.primaryLight,
                    textColor: Colors.white,
                  );

                  // Close app
                  SystemNavigator.pop();
                } catch (e) {
                  Navigator.pop(context); // Close progress dialog
                  Fluttertoast.showToast(
                    msg: "Tatizo limetokea, jaribu tena",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
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
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kAppPrimaryColor,
          boxShadow: [
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
