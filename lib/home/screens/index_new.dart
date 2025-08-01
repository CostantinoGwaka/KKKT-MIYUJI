// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, library_private_types_in_public_api, avoid_print, deprecated_member_use, prefer_const_constructors

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kanisaapp/baraza/screens/index.dart';
import 'package:kanisaapp/chatroom/screen/chat_screen.dart';
import 'package:kanisaapp/jumuiyazetu/screens/index.dart';
import 'package:kanisaapp/kwayazetu/screens/index.dart';
import 'package:kanisaapp/livestream/screens/index.dart';
import 'package:kanisaapp/mahubiri/screens/index.dart';
import 'package:kanisaapp/matangazo/screens/index.dart';
import 'package:kanisaapp/matoleo/index.dart';
import 'package:kanisaapp/models/neno_lasiku.dart';
import 'package:kanisaapp/neno/screens/index.dart';
import 'package:kanisaapp/ratiba/screens/index.dart';
import 'package:kanisaapp/register_login/screens/login.dart';
import 'package:kanisaapp/shared/localstorage/index.dart';
import 'package:kanisaapp/uongozi/screens/index.dart';
import 'package:kanisaapp/usajili/screens/index.dart';
import 'package:kanisaapp/utils/Alerts.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:lottie/lottie.dart';
import 'package:kanisaapp/utils/no_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../akaunti/screens/index.dart';

var host;
var data;
var mtumishi;

class HomeNewPage extends StatefulWidget {
  const HomeNewPage({super.key});

  @override
  _HomeNewPageState createState() => _HomeNewPageState();
}

class _HomeNewPageState extends State<HomeNewPage> {
  int _currentIndex = 0;
  String messageTitle = "Empty";
  String notificationAlert = "alert";

