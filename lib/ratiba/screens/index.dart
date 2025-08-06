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
        .post(Uri.parse(myApi), headers: {'Accept': 'application/json'});

    var barazaList = <AkauntiUsharikaPodo>[];
    var baraza;

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        baraza = json;
      }
    }

    try {
      baraza.forEach(
        (element) {
          AkauntiUsharikaPodo video = AkauntiUsharikaPodo.fromJson(element);
          barazaList.add(video);
        },
      );
      return barazaList;
    } catch (e) {
      return [];
    }
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  MyColors.primaryLight.withOpacity(0.9),
                  Colors.white.withOpacity(0.8)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          bottom: TabBar(
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: MyColors.primaryLight.withOpacity(0.15),
            ),
            tabs: [
              Tab(
                icon: Icon(Icons.event_note, color: MyColors.primaryLight),
                child: Text(
                  "Ratiba Za Ibada",
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primaryLight,
                  ),
                ),
              ),
              Tab(
                icon: Icon(Icons.account_balance_wallet,
                    color: MyColors.primaryLight),
                child: Text(
                  "Akaunti za Kanisa",
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primaryLight,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, MyColors.primaryLight.withOpacity(0.07)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: TabBarView(
            children: [
              // Ratiba Za Ibada Tab
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
                    child: Text(
                      "Ratiba Za Ibada",
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: MyColors.primaryLight,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: FutureBuilder<List<IbadaRatiba>>(
                        future: getRatiba(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset('assets/animation/fetching.json',
                                      height: 120),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Inapanga taarifa...",
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.0,
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
                                  Lottie.asset('assets/animation/nodata.json',
                                      height: 120),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    "Hakuna taarifa zilizopatikana",
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: MyColors.primaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (_, index) {
                                final item = snapshot.data![index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Card(
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    shadowColor:
                                        MyColors.primaryLight.withOpacity(0.2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white,
                                            MyColors.primaryLight
                                                .withOpacity(0.05)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: MyColors.white,
                                          radius: 28,
                                          child: Image.asset(
                                            "assets/images/kanisa.png",
                                            height: 40,
                                          ),
                                        ),
                                        title: Text(
                                          item.jina ?? '',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.primaryLight,
                                          ),
                                        ),
                                        subtitle: Row(
                                          children: [
                                            Icon(Icons.access_time,
                                                size: 16,
                                                color: MyColors.primaryLight),
                                            const SizedBox(width: 6),
                                            Text(
                                              item.muda ?? '',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                color: MyColors.primaryLight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Text("new videos");
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              // Akaunti za Kanisa Tab
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
                    child: Text(
                      "Akaunti za Kanisa",
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: MyColors.primaryLight,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: FutureBuilder<List<AkauntiUsharikaPodo>>(
                        future: getAkaunti(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset('assets/animation/fetching.json',
                                      height: 120),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Inapanga taarifa...",
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.0,
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
                                  Lottie.asset('assets/animation/nodata.json',
                                      height: 120),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    "Hakuna taarifa zilizopatikana",
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: MyColors.primaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (_, index) {
                                final item = snapshot.data![index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Card(
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    shadowColor:
                                        MyColors.primaryLight.withOpacity(0.2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white,
                                            MyColors.primaryLight
                                                .withOpacity(0.05)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: MyColors.white,
                                          radius: 28,
                                          child: Image.asset(
                                            item.jina == "VODACOM"
                                                ? "assets/payicons/mpesa.png"
                                                : item.jina == "TIGO PESA"
                                                    ? "assets/payicons/tigopesa.png"
                                                    : "assets/payicons/cash.png",
                                            height: 40,
                                          ),
                                        ),
                                        title: Text(
                                          item.jina ?? '',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.primaryLight,
                                          ),
                                        ),
                                        subtitle: GestureDetector(
                                          onTap: () {
                                            Clipboard.setData(
                                              ClipboardData(
                                                  text: item.namba ?? ''),
                                            ).then((_) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Nambari ya akaunti imenakiliwa"),
                                                ),
                                              );
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.copy,
                                                  size: 16,
                                                  color: MyColors.primaryLight),
                                              const SizedBox(width: 6),
                                              Text(
                                                item.namba ?? '',
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 14,
                                                  color: MyColors.primaryLight,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Bonyeza kunakili",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 12,
                                                  color: MyColors.primaryLight
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Text("new videos");
                          }
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
