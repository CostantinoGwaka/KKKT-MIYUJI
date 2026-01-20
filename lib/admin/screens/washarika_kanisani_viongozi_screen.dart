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
            m.jinaLaJumuiya.toLowerCase().contains(q) ||
            m.nambaYaAhadi.toLowerCase().contains(q))
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
                  hintText: 'Tafuta jina, simu, namba ya ahadi au jumuiya...',
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
                                                  '${msharika.jinaLaMsharika} - (${msharika.nambaYaAhadi})',
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
                                              msharika: msharika,
                                            ),
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
                                        if (msharika.katibuStatus == 'yes')
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, bottom: 6.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton.icon(
                                                    icon: const Icon(
                                                        Icons.add_circle,
                                                        color: Colors.white,
                                                        size: 18),
                                                    label: Text(
                                                      "Ongeza Sadaka",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.green,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 14,
                                                          vertical: 10),
                                                    ),
                                                    onPressed: () {
                                                      _showAddSadakaSheet(
                                                          context, msharika);
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: ElevatedButton.icon(
                                                    icon: const Icon(
                                                        Icons.list_alt,
                                                        color: Colors.white,
                                                        size: 18),
                                                    label: Text(
                                                      "Tazama Sadaka",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          MyColors.primaryLight,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 14,
                                                          vertical: 10),
                                                    ),
                                                    onPressed: () {
                                                      _showSadakaList(
                                                          context, msharika);
                                                    },
                                                  ),
                                                ),
                                              ],
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

  void _showAddSadakaSheet(BuildContext context, MsharikaRecord msharika) {
    final TextEditingController nambaController = TextEditingController()
      ..text = msharika.nambaYaAhadi;
    final TextEditingController ahadiController = TextEditingController();
    final TextEditingController jengoController = TextEditingController();
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 18.0,
                right: 18.0,
                top: 18.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 18.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_circle,
                        size: 36, color: MyColors.primaryLight),
                    const SizedBox(height: 10),
                    Text(
                      "Ongeza Sadaka",
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
                    TextField(
                      controller: nambaController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Namba (mfano: SD-001)',
                        labelStyle: GoogleFonts.poppins(fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.numbers,
                            color: MyColors.primaryLight, size: 20),
                      ),
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: ahadiController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Ahadi (TZS)',
                        labelStyle: GoogleFonts.poppins(fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.attach_money,
                            color: MyColors.primaryLight, size: 20),
                      ),
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: jengoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Jengo (TZS)',
                        labelStyle: GoogleFonts.poppins(fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.home_work,
                            color: MyColors.primaryLight, size: 20),
                      ),
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.save,
                                color: Colors.white, size: 18),
                        label: Text(
                          isLoading ? "Inahifadhi..." : "Hifadhi Sadaka",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (nambaController.text.isEmpty ||
                                    ahadiController.text.isEmpty ||
                                    jengoController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Tafadhali jaza sehemu zote',
                                        style: GoogleFonts.poppins(),
                                      ),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }

                                setModalState(() {
                                  isLoading = true;
                                });

                                try {
                                  final response = await http.post(
                                    Uri.parse(
                                        "${ApiUrl.BASEURL}api2/sadaka/ongeza_sadaka_kwa_user.php"),
                                    body: jsonEncode({
                                      "namba": nambaController.text,
                                      "user_id": msharika.id,
                                      "ahadi": int.parse(ahadiController.text),
                                      "jengo": int.parse(jengoController.text),
                                      "kanisa_id": currentUser?.kanisaId ?? '',
                                    }),
                                    headers: {
                                      'Content-Type': 'application/json'
                                    },
                                  );

                                  setModalState(() {
                                    isLoading = false;
                                  });

                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(ctx);

                                  if (response.statusCode == 200) {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Sadaka imehifadhiwa!',
                                          style: GoogleFonts.poppins(),
                                        ),
                                        backgroundColor: Colors.green,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Imeshindikana kuhifadhi sadaka',
                                          style: GoogleFonts.poppins(),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  setModalState(() {
                                    isLoading = false;
                                  });
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(ctx);
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Kosa limetokea: $e',
                                        style: GoogleFonts.poppins(),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSadakaList(BuildContext context, MsharikaRecord msharika) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );

    try {
      final response = await http.post(
        Uri.parse("${ApiUrl.BASEURL}api2/sadaka/get_sadaka_kwa_user.php"),
        body: jsonEncode({"user_id": msharika.id}),
        headers: {'Content-Type': 'application/json'},
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Close loading dialog

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final sadakaList = data['data'] as List? ?? [];

        // ignore: use_build_context_synchronously
        showModalBottomSheet(
          // ignore: use_build_context_synchronously
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (ctx) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                String searchQuery = '';

                List<dynamic> filteredSadakaList = sadakaList.where((sadaka) {
                  if (searchQuery.isEmpty) return true;
                  final query = searchQuery.toLowerCase();
                  return (sadaka['namba']
                              ?.toString()
                              .toLowerCase()
                              .contains(query) ??
                          false) ||
                      (sadaka['ahadi']
                              ?.toString()
                              .toLowerCase()
                              .contains(query) ??
                          false) ||
                      (sadaka['jengo']
                              ?.toString()
                              .toLowerCase()
                              .contains(query) ??
                          false) ||
                      (sadaka['tarehe']
                              ?.toString()
                              .toLowerCase()
                              .contains(query) ??
                          false);
                }).toList();

                return DraggableScrollableSheet(
                  initialChildSize: 0.7,
                  minChildSize: 0.5,
                  maxChildSize: 0.95,
                  expand: false,
                  builder: (context, scrollController) {
                    return Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.list_alt,
                              size: 36, color: MyColors.primaryLight),
                          const SizedBox(height: 10),
                          Text(
                            "Sadaka za ${msharika.jinaLaMsharika}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: MyColors.primaryLight,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Search field
                          TextField(
                            decoration: InputDecoration(
                              hintText:
                                  'Tafuta namba, ahadi, jengo au tarehe...',
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
                              setModalState(() {
                                searchQuery = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: filteredSadakaList.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          searchQuery.isEmpty
                                              ? Icons.inbox_outlined
                                              : Icons.search_off_rounded,
                                          size: 56,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          searchQuery.isEmpty
                                              ? 'Hakuna sadaka zilizorekodiwa'
                                              : 'Hakuna matokeo yaliyopatikana',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    controller: scrollController,
                                    itemCount: filteredSadakaList.length,
                                    itemBuilder: (context, index) {
                                      final sadaka = filteredSadakaList[index];
                                      return Card(
                                        elevation: 4,
                                        margin:
                                            const EdgeInsets.only(bottom: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
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
                                              // Header section with gradient
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 14),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      MyColors.primaryLight,
                                                      MyColors.primaryLight
                                                          // ignore: deprecated_member_use
                                                          .withOpacity(0.8),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(16),
                                                    topRight:
                                                        Radius.circular(16),
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
                                                                // ignore: deprecated_member_use
                                                                .withOpacity(
                                                                    0.3),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: const Icon(
                                                            Icons
                                                                .receipt_long_rounded,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 12),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              sadaka['namba'] ??
                                                                  'N/A',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                                letterSpacing:
                                                                    0.5,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Namba ya Sadaka',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .white
                                                                    // ignore: deprecated_member_use
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
                                                            // ignore: deprecated_member_use
                                                            .withOpacity(0.25),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        border: Border.all(
                                                          color: Colors.white
                                                              // ignore: deprecated_member_use
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
                                                            color: Colors.white,
                                                            size: 12,
                                                          ),
                                                          const SizedBox(
                                                              width: 6),
                                                          Text(
                                                            sadaka['tarehe'] ??
                                                                '',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.white,
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
                                              // Content section
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Row(
                                                  children: [
                                                    // Ahadi section
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(14),
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                            colors: [
                                                              Colors.green
                                                                  .shade50,
                                                              Colors.green
                                                                  .shade100
                                                                  // ignore: deprecated_member_use
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
                                                                          .all(
                                                                          6),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .green
                                                                        .shade600,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .handshake_rounded,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 16,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 8),
                                                                Text(
                                                                  'Ahadi',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .green
                                                                        .shade700,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'TZS ${sadaka['ahadi'] ?? '0'}',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 16,
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
                                                    // Jengo section
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(14),
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                            colors: [
                                                              Colors
                                                                  .blue.shade50,
                                                              Colors
                                                                  .blue.shade100
                                                                  // ignore: deprecated_member_use
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
                                                                          .all(
                                                                          6),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .blue
                                                                        .shade600,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .home_work_rounded,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 16,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 8),
                                                                Text(
                                                                  'Jengo',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .blue
                                                                        .shade700,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'TZS ${sadaka['jengo'] ?? '0'}',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 16,
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
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Imeshindikana kupata taarifa za sadaka',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Close loading dialog
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Kosa limetokea: $e',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
