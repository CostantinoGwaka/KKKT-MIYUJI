// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api,              ),, deprecated_member_use, deprecated_member_use, deprecated_member_use, deprecated_member_use, deprecated_member_use
// ignore: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kanisaapp/jumuiyazetu/screens/viongozi_wajumuiya_screen.dart';
import 'package:kanisaapp/models/Jumuiya.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/TextStyles.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/spacer.dart';

import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class JumuiyaZetu extends StatefulWidget {
  const JumuiyaZetu({super.key});

  @override
  _JumuiyaZetuState createState() => _JumuiyaZetuState();
}

class _JumuiyaZetuState extends State<JumuiyaZetu> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  Future<List<JumuiyaData>> getJumuiya() async {
    String myApi = "${ApiUrl.BASEURL}getjumuiya.php";
    final response = await http.post(Uri.parse(myApi),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "kanisa_id": '1',
        }));

    var barazaList = <JumuiyaData>[];

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        if (json is Map &&
            json.containsKey('data') &&
            json['data'] != null &&
            json['data'] is List) {
          barazaList = (json['data'] as List)
              .map((item) => JumuiyaData.fromJson(item))
              .toList();
        }
      }
    }
    return barazaList;
  }

  Future<void> _pullRefresh() async {
    getJumuiya().then((value) {
      setState(() {
        //finish
      });
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back_ios, size: 20),
          onTap: () {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitDown,
              DeviceOrientation.portraitUp,
            ]);
            Navigator.pop(context);
          },
        ),
        middle: Text(
          "Jumuiya Zetu",
          style: TextStyles.headline(context).copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: MyColors.primaryLight,
          ),
        ),
      ),
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: CupertinoSearchTextField(
                controller: searchController,
                placeholder: 'Tafuta jumuiya...',
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _pullRefresh,
                child: StreamBuilder(
                  //Error number 2
                  stream: getJumuiya().asStream(),
                  builder:
                      (context, AsyncSnapshot<List<JumuiyaData>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(60.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      child: Lottie.asset(
                                        'assets/animation/fetching.json',
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Material(
                                      child: Text(
                                        "Inapanga taarifa",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11.0,
                                          color: MyColors.primaryLight,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return RefreshIndicator(
                        onRefresh: _pullRefresh,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    child: Lottie.asset(
                                      'assets/animation/nodata.json',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  const Text(
                                    "Hakuna taarifa zi",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11.0,
                                        color: Colors.black38),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final filteredData = snapshot.data!
                          .where((jumuiya) => jumuiya.jumuiyaName!
                              .toLowerCase()
                              .contains(searchQuery))
                          .toList();
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredData.length,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 4.0),
                            child: Material(
                              elevation: 2,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ViongoziJumuiya(
                                        jumuiya: filteredData[index],
                                      ),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      colors: [
                                        // ignore: deprecated_member_use
                                        MyColors.primaryLight.withOpacity(0.05),
                                        Colors.white,
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    border: Border.all(
                                      color: MyColors.primaryLight
                                          .withValues(alpha: 0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 6,
                                        decoration: BoxDecoration(
                                          color: MyColors.primaryLight,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                filteredData[index]
                                                    .jumuiyaName!,
                                                style: TextStyle(
                                                  color: MyColors.primaryLight,
                                                  fontSize:
                                                      deviceHeight(context) /
                                                          45,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              manualStepper(
                                                  step: deviceWidth(context) ~/
                                                      50),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: MyColors.primaryLight
                                              .withValues(alpha: 0.5),
                                          size: 16,
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
      )),
    );
  }
}
