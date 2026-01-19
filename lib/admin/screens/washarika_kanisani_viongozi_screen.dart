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
            fontSize: 16,
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
                  fontSize: MediaQuery.of(context).size.width * 0.028,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Waliokubaliwa',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.028,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Waliokataliwa',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.028,
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
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tafuta jina, simu au jumuiya...',
                  prefixIcon: Icon(Icons.search,
                      color: MyColors.primaryLight, size: 20),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
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
            ),
            Expanded(
              child: isLoading
                  ? Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(70.0),
                          child: Column(
                            children: [
                              SizedBox(
                                child: Lottie.asset(
                                  'assets/animation/fetching.json',
                                ),
                              ),
                              const SizedBox(
                                height: 16,
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
                    )
                  : filteredWasharikaData.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                size: 56,
                                color: Colors.orange.shade300,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                selectedStatus == 'yes'
                                    ? 'Hakuna washarika waliokubaliwa'
                                    : selectedStatus == 'no'
                                        ? 'Hakuna washarika waliokataliwa'
                                        : 'Hakuna washarika Wote',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredWasharikaData.length,
                          padding: const EdgeInsets.all(12),
                          itemBuilder: (context, index) {
                            final msharika = filteredWasharikaData[index];
                            return Card(
                                elevation: 3,
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
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
                                          topLeft: Radius.circular(14),
                                          topRight: Radius.circular(14),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 12),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 22,
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.person,
                                              color: MyColors.primaryLight,
                                              size: 26,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  msharika.jinaLaMsharika,
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.group,
                                                        color: Colors.white70,
                                                        size: 14),
                                                    const SizedBox(width: 3),
                                                    Text(
                                                      msharika.jinaLaJumuiya,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.phone,
                                                        color: Colors.white70,
                                                        size: 14),
                                                    const SizedBox(width: 3),
                                                    Text(
                                                      msharika.nambaYaSimu,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 12,
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
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: msharika.katibuStatus ==
                                                      'yes'
                                                  ? Colors.green.shade600
                                                  : msharika.katibuStatus ==
                                                          'no'
                                                      ? Colors.red.shade600
                                                      : Colors.orange.shade600,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              msharika.katibuStatus == 'yes'
                                                  ? 'Amekubaliwa'
                                                  : msharika.katibuStatus ==
                                                          'no'
                                                      ? 'Amekataliwa'
                                                      : 'Haijashughulikiwa',
                                              style: GoogleFonts.poppins(
                                                fontSize: 10,
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
                                          horizontal: 12),
                                      childrenPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                      title: Row(
                                        children: [
                                          Icon(Icons.info_outline,
                                              color: MyColors.primaryLight,
                                              size: 18),
                                          const SizedBox(width: 6),
                                          Text(
                                            "Taarifa za Msharika",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: MyColors.primaryLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                      children: [
                                        Wrap(
                                          runSpacing: 6,
                                          children: [
                                            MsharikaInfoCard(
                                                msharika: msharika),
                                          ],
                                        ),
                                        if (msharika.katibuStatus == 'null' ||
                                            msharika.katibuStatus.isEmpty ||
                                            msharika.mzeeStatus == 'null' ||
                                            msharika.mzeeStatus.isEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, bottom: 6.0),
                                            child: ElevatedButton.icon(
                                              icon: const Icon(
                                                  Icons.verified_user,
                                                  color: Colors.white,
                                                  size: 18),
                                              label: Text(
                                                "Kubali/Kataa Washarika",
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    MyColors.primaryLight,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14,
                                                        vertical: 10),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_user, size: 36, color: MyColors.primaryLight),
              const SizedBox(height: 10),
              Text(
                "Kubali au Kataa Washarika",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: MyColors.primaryLight,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                msharika.jinaLaMsharika,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check,
                          color: Colors.white, size: 18),
                      label: Text("Kubali",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await _updateKatibuStatus(msharika, 'yes');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 18),
                      label: Text("Kataa",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
