// ignore_for_file: depend_on_referenced_packages, use_super_parameters, use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kanisaapp/models/msharika_model.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';

class WasharikaKanisaniScreen extends StatefulWidget {
  const WasharikaKanisaniScreen({Key? key}) : super(key: key);

  @override
  _WasharikaKanisaniScreenState createState() =>
      _WasharikaKanisaniScreenState();
}

class _WasharikaKanisaniScreenState extends State<WasharikaKanisaniScreen> {
  Widget _buildDetailRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildInfo(String name, String date, String relation) {
    if (name.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (date.isNotEmpty)
              Text(
                'Tarehe: $date',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
            if (relation.isNotEmpty)
              Text(
                'Uhusiano: $relation',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  List<MsharikaData> washarika = [];
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

  @override
  void initState() {
    super.initState();
    fetchWasharika();
  }

  Future<void> fetchWasharika() async {
    BaseUser? user = await UserManager.getCurrentUser();
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
          washarika = data.map((json) => MsharikaData.fromJson(json)).toList();
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
          'jina_la_msharika': _jinaController.text,
          'jinsia': _jinsiaController.text,
          'umri': _umriController.text,
          'hali_ya_ndoa': _haliYaNdoaController.text,
          'jina_la_mwenzi_wako': _jinaLaMwenziController.text,
          'namba_ya_ahadi': _nambaYaAhadiController.text,
          'aina_ya_ndoa': _ainaNdoaController.text,
          'namba_ya_simu': _nambaSimuController.text,
          'jengo': _jengoController.text,
          'ahadi': _ahadiController.text,
          'kazi': _kaziController.text,
          'elimu': _elimuController.text,
          'ujuzi': _ujuziController.text,
          'mahali_pakazi': _mahaliPakaziController.text,
          'jina_la_jumuiya': _jumuiyaController.text,
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

  void _showAddMsharikaDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add New Msharika',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: MyColors.primaryLight,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(_jinaController, 'Full Name', Icons.person),
                  _buildTextField(
                      _jinsiaController, 'Gender', Icons.person_outline),
                  _buildTextField(_umriController, 'Age', Icons.calendar_today),
                  _buildTextField(
                      _haliYaNdoaController, 'Marital Status', Icons.favorite),
                  _buildTextField(
                      _jinaLaMwenziController, 'Spouse Name', Icons.people),
                  _buildTextField(_nambaYaAhadiController, 'Promise Number',
                      Icons.confirmation_number),
                  _buildTextField(_ainaNdoaController, 'Marriage Type',
                      Icons.family_restroom),
                  _buildTextField(
                      _nambaSimuController, 'Phone Number', Icons.phone),
                  _buildTextField(_jengoController, 'Building', Icons.home),
                  _buildTextField(
                      _ahadiController, 'Promise', Icons.description),
                  _buildTextField(_kaziController, 'Occupation', Icons.work),
                  _buildTextField(_elimuController, 'Education', Icons.school),
                  _buildTextField(_ujuziController, 'Skills', Icons.psychology),
                  _buildTextField(_mahaliPakaziController, 'Work Location',
                      Icons.location_on),
                  _buildTextField(
                      _jumuiyaController, 'Community Name', Icons.groups),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: addMsharika,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.primaryLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: MyColors.primaryLight),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyColors.primaryLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: MyColors.primaryLight.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyColors.primaryLight),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
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
                                      Icon(Icons.group,
                                          size: 16,
                                          color: MyColors.primaryLight
                                              .withOpacity(0.7)),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Jumuiya: ${msharika.jinaLaJumuiya}',
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
                                        'Edit',
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ),
                                    onTap: () {
                                      // Implement edit functionality
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: ListTile(
                                      leading: const Icon(Icons.delete,
                                          color: Colors.red),
                                      title: Text(
                                        'Delete',
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
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildSectionTitle(
                                            'Taarifa Binafsi', Icons.person),
                                        _buildDetailRow(
                                            'Jinsia', msharika.jinsia),
                                        _buildDetailRow('Umri', msharika.umri),
                                        _buildDetailRow('Hali ya Ndoa',
                                            msharika.haliYaNdoa),
                                        if (msharika
                                            .jinaLaMwenziWako.isNotEmpty)
                                          _buildDetailRow('Mwenzi',
                                              msharika.jinaLaMwenziWako),
                                        _buildDetailRow(
                                            'Aina ya Ndoa', msharika.ainaNdoa),
                                        _buildSectionTitle(
                                            'Watoto', Icons.child_care),
                                        if (msharika.jinaMtoto1.isNotEmpty)
                                          _buildChildInfo(
                                            msharika.jinaMtoto1,
                                            msharika.tareheMtoto1,
                                            msharika.uhusianoMtoto1,
                                          ),
                                        if (msharika.jinaMtoto2.isNotEmpty)
                                          _buildChildInfo(
                                            msharika.jinaMtoto2,
                                            msharika.tareheMtoto2,
                                            msharika.uhusianoMtoto2,
                                          ),
                                        if (msharika.jinaMtoto3.isNotEmpty)
                                          _buildChildInfo(
                                            msharika.jinaMtoto3,
                                            msharika.tareheMtoto3,
                                            msharika.uhusianoMtoto3,
                                          ),
                                        _buildSectionTitle(
                                            'Mawasiliano na Kazi', Icons.work),
                                        _buildDetailRow('Namba ya Simu',
                                            msharika.nambaYaSimu),
                                        _buildDetailRow('Kazi', msharika.kazi),
                                        _buildDetailRow(
                                            'Elimu', msharika.elimu),
                                        _buildDetailRow(
                                            'Ujuzi', msharika.ujuzi),
                                        _buildDetailRow('Mahali pa Kazi',
                                            msharika.mahaliPakazi),
                                        _buildSectionTitle(
                                            'Taarifa za Kanisa', Icons.church),
                                        _buildDetailRow(
                                            'Jengo', msharika.jengo),
                                        _buildDetailRow(
                                            'Ahadi', msharika.ahadi),
                                        _buildDetailRow('Jumuiya Ushiriki',
                                            msharika.jumuiyaUshiriki),
                                        _buildDetailRow('Katibu Status',
                                            msharika.katibuStatus),
                                        _buildDetailRow(
                                            'Mzee Status', msharika.mzeeStatus),
                                        _buildDetailRow('Usharika Status',
                                            msharika.usharikaStatus),
                                        _buildDetailRow('Tarehe ya Usajili',
                                            msharika.tarehe),
                                      ],
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
        onPressed: _showAddMsharikaDialog,
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
    super.dispose();
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: MyColors.primaryLight, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: MyColors.primaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
