// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages, prefer_typing_uninitialized_variables, deprecated_member_use

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/TextStyles.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import 'package:lottie/lottie.dart';

class MatoleoScreen extends StatefulWidget {
  const MatoleoScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<MatoleoScreen> {
  BaseUser? currentUser;
  String searchQuery = '';
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    _loadCurrentUser();
    super.initState();
  }

  void _loadCurrentUser() async {
    BaseUser? user = await UserManager.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  Future<dynamic> getSadakaZako() async {
    if (currentUser == null) return null;

    final response = await http.post(
      Uri.parse("${ApiUrl.BASEURL}api2/sadaka/get_sadaka_kwa_user.php"),
      body: jsonEncode({"user_id": currentUser!.id}),
      headers: {'Content-Type': 'application/json'},
    );
    var baraza;
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse['status'] != 404) {
        var json = jsonDecode(response.body);
        baraza = json['data'];
      } else {
        baraza = [];
      }
    } else {
      baraza = [];
    }

    return baraza;
  }

  Future<dynamic> getJumlaAhadi() async {
    if (currentUser == null) return 0;

    final response = await http.post(
      Uri.parse("${ApiUrl.BASEURL}api2/sadaka/get_sadaka_kwa_user.php"),
      body: jsonEncode({"user_id": currentUser!.id}),
      headers: {'Content-Type': 'application/json'},
    );

    var baraza;
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        baraza = json;
      }
    }

    return baraza;
  }

  Future<dynamic> getJumlaJengo() async {
    if (currentUser == null) return 0;

    String myApi = "${ApiUrl.BASEURL}get_jumla_jengo_sadaka.php";
    final response = await http.post(
      Uri.parse(myApi),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        "member_no": currentUser!.memberNo,
      },
    );

    var baraza;
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        baraza = json;
      }
    }

    return baraza;
  }

  // Helper methods to get user data
  int _getUserAhadi() {
    if (currentUser == null) return 0;

    if (currentUser is BaseUser) {
      String ahadi = (currentUser as BaseUser).msharikaRecords.isNotEmpty
          ? (currentUser as BaseUser).msharikaRecords[0].ahadi
          : '';
      if (ahadi.isNotEmpty && ahadi != '0') {
        try {
          return int.parse(ahadi);
        } catch (e) {
          return 0;
        }
      }
    }

    return 0;
  }

  int _getUserJengo() {
    if (currentUser == null) return 0;

    if (currentUser is BaseUser) {
      String jengo = (currentUser as BaseUser).msharikaRecords.isNotEmpty
          ? (currentUser as BaseUser).msharikaRecords[0].jengo
          : '';
      if (jengo.isNotEmpty && jengo != '0') {
        try {
          return int.parse(jengo);
        } catch (e) {
          return 0;
        }
      }
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat("#,###.#", "en_US");

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.white,
          border: const Border(),
          leading: GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: MyColors.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.arrow_back_ios,
                  color: MyColors.primaryLight, size: 16),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          middle: Text(
            "Matoleo Yako",
            style: TextStyles.headline(context).copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyColors.primaryLight,
            ),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                children: [
                  // Summary Cards Section
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Muhtasari wa Matoleo",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: MyColors.primaryLight,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            // Ahadi Card
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      MyColors.primaryLight,
                                      MyColors.primaryLight.withOpacity(0.8)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: MyColors.primaryLight
                                          .withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Icon(Icons.handshake,
                                              color: Colors.white, size: 16),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            "Ahadi",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Tsh ${currency.format(_getUserAhadi())}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    FutureBuilder(
                                      future: getJumlaAhadi(),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container(
                                            height: 16,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          );
                                        } else if (snapshot.hasData) {
                                          return Text(
                                            "0",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  fontSize: 10,
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                ),
                                          );
                                        } else {
                                          return Text(
                                            "Hakuna data",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  fontSize: 10,
                                                  color: Colors.white
                                                      .withOpacity(0.7),
                                                ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Jengo Card
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.orange.shade600,
                                      Colors.orange.shade500
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.orange.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Icon(Icons.home_work,
                                              color: Colors.white, size: 16),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            "Jengo",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Tsh ${currency.format(_getUserJengo())}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    FutureBuilder(
                                      future: getJumlaJengo(),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container(
                                            height: 16,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          );
                                        } else if (snapshot.hasData) {
                                          return Text(
                                            "0",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  fontSize: 10,
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                ),
                                          );
                                        } else {
                                          return Text(
                                            "Hakuna data",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  fontSize: 10,
                                                  color: Colors.white
                                                      .withOpacity(0.7),
                                                ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Matoleo Section Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: MyColors.primaryLight.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.list_alt,
                            color: MyColors.primaryLight, size: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Historia ya Matoleo",
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.primaryLight,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Search Field
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Tafuta kwa namba, ahadi, jengo au tarehe...',
                      hintStyle: GoogleFonts.poppins(fontSize: 12),
                      prefixIcon: Icon(Icons.search,
                          color: MyColors.primaryLight, size: 20),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: 13),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  // Date Range Filter
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: startDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                startDate = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: startDate != null
                                    ? MyColors.primaryLight
                                    : Colors.grey.shade300,
                                width: startDate != null ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: startDate != null
                                      ? MyColors.primaryLight
                                      : Colors.grey.shade600,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  startDate != null
                                      ? DateFormat('dd/MM/yyyy')
                                          .format(startDate!)
                                      : 'Kuanzia',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: startDate != null
                                        ? MyColors.primaryLight
                                        : Colors.grey.shade600,
                                    fontWeight: startDate != null
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: endDate ?? DateTime.now(),
                              firstDate: startDate ?? DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                endDate = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: endDate != null
                                    ? MyColors.primaryLight
                                    : Colors.grey.shade300,
                                width: endDate != null ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: endDate != null
                                      ? MyColors.primaryLight
                                      : Colors.grey.shade600,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  endDate != null
                                      ? DateFormat('dd/MM/yyyy')
                                          .format(endDate!)
                                      : 'Hadi',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: endDate != null
                                        ? MyColors.primaryLight
                                        : Colors.grey.shade600,
                                    fontWeight: endDate != null
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (startDate != null || endDate != null)
                        IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.red.shade400,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              startDate = null;
                              endDate = null;
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Matoleo List
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: FutureBuilder(
                        future: getSadakaZako(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              height: 250,
                              padding: const EdgeInsets.all(30),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                      'assets/animation/fetching.json',
                                      height: 100,
                                    ),
                                    const SizedBox(height: 12),
                                    Material(
                                      child: Text(
                                        "Inapanga taarifa...",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.0,
                                          color: MyColors.primaryLight,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else if (snapshot.hasError || !snapshot.hasData) {
                            return Container(
                              height: 250,
                              padding: const EdgeInsets.all(30),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset('assets/animation/nodata.json',
                                        height: 100),
                                    const SizedBox(height: 12),
                                    Material(
                                      child: Text(
                                        "Hakuna taarifa zilizopatikana",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.0,
                                          color: MyColors.primaryLight,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else if (snapshot.hasData) {
                            // Filter logic
                            List filteredData = snapshot.data!.where((sadaka) {
                              final ahadi = sadaka['ahadi']?.toString() ?? '';
                              final jengo = sadaka['jengo']?.toString() ?? '';
                              final namba = sadaka['namba']?.toString() ?? '';
                              final tarehe = sadaka['tarehe']?.toString() ?? '';

                              // Search filter
                              final matchesSearch = searchQuery.isEmpty ||
                                  namba
                                      .toLowerCase()
                                      .contains(searchQuery.toLowerCase()) ||
                                  ahadi.contains(searchQuery) ||
                                  jengo.contains(searchQuery) ||
                                  tarehe.contains(searchQuery);

                              // Date range filter
                              bool matchesDateRange = true;
                              if (startDate != null || endDate != null) {
                                try {
                                  final sadakaDate =
                                      DateFormat('yyyy-MM-dd').parse(tarehe);
                                  if (startDate != null && endDate != null) {
                                    matchesDateRange = sadakaDate.isAfter(
                                            startDate!.subtract(
                                                const Duration(days: 1))) &&
                                        sadakaDate.isBefore(endDate!
                                            .add(const Duration(days: 1)));
                                  } else if (startDate != null) {
                                    matchesDateRange = sadakaDate.isAfter(
                                        startDate!
                                            .subtract(const Duration(days: 1)));
                                  } else if (endDate != null) {
                                    matchesDateRange = sadakaDate.isBefore(
                                        endDate!.add(const Duration(days: 1)));
                                  }
                                } catch (e) {
                                  matchesDateRange = true;
                                }
                              }

                              return matchesSearch && matchesDateRange;
                            }).toList();

                            if (filteredData.isEmpty) {
                              return Container(
                                height: 250,
                                padding: const EdgeInsets.all(30),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off_rounded,
                                        size: 56,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 12),
                                      Material(
                                        child: Text(
                                          "Hakuna matokeo yaliyopatikana",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.0,
                                            color: MyColors.primaryLight,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                itemCount: filteredData.length,
                                itemBuilder: (_, index) {
                                  final sadaka = filteredData[index];
                                  final ahadi = int.tryParse(
                                          sadaka['ahadi']?.toString() ?? '0') ??
                                      0;
                                  final jengo = int.tryParse(
                                          sadaka['jengo']?.toString() ?? '0') ??
                                      0;
                                  final tarehe =
                                      sadaka['tarehe']?.toString() ?? 'N/A';
                                  final namba =
                                      sadaka['namba']?.toString() ?? 'N/A';

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: Card(
                                      elevation: 4,
                                      shadowColor:
                                          Colors.black.withOpacity(0.08),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      color: Colors.white,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.white,
                                              Colors.grey.shade50,
                                            ],
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            // Header with gradient
                                            Container(
                                              padding: const EdgeInsets.all(14),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    MyColors.primaryLight,
                                                    MyColors.primaryLight
                                                        .withOpacity(0.8),
                                                  ],
                                                ),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(16),
                                                  topRight: Radius.circular(16),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.3),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: const Icon(
                                                          Icons
                                                              .receipt_long_rounded,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            namba,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleMedium!
                                                                .copyWith(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.5,
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                              height: 2),
                                                          Text(
                                                            "Namba ya Sadaka",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall!
                                                                .copyWith(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.9),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 6),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.25),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      border: Border.all(
                                                        color: Colors.white
                                                            .withOpacity(0.4),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .calendar_today_rounded,
                                                          size: 11,
                                                          color: Colors.white,
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          tarehe,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Content Section
                                            Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Row(
                                                children: [
                                                  // Ahadi Section
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              14),
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          colors: [
                                                            Colors
                                                                .green.shade50,
                                                            Colors
                                                                .green.shade100
                                                                .withOpacity(
                                                                    0.5),
                                                          ],
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        border: Border.all(
                                                          color: Colors
                                                              .green.shade200,
                                                          width: 1.5,
                                                        ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(6),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .green
                                                                      .shade600,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .handshake_rounded,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 14,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              Text(
                                                                "Ahadi",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleMedium!
                                                                    .copyWith(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .green
                                                                          .shade700,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Text(
                                                            "TZS ${currency.format(ahadi)}",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleLarge!
                                                                .copyWith(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .green
                                                                      .shade800,
                                                                  letterSpacing:
                                                                      0.5,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  // Jengo Section
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              14),
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          colors: [
                                                            Colors.blue.shade50,
                                                            Colors.blue.shade100
                                                                .withOpacity(
                                                                    0.5),
                                                          ],
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        border: Border.all(
                                                          color: Colors
                                                              .blue.shade200,
                                                          width: 1.5,
                                                        ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(6),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .blue
                                                                      .shade600,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .home_work_rounded,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 14,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              Text(
                                                                "Jengo",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleMedium!
                                                                    .copyWith(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .blue
                                                                          .shade700,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Text(
                                                            "TZS ${currency.format(jengo)}",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleLarge!
                                                                .copyWith(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .blue
                                                                      .shade800,
                                                                  letterSpacing:
                                                                      0.5,
                                                                ),
                                                          ),
                                                        ],
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
                                });
                          } else {
                            return SizedBox(
                              height: 180,
                              child: Center(
                                child: Text(
                                  "Hakuna data",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
