// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages, prefer_typing_uninitialized_variables, deprecated_member_use

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
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

    String myApi = "${ApiUrl.BASEURL}get_sadaka.php";
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
    } else {}

    return baraza;
  }

  Future<dynamic> getJumlaAhadi() async {
    if (currentUser == null) return 0;

    String myApi = "${ApiUrl.BASEURL}get_jumla_ahadi_sadaka.php";
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

    if (currentUser is MsharikaUser) {
      String ahadi = (currentUser as MsharikaUser).ahadi;
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

    if (currentUser is MsharikaUser) {
      String jengo = (currentUser as MsharikaUser).jengo;
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: MyColors.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_back_ios, color: MyColors.primaryLight, size: 20),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          middle: Text(
            "Matoleo Yako",
            style: TextStyles.headline(context).copyWith(
              fontSize: 20,
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                children: [
                  // Summary Cards Section
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Muhtasari wa Matoleo",
                          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: MyColors.primaryLight,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            // Ahadi Card
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [MyColors.primaryLight, MyColors.primaryLight.withOpacity(0.8)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: MyColors.primaryLight.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(Icons.handshake, color: Colors.white, size: 20),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "Ahadi",
                                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "Tsh ${currency.format(_getUserAhadi())}",
                                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    FutureBuilder(
                                      future: getJumlaAhadi(),
                                      builder: (context, AsyncSnapshot snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Container(
                                            height: 20,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.3),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          );
                                        } else if (snapshot.hasData) {
                                          return Text(
                                            // "Jumla: Tsh ${currency.format(snapshot.data is Map && snapshot.data['jumla'] != null ? int.tryParse(snapshot.data['jumla'].toString()) ?? 0 : snapshot.data)}/=",
                                            "0",
                                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                  fontSize: 12,
                                                  color: Colors.white.withOpacity(0.9),
                                                ),
                                          );
                                        } else {
                                          return Text(
                                            "Hakuna data",
                                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                  fontSize: 12,
                                                  color: Colors.white.withOpacity(0.7),
                                                ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Jengo Card
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.orange.shade600, Colors.orange.shade500],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.orange.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(Icons.home_work, color: Colors.white, size: 20),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "Jengo",
                                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      // ignore: unnecessary_type_check
                                      "Tsh ${currency.format(_getUserJengo() is num ? _getUserJengo() : 0)}",
                                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    FutureBuilder(
                                      future: getJumlaJengo(),
                                      builder: (context, AsyncSnapshot snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Container(
                                            height: 20,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.3),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          );
                                        } else if (snapshot.hasData) {
                                          return Text(
                                            // "Jumla: Tsh ${currency.format(snapshot.data is Map && snapshot.data['jumla'] != null ? int.tryParse(snapshot.data['jumla'].toString()) ?? 0 : snapshot.data)}/=",

                                            "0",
                                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                  fontSize: 12,
                                                  color: Colors.white.withOpacity(0.9),
                                                ),
                                          );
                                        } else {
                                          return Text(
                                            "Hakuna data",
                                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                  fontSize: 12,
                                                  color: Colors.white.withOpacity(0.7),
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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: MyColors.primaryLight.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.list_alt, color: MyColors.primaryLight, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Historia ya Matoleo",
                        style: Theme.of(context).textTheme.displayLarge!.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: MyColors.primaryLight,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Matoleo List
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: FutureBuilder(
                        future: getSadakaZako(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(
                              height: 300,
                              padding: const EdgeInsets.all(40),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                      'assets/animation/fetching.json',
                                      height: 120,
                                    ),
                                    const SizedBox(height: 16),
                                    Material(
                                      child: Text(
                                        "Inapanga taarifa...",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,
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
                              height: 300,
                              padding: const EdgeInsets.all(40),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset('assets/animation/nodata.json', height: 120),
                                    const SizedBox(height: 16),
                                    Material(
                                      child: Text(
                                        "Hakuna taarifa zilizopatikana",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,
                                          color: MyColors.primaryLight,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (_, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: Card(
                                      elevation: 2,
                                      shadowColor: Colors.black.withOpacity(0.1),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      color: Colors.white,
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: Colors.grey.shade100),
                                        ),
                                        child: Column(
                                          children: [
                                            // Header with date
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: MyColors.primaryLight.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Text(
                                                    "Matoleo #${index + 1}",
                                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                                          fontSize: 12,
                                                          color: MyColors.primaryLight,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade100,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade600),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        "2022-03-13",
                                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                              fontSize: 11,
                                                              color: Colors.grey.shade600,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            // Ahadi Section
                                            Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.blue.shade50,
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(color: Colors.blue.shade100),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.all(8),
                                                        decoration: BoxDecoration(
                                                          color: Colors.blue.shade100,
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Icon(Icons.handshake,
                                                            color: Colors.blue.shade700, size: 16),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Text(
                                                        "Ahadi",
                                                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                              fontSize: 15,
                                                              color: Colors.blue.shade700,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "TZS",
                                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                              fontSize: 10,
                                                              color: Colors.blue.shade600,
                                                            ),
                                                      ),
                                                      Text(
                                                        currency.format(int.tryParse(
                                                                snapshot.data![index]['ahadi']?.toString() ?? '0') ??
                                                            0),
                                                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.blue.shade700,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            // Jengo Section
                                            Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.orange.shade50,
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(color: Colors.orange.shade100),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.all(8),
                                                        decoration: BoxDecoration(
                                                          color: Colors.orange.shade100,
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Icon(Icons.home_work,
                                                            color: Colors.orange.shade700, size: 16),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Text(
                                                        "Jengo",
                                                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                              fontSize: 15,
                                                              color: Colors.orange.shade700,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "TZS",
                                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                              fontSize: 10,
                                                              color: Colors.orange.shade600,
                                                            ),
                                                      ),
                                                      Text(
                                                        currency.format(int.parse(snapshot.data![index]['jengo'])),
                                                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.orange.shade700,
                                                            ),
                                                      ),
                                                    ],
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
                              height: 200,
                              child: Center(
                                child: Text(
                                  "Hakuna data",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 16,
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
