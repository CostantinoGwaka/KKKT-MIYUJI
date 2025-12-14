// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, prefer_typing_uninitialized_variables, avoid_unnecessary_containers, deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanisaapp/models/akaunti.dart';
import 'package:kanisaapp/models/ratiba_ibada.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
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
        if (json is Map &&
            json.containsKey('data') &&
            json['data'] != null &&
            json['data'] is List) {
          baraza = (json['data'] as List)
              .map((item) => IbadaRatiba.fromJson(item))
              .toList();
        }
      }
    }
    return baraza;
  }

  Future<List<AkauntiUsharikaPodo>> getAkaunti() async {
    String myApi = "${ApiUrl.BASEURL}get_akaunti.php";
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
        if (json is Map &&
            json.containsKey('data') &&
            json['data'] != null &&
            json['data'] is List) {
          baraza = (json['data'] as List)
              .map((item) => AkauntiUsharikaPodo.fromJson(item))
              .toList();
        }
      }
    }
    return baraza;
  }

  Future<void> _pullRefresh() async {
    getRatiba().then((value) {
      setState(() {});
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

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animation/fetching.json', height: 100),
          const SizedBox(height: 16),
          Text(
            "Inapanga taarifa...",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: MyColors.primaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animation/nodata.json', height: 100),
          Text(
            "Hakuna taarifa zilizopatikana",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: MyColors.primaryLight,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  MyColors.primaryLight.withOpacity(0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ratiba na Akaunti",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: MyColors.primaryLight,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Orodha ratiba za ibada na akaunti za kanisa",
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: MyColors.primaryLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.group,
                      color: MyColors.primaryLight,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(55),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                padding: const EdgeInsets.all(4),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                unselectedLabelColor: Colors.white,
                labelColor: MyColors.primaryLight,
                tabs: [
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.event_note, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            "Ratiba",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.account_balance_wallet, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            "Akaunti",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                MyColors.primaryLight.withOpacity(0.15),
                Colors.white,
                Colors.white,
              ],
            ),
          ),
          child: TabBarView(
            children: [
              // Ratiba Za Ibada Tab
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _pullRefresh,
                        child: FutureBuilder<List<IbadaRatiba>>(
                          future: getRatiba(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return _buildLoadingState();
                            } else if (snapshot.hasError || !snapshot.hasData) {
                              return _buildEmptyState();
                            }
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (_, index) {
                                final item = snapshot.data![index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        spreadRadius: 0,
                                        blurRadius: 12,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: MyColors.primaryLight
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: MyColors.primaryLight
                                                    .withOpacity(0.05),
                                                spreadRadius: 0,
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Image.asset(
                                            "assets/images/kanisa.png",
                                            height: 24,
                                            width: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.jina ?? '',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: MyColors.primaryLight,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    size: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Flexible(
                                                    child: Text(
                                                      item.muda ?? '',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 14,
                                          color: Colors.grey[400],
                                        ),
                                      ],
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
              ),
              // Akaunti za Kanisa Tab
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _pullRefresh,
                        child: FutureBuilder<List<AkauntiUsharikaPodo>>(
                          future: getAkaunti(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return _buildLoadingState();
                            } else if (snapshot.hasError || !snapshot.hasData) {
                              return _buildEmptyState();
                            }
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (_, index) {
                                final item = snapshot.data![index];
                                return GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                        ClipboardData(text: item.namba ?? ''));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            const Icon(Icons.check_circle,
                                                color: Colors.white, size: 18),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Namba ya akaunti imenakiliwa',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ),
                                        backgroundColor: MyColors.primaryLight,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        margin: const EdgeInsets.all(16),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 8,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: MyColors.primaryLight
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.account_balance,
                                              color: MyColors.primaryLight,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.jina ?? '',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        MyColors.primaryLight,
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.numbers,
                                                      size: 14,
                                                      color: Colors.grey[600],
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      item.namba ?? '',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: MyColors.primaryLight
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.copy,
                                              size: 14,
                                              color: MyColors.primaryLight,
                                            ),
                                          ),
                                        ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
