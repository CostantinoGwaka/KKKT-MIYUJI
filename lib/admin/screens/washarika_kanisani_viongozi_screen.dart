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

    print((currentUser as BaseUser).msharikaRecords[0].idYaJumuiya);

    try {
      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/washarika_kanisa/get_washarika_kanisa_kwa_viongozi.php"),
        body: jsonEncode({
          "jumuiya_id": currentUser.msharikaRecords.isNotEmpty
              ? (currentUser as BaseUser).msharikaRecords[0].idYaJumuiya
              : 'N/A',
          "katibu_status": selectedStatus ?? 'yes',
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
      print('Error loading washarika data: $e');
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
          tabs: const [
            Tab(text: 'Wote'),
            Tab(text: 'Waliokubaliwa'),
            Tab(text: 'Waliokataliwa'),
          ],
          onTap: (index) {
            setState(() {
              switch (index) {
                case 0:
                  selectedStatus = null;
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
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.all(16),
                              title: Text(
                                msharika.jinaLaMsharika,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    'Jumuiya: ${msharika.jinaLaJumuiya}',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  Text(
                                    'Namba ya Simu: ${msharika.nambaYaSimu}',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: msharika.katibuStatus == 'yes'
                                          ? Colors.green.shade100
                                          : msharika.katibuStatus == 'no'
                                              ? Colors.red.shade100
                                              : Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      msharika.katibuStatus == 'yes'
                                          ? 'Amekubaliwa'
                                          : msharika.katibuStatus == 'no'
                                              ? 'Amekataliwa'
                                              : 'Haijashughulikiwa',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: msharika.katibuStatus == 'yes'
                                            ? Colors.green.shade700
                                            : msharika.katibuStatus == 'no'
                                                ? Colors.red.shade700
                                                : Colors.orange.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailRow(
                                          'Jinsia', msharika.jinsia),
                                      _buildDetailRow('Umri', msharika.umri),
                                      _buildDetailRow(
                                          'Hali ya Ndoa', msharika.haliYaNdoa),
                                      _buildDetailRow('Jina la Mwenzi',
                                          msharika.jinaLaMwenziWako),
                                      _buildDetailRow('Namba ya Ahadi',
                                          msharika.nambaYaAhadi),
                                      _buildDetailRow(
                                          'Aina ya Ndoa', msharika.ainaNdoa),
                                      if (msharika.jinaMtoto1.isNotEmpty) ...[
                                        _buildDetailRow(
                                            'Mtoto 1', msharika.jinaMtoto1),
                                        _buildDetailRow('Tarehe (Mtoto 1)',
                                            msharika.tareheMtoto1),
                                        _buildDetailRow('Uhusiano (Mtoto 1)',
                                            msharika.uhusianoMtoto1),
                                      ],
                                      if (msharika.jinaMtoto2.isNotEmpty) ...[
                                        _buildDetailRow(
                                            'Mtoto 2', msharika.jinaMtoto2),
                                        _buildDetailRow('Tarehe (Mtoto 2)',
                                            msharika.tareheMtoto2),
                                        _buildDetailRow('Uhusiano (Mtoto 2)',
                                            msharika.uhusianoMtoto2),
                                      ],
                                      if (msharika.jinaMtoto3.isNotEmpty) ...[
                                        _buildDetailRow(
                                            'Mtoto 3', msharika.jinaMtoto3),
                                        _buildDetailRow('Tarehe (Mtoto 3)',
                                            msharika.tareheMtoto3),
                                        _buildDetailRow('Uhusiano (Mtoto 3)',
                                            msharika.uhusianoMtoto3),
                                      ],
                                      _buildDetailRow('Jengo', msharika.jengo),
                                      _buildDetailRow('Ahadi', msharika.ahadi),
                                      _buildDetailRow('Kazi', msharika.kazi),
                                      _buildDetailRow('Elimu', msharika.elimu),
                                      _buildDetailRow('Ujuzi', msharika.ujuzi),
                                      _buildDetailRow('Mahali pa Kazi',
                                          msharika.mahaliPakazi),
                                      _buildDetailRow('Jumuiya Ushiriki',
                                          msharika.jumuiyaUshiriki),
                                      _buildDetailRow('Katibu Jumuiya',
                                          msharika.katibuJumuiya),
                                      _buildDetailRow('Kama Ushiriki',
                                          msharika.kamaUshiriki),
                                      _buildDetailRow(
                                          'Tarehe ya Usajili', msharika.tarehe),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
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
}
