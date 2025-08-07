// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, prefer_typing_uninitialized_variables, deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/models/viongozi_wakanisa.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:http/http.dart' as http;
import 'package:kanisaapp/utils/user_manager.dart';
import 'package:lottie/lottie.dart';

class ViongoziWaKanisa extends StatefulWidget {
  const ViongoziWaKanisa({super.key});

  @override
  _ViongoziWaKanisaState createState() => _ViongoziWaKanisaState();
}

class _ViongoziWaKanisaState extends State<ViongoziWaKanisa> {
   BaseUser? currentUser;

  Future<void> _loadCurrentUser() async {
    try {
      currentUser = await UserManager.getCurrentUser();
      setState(() {});
    } catch (e) {
      // Handle error
    }
  }
  Future<List<ViongoziWaKanisaData>> getViongozi() async {
    String myApi = "${ApiUrl.BASEURL}get_viongozi_wakanisa.php";
    final response = await http.post(Uri.parse(myApi), headers: {'Accept': 'application/json'},
     body: jsonEncode({
        "kanisa_id": currentUser != null ? currentUser!.kanisaId : '',
      }),);

    List<ViongoziWaKanisaData> baraza = [];

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
         var json = jsonDecode(response.body);
         if (json is Map && json.containsKey('data') && json['data'] != null && json['data'] is List) {
          baraza = (json['data'] as List).map((item) => ViongoziWaKanisaData.fromJson(item)).toList();
        }
      }
    }
    return baraza;
  }

  Future<void> _pullRefresh() async {
    getViongozi().then((value) {
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
    getViongozi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
        child: SafeArea(
          child: Column(
            children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 2, 17, 25),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Viongozi Wa Kanisa",
                                style: GoogleFonts.montserrat(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.primaryLight,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Orodha ya viongozi wote",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: MyColors.primaryLight.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child:  Icon(
                              Icons.group,
                              color: MyColors.primaryLight,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _pullRefresh,
                    child: FutureBuilder<List<ViongoziWaKanisaData>>(
                      future: getViongozi(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  'assets/animation/fetching.json',
                                  height: 120,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Inapanga taarifa...",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
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
                                Lottie.asset(
                                  'assets/animation/nodata.json',
                                  height: 120,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Hakuna taarifa zilizopatikana",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.primaryLight,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.hasData) {
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                MyColors.primaryLight.withOpacity(0.2),
                                                MyColors.primaryLight.withOpacity(0.1),
                                              ],
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius: 30,
                                            backgroundColor: MyColors.primaryLight.withOpacity(0.1),
                                            child: Image.asset(
                                              "assets/images/useravatar.png",
                                              height: 40,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                            snapshot.data![index].fname!,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                              height: 1.2,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 6),
                                            Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  MyColors.primaryLight.withOpacity(0.2),
                                                  MyColors.primaryLight.withOpacity(0.1),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  size: 14,
                                                  color: MyColors.primaryLight.withOpacity(0.7),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  snapshot.data![index].wadhifa!,
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: MyColors.primaryLight,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
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
                            },
                          );
                        } else {
                          return const Center(child: Text("Error occurred"));
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
