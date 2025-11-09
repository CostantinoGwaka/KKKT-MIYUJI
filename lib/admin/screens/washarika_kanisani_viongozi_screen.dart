import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kanisaapp/models/msharika_model.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import 'package:lottie/lottie.dart';

class WasharikaKanisaniViongoziScreen extends StatefulWidget {
  const WasharikaKanisaniViongoziScreen({Key? key}) : super(key: key);

  @override
  State<WasharikaKanisaniViongoziScreen> createState() =>
      _WasharikaKanisaniViongoziScreenState();
}

class _WasharikaKanisaniViongoziScreenState
    extends State<WasharikaKanisaniViongoziScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? selectedStatus;
  var currentUser;
  String? selectedJumuiya;
  List<String> jumuiyaList = [];
  bool isLoading = true;
  List<MsharikaData> washarikaData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var user = await UserManager.getCurrentUser();
    setState(() {
      currentUser = user;
    });
    _loadWasharikaData();
  }

  Future<void> _loadWasharikaData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/washarika_kanisa/get_washarika_kanisa_kwa_viongozi.php"),
        body: jsonEncode({
          "jumuiya_id": currentUser.msharikaRecords.isNotEmpty
              ? (currentUser as BaseUser).msharikaRecords[0].idYaJumuiya
              : 'N/A',
          "katibu_status": selectedStatus,
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          washarikaData = (data['data'] as List? ?? [])
              .map((item) => MsharikaData.fromJson(item))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          washarikaData = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        washarikaData = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primaryLight,
        title: Text(
          'Washarika wa Kanisa',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                'Wote',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Waliokubaliwa',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Waliokataliwa',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                ),
              ),
            ),
          ],
          onTap: (index) {
            setState(() {
              switch (index) {
                case 0:
                  selectedStatus = 'null';
                  break;
                case 1:
                  selectedStatus = 'yes';
                  break;
                case 2:
                  selectedStatus = 'no';
                  break;
              }
              _loadWasharikaData();
            });
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/animation/loading.json',
                          height: 120,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Inapakia...',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : washarikaData.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              size: 64,
                              color: Colors.orange.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Hakuna washarika waliokubaliwa',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: washarikaData.length,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          final msharika = washarikaData[index];
                          return Card(
                              elevation: 4,
                              margin: const EdgeInsets.only(bottom: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          MyColors.primaryLight
                                              .withOpacity(0.9),
                                          Colors.blueAccent.withOpacity(0.7),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(18),
                                        topRight: Radius.circular(18),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18, horizontal: 18),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.person,
                                            color: MyColors.primaryLight,
                                            size: 32,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                msharika.jinaLaMsharika,
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(Icons.group,
                                                      color: Colors.white70,
                                                      size: 16),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    msharika.jinaLaJumuiya,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.phone,
                                                      color: Colors.white70,
                                                      size: 16),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    msharika.nambaYaSimu,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: msharika.katibuStatus ==
                                                    'yes'
                                                ? Colors.green.shade600
                                                : msharika.katibuStatus == 'no'
                                                    ? Colors.red.shade600
                                                    : Colors.orange.shade600,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            msharika.katibuStatus == 'yes'
                                                ? 'Amekubaliwa'
                                                : msharika.katibuStatus == 'no'
                                                    ? 'Amekataliwa'
                                                    : 'Haijashughulikiwa',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ExpansionTile(
                                    tilePadding: const EdgeInsets.symmetric(
                                        horizontal: 18),
                                    childrenPadding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 8),
                                    title: Row(
                                      children: [
                                        Icon(Icons.info_outline,
                                            color: MyColors.primaryLight,
                                            size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Taarifa za Washarika",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: MyColors.primaryLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                    children: [
                                      Wrap(
                                        runSpacing: 8,
                                        children: [
                                          _buildIconDetailRow(Icons.wc,
                                              'Jinsia', msharika.jinsia),
                                          _buildIconDetailRow(Icons.cake,
                                              'Umri', msharika.umri),
                                          _buildIconDetailRow(
                                              Icons.favorite,
                                              'Hali ya Ndoa',
                                              msharika.haliYaNdoa),
                                          _buildIconDetailRow(
                                              Icons.person_outline,
                                              'Jina la Mwenzi',
                                              msharika.jinaLaMwenziWako),
                                          _buildIconDetailRow(
                                              Icons.confirmation_number,
                                              'Namba ya Ahadi',
                                              msharika.nambaYaAhadi),
                                          _buildIconDetailRow(
                                              Icons.family_restroom,
                                              'Aina ya Ndoa',
                                              msharika.ainaNdoa),
                                          if (msharika
                                              .jinaMtoto1.isNotEmpty) ...[
                                            _buildIconDetailRow(
                                                Icons.child_care,
                                                'Mtoto 1',
                                                msharika.jinaMtoto1),
                                            _buildIconDetailRow(
                                                Icons.calendar_today,
                                                'Tarehe (Mtoto 1)',
                                                msharika.tareheMtoto1),
                                            _buildIconDetailRow(
                                                Icons.people,
                                                'Uhusiano (Mtoto 1)',
                                                msharika.uhusianoMtoto1),
                                          ],
                                          if (msharika
                                              .jinaMtoto2.isNotEmpty) ...[
                                            _buildIconDetailRow(
                                                Icons.child_care,
                                                'Mtoto 2',
                                                msharika.jinaMtoto2),
                                            _buildIconDetailRow(
                                                Icons.calendar_today,
                                                'Tarehe (Mtoto 2)',
                                                msharika.tareheMtoto2),
                                            _buildIconDetailRow(
                                                Icons.people,
                                                'Uhusiano (Mtoto 2)',
                                                msharika.uhusianoMtoto2),
                                          ],
                                          if (msharika
                                              .jinaMtoto3.isNotEmpty) ...[
                                            _buildIconDetailRow(
                                                Icons.child_care,
                                                'Mtoto 3',
                                                msharika.jinaMtoto3),
                                            _buildIconDetailRow(
                                                Icons.calendar_today,
                                                'Tarehe (Mtoto 3)',
                                                msharika.tareheMtoto3),
                                            _buildIconDetailRow(
                                                Icons.people,
                                                'Uhusiano (Mtoto 3)',
                                                msharika.uhusianoMtoto3),
                                          ],
                                          _buildIconDetailRow(Icons.home_work,
                                              'Jengo', msharika.jengo),
                                          _buildIconDetailRow(
                                              Icons.monetization_on,
                                              'Ahadi',
                                              msharika.ahadi),
                                          _buildIconDetailRow(Icons.work,
                                              'Kazi', msharika.kazi),
                                          _buildIconDetailRow(Icons.school,
                                              'Elimu', msharika.elimu),
                                          _buildIconDetailRow(Icons.star,
                                              'Ujuzi', msharika.ujuzi),
                                          _buildIconDetailRow(
                                              Icons.location_city,
                                              'Mahali pa Kazi',
                                              msharika.mahaliPakazi),
                                          _buildIconDetailRow(
                                              Icons.groups,
                                              'Jumuiya Ushiriki',
                                              msharika.jumuiyaUshiriki),
                                          _buildIconDetailRow(
                                              Icons.person,
                                              'Katibu Jumuiya',
                                              msharika.katibuJumuiya),
                                          _buildIconDetailRow(
                                              Icons.check_circle,
                                              'Kama Ushiriki',
                                              msharika.kamaUshiriki),
                                          _buildIconDetailRow(
                                              Icons.date_range,
                                              'Tarehe ya Usajili',
                                              msharika.tarehe),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ));
                        },
                      ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildDetailRow(String label, String value) {
    if (value.isEmpty || value == 'N/A') return Container();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconDetailRow(IconData icon, String label, String value) {
    if (value.isEmpty || value == 'N/A') return Container();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: MyColors.primaryLight),
          const SizedBox(width: 8),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