  @override
  void initState() {
    checkLogin();
    getdataLocal();
    super.initState();

    // For handling foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        messageTitle = message.notification?.title ?? 'No Title';
        notificationAlert = "New Notification Alert";
      });
    });

    // For handling when the app is opened via a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      setState(() {
        messageTitle = message.data['title'] ?? 'No Title';
        notificationAlert = "Application opened from Notification";
      });
    });

    // Optionally, handle background messages (requires a background handler)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Background message handler function
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  Future<List<NenoLaSikuData>> getRatiba() async {
    String myApi = "${ApiUrl.BASEURL}get_nenolasiku.php";
    final response = await http.post(
      Uri.parse(myApi),
      headers: {
        'Accept': 'application/json',
      },
    );

    var barazaList = <NenoLaSikuData>[];
    var baraza = [];

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        baraza = json;
      }
    }

    for (var element in baraza) {
      NenoLaSikuData video = NenoLaSikuData.fromJson(element);
      barazaList.add(video);
    }

    return barazaList;
  }

  void checkLogin() async {
    LocalStorage.getStringItem('member_no').then((value) {
      if (value.isNotEmpty) {
        var mydata = jsonDecode(value);
        setState(() {
          host = mydata;
        });
      }
    });
  }

  void getdataLocal() async {
    LocalStorage.getStringItem('mydata').then((value) {
      if (value.isNotEmpty) {
        var mydata = jsonDecode(value);
        setState(() {
          data = mydata;
        });
      }
    });

    LocalStorage.getStringItem('mtumishi').then((value) {
      if (value.isNotEmpty) {
        var mymtumishi = jsonDecode(value);
        setState(() {
          mtumishi = mymtumishi;
        });
      }
    });
  }

  final menuList = <Map<String, dynamic>>[
    {
      'name': 'MAZUNGUMZO',
      'image': 'assets/images/testimonials.png',
      'selected': false,
      'pushTo': 'MAZUNGUMZO',
    },
    {
      'name': 'MATANGAZO',
      'image': 'assets/images/announcement.png',
      'selected': false,
      'pushTo': 'MATANGAZO',
    },
    {
      'name': 'KWAYA ZETU',
      'image': 'assets/images/connect.png',
      'selected': false,
      'pushTo': 'KWAYA ZETU',
    },
    {
      'name': 'JISAJILI MSHARIKA',
      'image': 'assets/images/program.png',
      'selected': false,
      'pushTo': 'JISAJILI MSHARIKA',
    },
    {
      'name': 'JUMUIYA ZETU',
      'image': 'assets/images/connect.png',
      'selected': false,
      'pushTo': 'JUMUIYA ZETU',
    },
    {
      'name': 'MUBASHARA',
      'image': 'assets/images/youtube.png',
      'selected': false,
      'pushTo': 'MUBASHARA',
    }
  ];

  // Navigate based on menu selection
  void _handleMenuNavigation(String pushTo) {
    switch (pushTo) {
      case "BARAZA WAZEE":
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BarazaLaWazee()));
        break;
      case "MUBASHARA":
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LiveYoutubePlayer()));
        break;
      case "MATANGAZO":
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MatangazoScreen()));
        break;
      case "JISAJILI MSHARIKA":
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegistrationPageScreen()));
        break;
      case "KWAYA ZETU":
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const KwayaZetu()));
        break;
      case "MAZUNGUMZO":
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChatScreen()));
        break;
      case "JUMUIYA ZETU":
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const JumuiyaZetu()));
        break;
    }
  }

  Widget buildMenu(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: menuList.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final menuItem = menuList[index];
        final isRestrictedForGuest =
            (host == null) && (menuItem['name'] == "MAZUNGUMZO" || menuItem['name'] == "MATANGAZO");

        if (isRestrictedForGuest) {
          return _buildRestrictedMenuItem(menuItem);
        }

        return _buildMenuItem(menuItem);
      },
    );
  }

  Widget _buildRestrictedMenuItem(Map<String, dynamic> menuItem) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.red.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Alerts.showCupertinoAlert(
              context,
              "${menuItem['name']}(Guest)",
              "Tafadahari ingia kwenye akaunti yako ili kuweza kupata huduma hii. Mtu ambaye hauna akaunti ya msharika tafadhari jisajili. Ahsante.",
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    height: 32,
                    width: 32,
                    child: Lottie.asset(
                      'assets/animation/access_denided.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${menuItem['name']}\n(Guest)",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade400,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> menuItem) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _handleMenuNavigation(menuItem['pushTo']),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        MyColors.primaryLight.withOpacity(0.1),
                        MyColors.primaryLight.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    menuItem['image'],
                    height: 28,
                    width: 28,
                    color: MyColors.primaryLight,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  menuItem['name'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                    color: MyColors.primaryLight,
                    height: 1.1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build header widget
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 12,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MyColors.primaryLight.withOpacity(0.08),
            Colors.white.withOpacity(0.95),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: MyColors.primaryLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.church,
              color: MyColors.primaryLight,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "KKKT MIYUJI",
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primaryLight,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  "Kanisa la Kristu Tanzania",
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: MyColors.primaryLight,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // Build user info card
  Widget _buildUserInfoCard() {
    final money = NumberFormat("#,###.#", "en_US");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        MyColors.primaryLight.withOpacity(0.2),
                        MyColors.primaryLight.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      "https://user-images.githubusercontent.com/30195/34457818-8f7d8c76-ed82-11e7-8474-3825118a776d.png",
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: host != null ? _buildUserInfo() : _buildGuestInfo(),
                ),
              ],
            ),
            if (host != null) ...[
              const SizedBox(height: 16),
              _buildUserDetails(money),
            ] else ...[
              const SizedBox(height: 12),
              _buildWelcomeMessage(),
            ],
            if (host != null) ...[
              const SizedBox(height: 16),
              _buildMatoleoButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Karibu,",
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: MyColors.primaryLight,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          host != null ? "${host['fname']}" : "N/A",
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: MyColors.primaryLight.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.badge_outlined,
                size: 14,
                color: MyColors.primaryLight,
              ),
              const SizedBox(width: 4),
              Text(
                "No. Ahadi: ${(data == null || data['namba_ya_ahadi'] == null) ? (host != null ? host['member_no'] : "N/A") : data['namba_ya_ahadi']}",
                style: GoogleFonts.montserrat(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: MyColors.primaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuestInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Mgeni",
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Login()),
            );
          },
          icon: const Icon(Icons.login, size: 16),
          label: Text(
            'Ingia Akaunti',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.primaryLight,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            minimumSize: Size.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildUserDetails(NumberFormat money) {
    return data != null
        ? Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  "Jumuiya",
                  "${data['jina_la_jumuiya'] ?? 'N/A'}",
                  Icons.group,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    _buildInfoCard(
                      "Ahadi",
                      (data['ahadi'] == null) ? "N/A" : "${money.format(int.parse(data['ahadi']))} Tsh",
                      Icons.monetization_on,
                    ),
                    const SizedBox(height: 6),
                    _buildInfoCard(
                      "Jengo",
                      (data['jengo'] == null) ? "N/A" : "${money.format(int.parse(data['jengo']))} Tsh",
                      Icons.home_work,
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MyColors.primaryLight.withOpacity(0.04),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: MyColors.primaryLight.withOpacity(0.15),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.info_outline,
                  color: MyColors.primaryLight,
                  size: 20,
                ),
                const SizedBox(height: 6),
                Text(
                  "Taarifa zako za Ahadi zitaonekana hapa baada ya usajili.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: MyColors.primaryLight.withOpacity(0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: MyColors.primaryLight.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: MyColors.primaryLight,
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: MyColors.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MyColors.primaryLight.withOpacity(0.08),
            MyColors.primaryLight.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "Karibu kwenye mfumo wa KKKT Miyuji, mahala ambapo neno la Mungu linawafikia wengi mahala popote wakati wowote.",
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
          height: 1.3,
        ),
      ),
    );
  }

  Widget _buildMatoleoButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const MatoleoScreen()),
          );
        },
        icon: const Icon(Icons.account_balance_wallet, size: 16),
        label: Text(
          'Matoleo yako',
          style: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryLight,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  // Build daily word card
  Widget _buildDailyWordCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        MyColors.primaryLight.withOpacity(0.15),
                        MyColors.primaryLight.withOpacity(0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: MyColors.primaryLight,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Neno la Siku",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: MyColors.primaryLight.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    DateFormat('dd MMM').format(DateTime.now()),
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: MyColors.primaryLight,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<NenoLaSikuData>>(
              future: getRatiba(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Lottie.asset(
                            'assets/animation/load_neno.json',
                            height: 35,
                          ),
                        ),
                        Text(
                          "Inapakia...",
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.orange,
                          size: 28,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Hakuna taarifa zilizopatiakana",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Container(
                    constraints: const BoxConstraints(maxHeight: 100),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            snapshot.data![index].neno.toString(),
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Text(
                    "Hakuna neno la siku",
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const NenoLaSiku()),
                  );
                },
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: MyColors.primaryLight,
                ),
                label: Text(
                  'Tazama yote',
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: MyColors.primaryLight,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build sermon banner
  Widget _buildSermonBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/miyuji.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: MyColors.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Mahubiri ya tarehe 23-02-2021',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Na Mch. Moses',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const MahubiriScreen()),
                      );
                    },
                    icon: const Icon(Icons.play_arrow, size: 16),
                    label: Text(
                      'Tazama zote',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: MyColors.primaryLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: Size.zero,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List children = [
      RefreshIndicator(
        onRefresh: () async {
          setState(() {
            checkLogin();
            getdataLocal();
          });
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildUserInfoCard()),
            SliverToBoxAdapter(child: _buildDailyWordCard()),
            SliverToBoxAdapter(child: _buildSermonBanner()),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Huduma Zetu",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(
                    child: buildMenu(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      (host == null) ? const NoAuthBanner() : const ViongoziWaKanisa(),
      (host == null) ? const NoAuthBanner() : const RatibaZaIbada(),
      (host == null) ? const NoAuthBanner() : const ProfilePage()
    ];

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: children[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home_outlined, Icons.home, "Nyumbani"),
                  _buildNavItem(1, Icons.people_outline, Icons.people, "Uongozi"),
                  _buildNavItem(2, Icons.grid_view_outlined, Icons.grid_view, "Mengineyo"),
                  _buildNavItem(3, Icons.person_outline, Icons.person, "Akaunti"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData inactiveIcon, IconData activeIcon, String label) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? MyColors.primaryLight.withOpacity(0.15) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSelected ? activeIcon : inactiveIcon,
                  color: isSelected ? MyColors.primaryLight : Colors.grey.shade600,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? MyColors.primaryLight : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
