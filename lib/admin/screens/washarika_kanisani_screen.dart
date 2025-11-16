// ignore_for_file: depend_on_referenced_packages, use_super_parameters, use_build_context_synchronously, deprecated_member_use, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kanisaapp/admin/screens/msharika_info_card.dart';
import 'package:kanisaapp/admin/screens/ongeza_kanisa_screen.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import 'package:kanisaapp/admin/screens/edit_msharika_screen.dart';

class WasharikaKanisaniScreen extends StatefulWidget {
  const WasharikaKanisaniScreen({Key? key}) : super(key: key);

  @override
  _WasharikaKanisaniScreenState createState() =>
      _WasharikaKanisaniScreenState();
}

class _WasharikaKanisaniScreenState extends State<WasharikaKanisaniScreen> {
  List<MsharikaRecord> washarika = [];
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();
  BaseUser? currentUser;
  final TextEditingController _searchController = TextEditingController();

  // Form controllers
  final _jinaController = TextEditingController();
  final _jinsiaController = TextEditingController();
  final _umriController = TextEditingController();
  final _haliYaNdoaController = TextEditingController();
  final _jinaLaMwenziController = TextEditingController();
  final _nambaYaAhadiController = TextEditingController();
  final _ainaNdoaController = TextEditingController();
  final _nambaSimuController = TextEditingController();
  final _jengoController = TextEditingController();
  final _ahadiController = TextEditingController();
  final _kaziController = TextEditingController();
  final _elimuController = TextEditingController();
  final _ujuziController = TextEditingController();
  final _mahaliPakaziController = TextEditingController();
  final _jumuiyaController = TextEditingController();
  final _jinaMtoto1Controller = TextEditingController();
  final _tareheMtoto1Controller = TextEditingController();
  final _uhusianoMtoto1Controller = TextEditingController();
  final _jinaMtoto2Controller = TextEditingController();
  final _tareheMtoto2Controller = TextEditingController();
  final _uhusianoMtoto2Controller = TextEditingController();
  final _jinaMtoto3Controller = TextEditingController();
  final _tareheMtoto3Controller = TextEditingController();
  final _uhusianoMtoto3Controller = TextEditingController();
  final _jumuiyaUshirikiController = TextEditingController();
  final _idYaJumuiyaController = TextEditingController();
  final _katibuJumuiyaController = TextEditingController();
  final _kamaUshirikiController = TextEditingController();
  final _katibuStatusController = TextEditingController();
  final _mzeeStatusController = TextEditingController();
  final _usharikaStatusController = TextEditingController();
  final _regYearIdController = TextEditingController();
  final _tareheController = TextEditingController();
  final _passwordController = TextEditingController();
  final _jinaLaJumuiyaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchWasharika();
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
          "who": 'ismsharika',
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        // Optionally show a snackbar
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
        fetchWasharika();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Imeshindikana kuhifadhi mabadiliko.',
                style: GoogleFonts.poppins()),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Imeshindikana kuhifadhi mabadiliko.',
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> fetchWasharika() async {
    BaseUser? user = await UserManager.getCurrentUser();
    // print(user);
    setState(() {
      currentUser = user;
    });
    try {
      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/washarika_kanisa/get_washarika_kanisa.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        setState(() {
          washarika =
              data.map((json) => MsharikaRecord.fromJson(json)).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorSnackbar('Failed to load washarika data');
    }
  }

  Future<void> addMsharika() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final response = await http.post(
        Uri.parse("${ApiUrl.BASEURL}add_msharika.php"),
        body: {
          'id': '', // New record, no ID
          'jina_la_msharika': _jinaController.text,
          'jinsia': _jinsiaController.text,
          'umri': _umriController.text,
          'hali_ya_ndoa': _haliYaNdoaController.text,
          'jina_la_mwenzi_wako': _jinaLaMwenziController.text,
          'namba_ya_ahadi': _nambaYaAhadiController.text,
          'aina_ya_ndoa': _ainaNdoaController.text,
          'jina_mtoto_1': _jinaMtoto1Controller.text,
          'tarehe_mtoto_1': _tareheMtoto1Controller.text,
          'uhusiano_mtoto_1': _uhusianoMtoto1Controller.text,
          'jina_mtoto_2': _jinaMtoto2Controller.text,
          'tarehe_mtoto_2': _tareheMtoto2Controller.text,
          'uhusiano_mtoto_2': _uhusianoMtoto2Controller.text,
          'jina_mtoto_3': _jinaMtoto3Controller.text,
          'tarehe_mtoto_3': _tareheMtoto3Controller.text,
          'uhusiano_mtoto_3': _uhusianoMtoto3Controller.text,
          'namba_ya_simu': _nambaSimuController.text,
          'jengo': _jengoController.text,
          'ahadi': _ahadiController.text,
          'kazi': _kaziController.text,
          'elimu': _elimuController.text,
          'ujuzi': _ujuziController.text,
          'mahali_pakazi': _mahaliPakaziController.text,
          'jumuiya_ushiriki': _jumuiyaUshirikiController.text,
          'jina_la_jumuiya': _jinaLaJumuiyaController.text,
          'id_ya_jumuiya': _idYaJumuiyaController.text,
          'katibu_jumuiya': _katibuJumuiyaController.text,
          'kama_ushiriki': _kamaUshirikiController.text,
          'katibu_status': _katibuStatusController.text,
          'mzee_status': _mzeeStatusController.text,
          'usharika_status': _usharikaStatusController.text,
          'reg_year_id': _regYearIdController.text,
          'tarehe': _tareheController.text,
          'kanisa_id': currentUser?.kanisaId ?? '',
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        fetchWasharika();
        _showSuccessSnackbar('Msharika added successfully');
      } else {
        _showErrorSnackbar('Failed to add msharika');
      }
    } catch (e) {
      _showErrorSnackbar('Error occurred while adding msharika');
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: MyColors.primaryLight,
        elevation: 0,
        iconTheme:
            const IconThemeData(color: Colors.white), // Makes back arrow white
        title: Text(
          'Washarika',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchWasharika,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MyColors.primaryLight,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search washarika...',
                hintStyle: GoogleFonts.poppins(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
              ),
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    fetchWasharika();
                  } else {
                    washarika = washarika.where((msharika) {
                      return msharika.jinaLaMsharika
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          msharika.nambaYaAhadi
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          msharika.jinaLaJumuiya
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          msharika.nambaYaSimu
                              .toLowerCase()
                              .contains(value.toLowerCase());
                    }).toList();
                  }
                });
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.black,
                      ),
                    ),
                  )
                : washarika.isEmpty
                    ? Center(
                        child: Text(
                          'No washarika found',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: washarika.length,
                        itemBuilder: (context, index) {
                          final msharika = washarika[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 4),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              childrenPadding: const EdgeInsets.all(20),
                              leading: CircleAvatar(
                                backgroundColor: MyColors.primaryLight,
                                radius: 25,
                                child: Text(
                                  msharika.jinaLaMsharika[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                msharika.jinaLaMsharika,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.confirmation_number,
                                          size: 16,
                                          color: MyColors.primaryLight
                                              .withOpacity(0.7)),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Namba ya Ahadi: ${msharika.nambaYaAhadi}',
                                        style:
                                            GoogleFonts.poppins(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.group,
                                        size: 16,
                                        color: MyColors.primaryLight
                                            .withOpacity(0.7),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Jumuiya: ${msharika.jinaLaJumuiya}',
                                        style:
                                            GoogleFonts.poppins(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.group,
                                        size: 16,
                                        color: MyColors.primaryLight
                                            .withOpacity(0.7),
                                      ),
                                      const SizedBox(width: 4),
                                      Row(
                                        children: [
                                          Text(
                                            'Hali: ',
                                            style: GoogleFonts.poppins(
                                                fontSize: 12),
                                          ),
                                          Text(
                                            msharika.usharikaStatus == 'yes'
                                                ? 'Amekubaliwa'
                                                : (msharika.usharikaStatus ==
                                                            'null' ||
                                                        msharika.usharikaStatus
                                                            .isEmpty)
                                                    ? 'Anasubiri'
                                                    : 'Haijakubaliwa',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: msharika.usharikaStatus ==
                                                      'yes'
                                                  ? Colors.green
                                                  : (msharika.usharikaStatus ==
                                                              'null' ||
                                                          msharika
                                                              .usharikaStatus
                                                              .isEmpty)
                                                      ? Colors.orange
                                                      : Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(Icons.phone,
                                          size: 16,
                                          color: MyColors.primaryLight
                                              .withOpacity(0.7)),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Jumuiya: ${msharika.nambaYaSimu}',
                                        style:
                                            GoogleFonts.poppins(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: ListTile(
                                      leading: const Icon(Icons.edit),
                                      title: Text(
                                        'Hariri',
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ),
                                    onTap: () async {
                                      // Navigator.of(context).pop();
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditMsharikaScreen(
                                            msharika: msharika,
                                            onUpdateSuccess: () {
                                              fetchWasharika();
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: ListTile(
                                      leading: const Icon(Icons.delete,
                                          color: Colors.red),
                                      title: Text(
                                        'Futa',
                                        style: GoogleFonts.poppins(
                                            color: Colors.red),
                                      ),
                                    ),
                                    onTap: () {
                                      // Implement delete functionality
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: ListTile(
                                      leading: const Icon(Icons.call_rounded,
                                          color: Colors.red),
                                      title: Text(
                                        'Piga Simu',
                                        style: GoogleFonts.poppins(
                                            color: Colors.red),
                                      ),
                                    ),
                                    onTap: () {
                                      // Implement delete functionality
                                    },
                                  ),
                                ],
                              ),
                              children: [
                                MsharikaInfoCard(msharika: msharika),
                                if (msharika.usharikaStatus == 'null' ||
                                    msharika.usharikaStatus.isEmpty)
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12.0, bottom: 8.0),
                                      child: ElevatedButton.icon(
                                        icon: const Icon(Icons.verified_user,
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18, vertical: 12),
                                        ),
                                        onPressed: () {
                                          _showApproveSheet(context, msharika);
                                        },
                                      ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.primaryLight,
        onPressed: () {
          //
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OngezaKanisaMsharika(),
            ),
          );
        }, //_showAddMsharikaDialog,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _jinaController.dispose();
    _jinsiaController.dispose();
    _umriController.dispose();
    _haliYaNdoaController.dispose();
    _jinaLaMwenziController.dispose();
    _nambaYaAhadiController.dispose();
    _ainaNdoaController.dispose();
    _nambaSimuController.dispose();
    _jengoController.dispose();
    _ahadiController.dispose();
    _kaziController.dispose();
    _elimuController.dispose();
    _ujuziController.dispose();
    _mahaliPakaziController.dispose();
    _jumuiyaController.dispose();
    _jinaMtoto1Controller.dispose();
    _tareheMtoto1Controller.dispose();
    _uhusianoMtoto1Controller.dispose();
    _jinaMtoto2Controller.dispose();
    _tareheMtoto2Controller.dispose();
    _uhusianoMtoto2Controller.dispose();
    _jinaMtoto3Controller.dispose();
    _tareheMtoto3Controller.dispose();
    _uhusianoMtoto3Controller.dispose();
    _jumuiyaUshirikiController.dispose();
    _idYaJumuiyaController.dispose();
    _katibuJumuiyaController.dispose();
    _kamaUshirikiController.dispose();
    _katibuStatusController.dispose();
    _mzeeStatusController.dispose();
    _usharikaStatusController.dispose();
    _regYearIdController.dispose();
    _tareheController.dispose();
    _passwordController.dispose();
    _jinaLaJumuiyaController.dispose();
    super.dispose();
  }

  // Widget _buildSectionTitle(String title, IconData icon) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 12),
  //     child: Row(
  //       children: [
  //         Icon(icon, color: MyColors.primaryLight, size: 20),
  //         const SizedBox(width: 8),
  //         Text(
  //           title,
  //           style: GoogleFonts.poppins(
  //             fontWeight: FontWeight.bold,
  //             fontSize: 14,
  //             color: MyColors.primaryLight,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
