import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:kanisaapp/admin/screens/msharika_info_card.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import 'package:lottie/lottie.dart';

class WasharikaKanisaniViongoziScreen extends StatefulWidget {
  final String isWho;
  // ignore: use_super_parameters
  const WasharikaKanisaniViongoziScreen({Key? key, required this.isWho})
      : super(key: key);

  @override
  State<WasharikaKanisaniViongoziScreen> createState() =>
      _WasharikaKanisaniViongoziScreenState();
}

class _WasharikaKanisaniViongoziScreenState
    extends State<WasharikaKanisaniViongoziScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? selectedStatus;
  // ignore: prefer_typing_uninitialized_variables
  var currentUser;
  String? selectedJumuiya;
  List<String> jumuiyaList = [];
  bool isLoading = true;
  List<MsharikaRecord> washarikaData = [];
  String searchQuery = '';
  List<MsharikaRecord> get filteredWasharikaData {
    if (searchQuery.isEmpty) return washarikaData;
    final q = searchQuery.toLowerCase();
    return washarikaData
        .where((m) =>
            m.jinaLaMsharika.toLowerCase().contains(q) ||
            m.nambaYaSimu.toLowerCase().contains(q) ||
            m.jinaLaJumuiya.toLowerCase().contains(q))
        .toList();
  }

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
          "status_value": selectedStatus,
          "status_type":
              widget.isWho == 'iskatibu' ? 'iskatibustatus' : 'ismzeestatus',
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          washarikaData = (data['data'] as List? ?? [])
              .map((item) => MsharikaRecord.fromJson(item))
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
        iconTheme: const IconThemeData(
          color: Colors.white, // 👈 makes the back button white
        ),
        title: Text(
          'Washarika wa Kanisa',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
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
      body: RefreshIndicator(
        onRefresh: _loadWasharikaData,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tafuta jina, simu au jumuiya...',
                  prefixIcon: Icon(Icons.search, color: MyColors.primaryLight),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: GoogleFonts.poppins(fontSize: 14),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              child: isLoading
                  ? Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(90.0),
                          child: Column(
                            children: [
                              SizedBox(
                                child: Lottie.asset(
                                  'assets/animation/fetching.json',
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Material(
                                child: Text(
                                  "Inapanga taarifa",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: MyColors.primaryLight,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : filteredWasharikaData.isEmpty
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
                                selectedStatus == 'yes'
                                    ? 'Hakuna washarika waliokubaliwa'
                                    : selectedStatus == 'no'
                                        ? 'Hakuna washarika waliokataliwa'
                                        : 'Hakuna washarika Wote',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredWasharikaData.length,
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            final msharika = filteredWasharikaData[index];
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
                                                // ignore: deprecated_member_use
                                                .withOpacity(0.9),
                                            // ignore: deprecated_member_use
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
                                                    const Icon(Icons.group,
                                                        color: Colors.white70,
                                                        size: 16),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      msharika.jinaLaJumuiya,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.phone,
                                                        color: Colors.white70,
                                                        size: 16),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      msharika.nambaYaSimu,
                                                      style:
                                                          GoogleFonts.poppins(
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
                                                  : msharika.katibuStatus ==
                                                          'no'
                                                      ? Colors.red.shade600
                                                      : Colors.orange.shade600,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              msharika.katibuStatus == 'yes'
                                                  ? 'Amekubaliwa'
                                                  : msharika.katibuStatus ==
                                                          'no'
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
                                      childrenPadding:
                                          const EdgeInsets.symmetric(
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
                                            MsharikaInfoCard(
                                                msharika: msharika),
                                            // _buildIconDetailRow(Icons.wc,
                                            //     'Jinsia', msharika.jinsia),
                                            // _buildIconDetailRow(Icons.cake,
                                            //     'Umri', msharika.umri),
                                            // _buildIconDetailRow(
                                            //     Icons.favorite,
                                            //     'Hali ya Ndoa',
                                            //     msharika.haliYaNdoa),
                                            // _buildIconDetailRow(
                                            //     Icons.person_outline,
                                            //     'Jina la Mwenzi',
                                            //     msharika.jinaLaMwenziWako),
                                            // _buildIconDetailRow(
                                            //     Icons.confirmation_number,
                                            //     'Namba ya Ahadi',
                                            //     msharika.nambaYaAhadi),
                                            // _buildIconDetailRow(
                                            //     Icons.family_restroom,
                                            //     'Aina ya Ndoa',
                                            //     msharika.ainaNdoa),
                                            // if (msharika
                                            //     .jinaMtoto1.isNotEmpty) ...[
                                            //   _buildIconDetailRow(
                                            //       Icons.child_care,
                                            //       'Mtoto 1',
                                            //       msharika.jinaMtoto1),
                                            //   _buildIconDetailRow(
                                            //       Icons.calendar_today,
                                            //       'Tarehe (Mtoto 1)',
                                            //       msharika.tareheMtoto1),
                                            //   _buildIconDetailRow(
                                            //       Icons.people,
                                            //       'Uhusiano (Mtoto 1)',
                                            //       msharika.uhusianoMtoto1),
                                            // ],
                                            // if (msharika
                                            //     .jinaMtoto2.isNotEmpty) ...[
                                            //   _buildIconDetailRow(
                                            //       Icons.child_care,
                                            //       'Mtoto 2',
                                            //       msharika.jinaMtoto2),
                                            //   _buildIconDetailRow(
                                            //       Icons.calendar_today,
                                            //       'Tarehe (Mtoto 2)',
                                            //       msharika.tareheMtoto2),
                                            //   _buildIconDetailRow(
                                            //       Icons.people,
                                            //       'Uhusiano (Mtoto 2)',
                                            //       msharika.uhusianoMtoto2),
                                            // ],
                                            // if (msharika
                                            //     .jinaMtoto3.isNotEmpty) ...[
                                            //   _buildIconDetailRow(
                                            //       Icons.child_care,
                                            //       'Mtoto 3',
                                            //       msharika.jinaMtoto3),
                                            //   _buildIconDetailRow(
                                            //       Icons.calendar_today,
                                            //       'Tarehe (Mtoto 3)',
                                            //       msharika.tareheMtoto3),
                                            //   _buildIconDetailRow(
                                            //       Icons.people,
                                            //       'Uhusiano (Mtoto 3)',
                                            //       msharika.uhusianoMtoto3),
                                            // ],
                                            // _buildIconDetailRow(Icons.home_work,
                                            //     'Jengo', msharika.jengo),
                                            // _buildIconDetailRow(
                                            //     Icons.monetization_on,
                                            //     'Ahadi',
                                            //     msharika.ahadi),
                                            // _buildIconDetailRow(Icons.work,
                                            //     'Kazi', msharika.kazi),
                                            // _buildIconDetailRow(Icons.school,
                                            //     'Elimu', msharika.elimu),
                                            // _buildIconDetailRow(Icons.star,
                                            //     'Ujuzi', msharika.ujuzi),
                                            // _buildIconDetailRow(
                                            //     Icons.location_city,
                                            //     'Mahali pa Kazi',
                                            //     msharika.mahaliPakazi),
                                            // _buildIconDetailRow(
                                            //     Icons.groups,
                                            //     'Jumuiya Ushiriki',
                                            //     msharika.jumuiyaUshiriki),
                                            // _buildIconDetailRow(
                                            //     Icons.person,
                                            //     'Katibu Jumuiya',
                                            //     msharika.katibuJumuiya),
                                            // _buildIconDetailRow(
                                            //     Icons.check_circle,
                                            //     'Kama Ushiriki',
                                            //     msharika.kamaUshiriki),
                                            // _buildIconDetailRow(
                                            //     Icons.date_range,
                                            //     'Tarehe ya Usajili',
                                            //     msharika.tarehe),
                                          ],
                                        ),
                                        if (msharika.katibuStatus == 'null' ||
                                            msharika.katibuStatus.isEmpty ||
                                            msharika.mzeeStatus == 'null' ||
                                            msharika.mzeeStatus.isEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12.0, bottom: 8.0),
                                            child: ElevatedButton.icon(
                                              icon: const Icon(
                                                  Icons.verified_user,
                                                  color: Colors.white),
                                              label: Text(
                                                "Kubali/Kataa Washarika",
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    MyColors.primaryLight,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 18,
                                                        vertical: 12),
                                              ),
                                              onPressed: () {
                                                _showApproveSheet(
                                                    context, msharika);
                                              },
                                            ),
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
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showApproveSheet(BuildContext context, MsharikaRecord msharika) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_user, size: 40, color: MyColors.primaryLight),
              const SizedBox(height: 12),
              Text(
                "Kubali au Kataa Washarika",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: MyColors.primaryLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                msharika.jinaLaMsharika,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: Text("Kubali",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await _updateKatibuStatus(msharika, 'yes');
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.close, color: Colors.white),
                      label: Text("Kataa",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await _updateKatibuStatus(msharika, 'no');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateKatibuStatus(
    MsharikaRecord msharika,
    String status,
  ) async {
    const url =
        "${ApiUrl.BASEURL}api2/washarika_kanisa/kukubali_kukataa_msharika_viongozi.php";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          "user_id": msharika.id,
          "status": status,
          "who": widget.isWho,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        // Optionally show a snackbar
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              status == 'yes'
                  ? 'Msharika amekubaliwa!'
                  : 'Msharika amekataliwa!',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: status == 'yes' ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
        _loadWasharikaData();
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Imeshindikana kuhifadhi mabadiliko.',
                style: GoogleFonts.poppins()),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Imeshindikana kuhifadhi mabadiliko.',
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}
