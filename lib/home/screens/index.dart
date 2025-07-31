// ignore_for_file: deprecated_member_use, depend_on_referenced_packages, prefer_typing_uninitialized_variables, library_private_types_in_public_api

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

// Add this class below your HomePage widget
class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _HeaderDelegate({required this.child});

  @override
  double get minExtent => kToolbarHeight + 40;

  @override
  double get maxExtent => kToolbarHeight + 60;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _HeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}

class _HomePageState extends State<HomePage> {
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
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegistrationScreen()));
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
      padding: const EdgeInsets.all(0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
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
                  style: GoogleFonts.poppins(
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: MyColors.primaryLight.withOpacity(0.15),
          width: 0.8,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _handleMenuNavigation(menuItem['pushTo']),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    menuItem['image'],
                    height: 32,
                    width: 32,
                    color: MyColors.primaryLight,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  menuItem['name'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: MyColors.primaryLight,
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

  // Build header widget
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MyColors.primaryLight.withOpacity(0.05),
            Colors.white,
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            "KANISANI",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MyColors.primaryLight,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 40,
            height: 2,
            decoration: BoxDecoration(
              color: MyColors.primaryLight,
              borderRadius: BorderRadius.circular(2),
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: MyColors.primaryLight.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(
                      "https://user-images.githubusercontent.com/30195/34457818-8f7d8c76-ed82-11e7-8474-3825118a776d.png",
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: host != null ? _buildUserInfo() : _buildGuestInfo(),
                ),
              ],
            ),
            if (host != null) ...[
              const SizedBox(height: 20),
              _buildUserDetails(money),
            ] else ...[
              const SizedBox(height: 16),
              _buildWelcomeMessage(),
            ],
            if (host != null) ...[
              const SizedBox(height: 20),
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
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: MyColors.primaryLight,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          host != null ? "${host['fname']}" : "N/A",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: MyColors.primaryLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.badge_outlined,
                size: 16,
                color: MyColors.primaryLight,
              ),
              const SizedBox(width: 6),
              Text(
                "No. Ahadi: ${(data == null || data['namba_ya_ahadi'] == null) ? (host != null ? host['member_no'] : "N/A") : data['namba_ya_ahadi']}",
                style: GoogleFonts.poppins(
                  fontSize: 12,
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
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Login()),
            );
          },
          icon: const Icon(Icons.login, size: 18),
          label: Text(
            'Ingia Akaunti',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.primaryLight,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
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
              const SizedBox(width: 8),
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
                width: 0.5,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MyColors.primaryLight.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: MyColors.primaryLight.withOpacity(0.2),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: MyColors.primaryLight,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: MyColors.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 11,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MyColors.primaryLight.withOpacity(0.1),
            MyColors.primaryLight.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "Karibu kwenye mfumo wa KKKT Miyuji, mahala ambapo neno la Mungu linawafikia wengi mahala popote wakati wowote.",
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
          height: 1.4,
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
        icon: const Icon(Icons.account_balance_wallet, size: 18),
        label: Text(
          'Matoleo yako',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryLight,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          elevation: 0,
        ),
      ),
    );
  }

  // Build daily word card
  Widget _buildDailyWordCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: MyColors.primaryLight.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.menu_book,
                    color: MyColors.primaryLight,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Neno la Siku",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    MyColors.primaryLight.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<NenoLaSikuData>>(
              future: getRatiba(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                          child: Lottie.asset(
                            'assets/animation/load_neno.json',
                            height: 40,
                          ),
                        ),
                        Text(
                          "Inapakia...",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.orange,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Hakuna taarifa zilizopatiakana",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Container(
                    constraints: const BoxConstraints(maxHeight: 120),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            snapshot.data![index].neno.toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Text(
                    "Hakuna neno la siku",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
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
                  size: 14,
                  color: MyColors.primaryLight,
                ),
                label: Text(
                  'Tazama yote',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: MyColors.primaryLight,
                  ),
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
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
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: MyColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Mahubiri ya tarehe 23-02-2021',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Na Mch. Moses',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: Text(
                      'Tazama zote',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: MyColors.primaryLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      elevation: 0,
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
            SliverPersistentHeader(
              pinned: true,
              delegate: _HeaderDelegate(
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: kToolbarHeight + 60,
                    maxHeight: kToolbarHeight + 80,
                  ),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: _buildHeader(),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: _buildUserInfoCard()),
            SliverToBoxAdapter(child: _buildDailyWordCard()),
            SliverToBoxAdapter(child: _buildSermonBanner()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Huduma Zetus",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.28,
                      child: buildMenu(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      (host == null) ? const NoAuthBanner() : const ViongoziWaKanisa(),
      (host == null) ? const NoAuthBanner() : const RatibaZaIbada(),
      (host == null) ? const NoAuthBanner() : const ProfilePage()
    ];

    void onItemTapped(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: children[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: MyColors.primaryLight,
              unselectedItemColor: Colors.grey.shade500,
              onTap: onItemTapped,
              elevation: 0,
              selectedLabelStyle: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _currentIndex == 0 ? MyColors.primaryLight.withOpacity(0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.home_rounded,
                      size: _currentIndex == 0 ? 28 : 24,
                    ),
                  ),
                  label: "Nyumbani",
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _currentIndex == 1 ? MyColors.primaryLight.withOpacity(0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.people_rounded,
                      size: _currentIndex == 1 ? 28 : 24,
                    ),
                  ),
                  label: 'Uongozi',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _currentIndex == 2 ? MyColors.primaryLight.withOpacity(0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.apps_rounded,
                      size: _currentIndex == 2 ? 28 : 24,
                    ),
                  ),
                  label: 'Mengineyo',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _currentIndex == 3 ? MyColors.primaryLight.withOpacity(0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      size: _currentIndex == 3 ? 28 : 24,
                    ),
                  ),
                  label: 'Akaunti',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
