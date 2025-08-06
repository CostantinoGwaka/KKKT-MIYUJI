// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, prefer_typing_uninitialized_variables, avoid_unnecessary_containers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanisaapp/models/akaunti.dart';
import 'package:kanisaapp/models/ratiba_ibada.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/spacer.dart';
import 'package:http/http.dart' as http;
import 'package:kanisaapp/utils/user_manager.dart';
import 'package:lottie/lottie.dart';

class RatibaZaIbada extends StatefulWidget {
  const RatibaZaIbada({super.key});

  @override
  _RatibaZaIbadaState createState() => _RatibaZaIbadaState();
}

class _RatibaZaIbadaState extends State<RatibaZaIbada> {
  BaseUser? currentUser;

  Future<void> _loadCurrentUser() async {
    try {
      currentUser = await UserManager.getCurrentUser();
      setState(() {});
    } catch (e) {
      // Handle error
    }
  }

  Future<List<IbadaRatiba>> getRatiba() async {
    String myApi = "${ApiUrl.BASEURL}get_ibada.php";
    final response = await http.post(
      Uri.parse(myApi),
      headers: {'Accept': 'application/json'},
      body: jsonEncode({
        "kanisa_id": currentUser != null ? currentUser!.kanisaId : '',
      }),
    );

    var baraza;


    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
         var json = jsonDecode(response.body);
         if (json is Map && json.containsKey('data') && json['data'] != null && json['data'] is List) {
          baraza = (json['data'] as List).map((item) => IbadaRatiba.fromJson(item)).toList();
        }
      }
    }
    return baraza;
  }

  Future<List<AkauntiUsharikaPodo>> getAkaunti() async {
    String myApi = "${ApiUrl.BASEURL}get_akaunti.php";
    final response = await http
        .post(Uri.parse(myApi), headers: {'Accept': 'application/json'},
         body: jsonEncode({
        "kanisa_id": currentUser != null ? currentUser!.kanisaId : '',
      }),
        );

    var baraza;


    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
         var json = jsonDecode(response.body);
         if (json is Map && json.containsKey('data') && json['data'] != null && json['data'] is List) {
          baraza = (json['data'] as List).map((item) => AkauntiUsharikaPodo.fromJson(item)).toList();
        }
      }
    }
    return baraza;
  }

  Future<void> _pullRefresh() async {
    getRatiba().then((value) {
      setState(() {
        //finish
      });
      return;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    getAkaunti();
    getRatiba();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
      backgroundColor: MyColors.primaryLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.primaryLight,
        title: Text(
        "Ratiba na Akaunti",
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        ),
        bottom: TabBar(
        indicatorColor: Colors.white,
        tabs: [
          Tab(
          icon: const Icon(Icons.event_note, color: Colors.white),
          child: Text(
            "Ratiba Za Ibada",
            style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.white,
            ),
          ),
          ),
          Tab(
          icon: const Icon(Icons.account_balance_wallet, color: Colors.white),
          child: Text(
            "Akaunti za Kanisa",
            style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.white,
            ),
          ),
          ),
        ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        ),
        child: TabBarView(
        children: [
          // Ratiba Za Ibada Tab
          Column(
          children: [
            Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Ratiba Za Ibada",
              style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: MyColors.primaryLight,
              ),
            ),
            ),
            Expanded(
            child: RefreshIndicator(
              onRefresh: _pullRefresh,
              child: FutureBuilder<List<IbadaRatiba>>(
              future: getRatiba(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/animation/fetching.json', height: 120),
                    const SizedBox(height: 20),
                    Text(
                    "Inapanga taarifa...",
                    style: GoogleFonts.montserrat(
                      color: MyColors.primaryLight,
                    ),
                    ),
                  ],
                  ),
                );
                } else if (snapshot.hasError || !snapshot.hasData) {
                return Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/animation/nodata.json', height: 120),
                    Text(
                    "Hakuna taarifa zilizopatikana",
                    style: GoogleFonts.montserrat(
                      color: MyColors.primaryLight,
                    ),
                    ),
                  ],
                  ),
                );
                }
                return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  final item = snapshot.data![index];
                  return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: MyColors.primaryLight,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                    BoxShadow(
                      color: MyColors.primaryLight.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: Image.asset("assets/images/kanisa.png", height: 30),
                    ),
                    title: Text(
                    item.jina ?? '',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    ),
                    subtitle: Text(
                    item.muda ?? '',
                    style: GoogleFonts.montserrat(
                      color: Colors.white70,
                    ),
                    ),
                  ),
                  );
                },
                );
              },
              ),
            ),
            ),
          ],
          ),
          // Akaunti za Kanisa Tab
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Akaunti za Kanisa",
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primaryLight,
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _pullRefresh,
                  child: FutureBuilder<List<AkauntiUsharikaPodo>>(
                    future: getAkaunti(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/animation/fetching.json', height: 120),
                              const SizedBox(height: 20),
                              Text(
                                "Inapanga taarifa...",
                                style: GoogleFonts.montserrat(
                                  color: MyColors.primaryLight,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError || !snapshot.hasData) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/animation/nodata.json', height: 120),
                              Text(
                                "Hakuna taarifa zilizopatikana",
                                style: GoogleFonts.montserrat(
                                  color: MyColors.primaryLight,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) {
                          final item = snapshot.data![index];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: MyColors.primaryLight,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: MyColors.primaryLight.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 25,
                                child: Icon(Icons.account_balance, color: MyColors.primaryLight),
                              ),
                              title: Text(
                                item.jina ?? '',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                item.namba ?? '',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white70,
                                ),
                              ),
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: item.namba ?? ''));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Namba ya akaunti imenakiliwa'),
                                    backgroundColor: MyColors.primaryLight,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
        ),
      ),
      ),
    );
  }
}
