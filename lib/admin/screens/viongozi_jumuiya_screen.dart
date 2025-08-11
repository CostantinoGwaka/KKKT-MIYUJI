// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/Alerts.dart' show Alerts;
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import 'package:lottie/lottie.dart';

class KiongoziJumuiya {
  final String id;
  final String fname;
  final String phoneNo;
  final String wadhifa;
  final String jumuiya;
  final String jumuiyaId;
  final String status;
  final String tarehe;
  final String kanisaId;

  KiongoziJumuiya({
    required this.id,
    required this.fname,
    required this.phoneNo,
    required this.wadhifa,
    required this.jumuiya,
    required this.jumuiyaId,
    required this.status,
    required this.tarehe,
    required this.kanisaId,
  });

  factory KiongoziJumuiya.fromJson(Map<String, dynamic> json) {
    return KiongoziJumuiya(
      id: json['id'] ?? '',
      fname: json['fname'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      wadhifa: json['wadhifa'] ?? '',
      jumuiya: json['jumuiya'] ?? '',
      jumuiyaId: json['jumuiya_id'] ?? '',
      status: json['status'] ?? '',
      tarehe: json['tarehe'] ?? '',
      kanisaId: json['kanisa_id'] ?? '',
    );
  }
}

class ViongoziJumuiyaScreen extends StatefulWidget {
  const ViongoziJumuiyaScreen({Key? key}) : super(key: key);

  @override
  State<ViongoziJumuiyaScreen> createState() => _ViongoziJumuiyaScreenState();
}

class _ViongoziJumuiyaScreenState extends State<ViongoziJumuiyaScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _wadhifaController = TextEditingController();
  bool isSearching = false;

  String? selectedJumuiyaId;
  String? selectedJumuiyaName;
  String? selectedWadhifa;
  bool isLoading = false;
  bool isLoadingWadhifa = false;
  bool isLoadingJumuiya = false;
  List<KiongoziJumuiya> viongoziList = [];
  List<KiongoziJumuiya> filteredViongoziList = [];
  List<Map<String, dynamic>> wadhifaList = [];
  List<Map<String, dynamic>> jumuiyaList = [];
  BaseUser? currentUser;

  Future<void> getWadhifa() async {
    setState(() {
      isLoadingWadhifa = true;
    });
    BaseUser? user = await UserManager.getCurrentUser();
    setState(() {
      currentUser = user;
    });
    try {
      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/wadhifa_kanisa/get_wadhifa_kanisa.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == '200') {
          setState(() {
            wadhifaList = List<Map<String, dynamic>>.from(jsonResponse['data']);
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching wadhifa: $e");
      }
    } finally {
      setState(() {
        isLoadingWadhifa = false;
      });
    }
  }

  Future<void> getJumuiya() async {
    setState(() {
      isLoadingJumuiya = true;
    });
    BaseUser? user = await UserManager.getCurrentUser();
    setState(() {
      currentUser = user;
    });
    try {
      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/jumuiya_kanisa/get_jumuiya_za_kanisa.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == '200') {
          setState(() {
            jumuiyaList = List<Map<String, dynamic>>.from(jsonResponse['data']);
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching jumuiya: $e");
      }
    } finally {
      setState(() {
        isLoadingJumuiya = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
    getViongoziJumuiya();
    getWadhifa();
    getJumuiya();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getWadhifa();
    getJumuiya();
  }

  void checkLogin() async {
    BaseUser? user = await UserManager.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  Future<void> getViongoziJumuiya() async {
    setState(() {
      isLoading = true;
    });

    try {
      String myApi = "${ApiUrl.BASEURL}get_viongozi_jumuiya.php";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "kanisa_id": currentUser != null ? currentUser!.kanisaId : '',
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == '200') {
          List<KiongoziJumuiya> viongozi = (jsonResponse['data'] as List)
              .map((item) => KiongoziJumuiya.fromJson(item))
              .toList();
          setState(() {
            viongoziList = viongozi;
            filteredViongoziList = viongozi;
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching viongozi: $e");
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterViongozi(String query) {
    setState(() {
      filteredViongoziList = viongoziList
          .where((kiongozi) =>
              kiongozi.fname.toLowerCase().contains(query.toLowerCase()) ||
              kiongozi.jumuiya.toLowerCase().contains(query.toLowerCase()) ||
              kiongozi.wadhifa.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> addKiongoziJumuiya() async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        selectedWadhifa == null ||
        selectedJumuiyaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tafadhali jaza taarifa zote muhimu',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      String myApi = "${ApiUrl.BASEURL}add_kiongozi_jumuiya.php";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "fname": _nameController.text,
          "phone_no": _phoneController.text,
          "wadhifa": _wadhifaController.text,
          "jumuiya_id": selectedJumuiyaId,
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == '200') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                jsonResponse['message'],
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.red,
            ),
          );
          _clearFields();
          getViongoziJumuiya();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                jsonResponse['message'],
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Kuna tatizo, jaribu tena baadae",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      if (kDebugMode) {
        print("Error adding kiongozi: $e");
      }
    }
  }

  Future<void> updateKiongoziStatus(String kiongoziId, String newStatus) async {
    try {
      String myApi = "${ApiUrl.BASEURL}update_kiongozi_status.php";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "id": kiongoziId,
          "status": newStatus,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == '200') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                jsonResponse['message'],
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.red,
            ),
          );
          getViongoziJumuiya();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                jsonResponse['message'],
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Kuna tatizo, jaribu tena baadae",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      if (kDebugMode) {
        print("Error updating kiongozi status: $e");
      }
    }
  }

  void _clearFields() {
    _nameController.clear();
    _phoneController.clear();
    _wadhifaController.clear();
    setState(() {
      selectedJumuiyaId = null;
      selectedJumuiyaName = null;
      selectedWadhifa = null;
    });
  }

  void _showAddKiongoziDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Ongeza Kiongozi wa Jumuiya',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Jina la Kiongozi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Namba ya Simu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedWadhifa,
                      isExpanded: true,
                      hint: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Chagua Wadhifa',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                      items: wadhifaList.map((wadhifa) {
                        return DropdownMenuItem<String>(
                          value: wadhifa['jina_wadhifa'],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              wadhifa['jina_wadhifa'],
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedWadhifa = newValue;
                          _wadhifaController.text = newValue ?? '';
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedJumuiyaId,
                      isExpanded: true,
                      hint: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Chagua Jumuiya',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                      items: jumuiyaList.map((jumuiya) {
                        return DropdownMenuItem<String>(
                          value: jumuiya['id'].toString(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              jumuiya['jumuiya_name'],
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedJumuiyaId = newValue;
                          selectedJumuiyaName = jumuiyaList.firstWhere((j) =>
                              j['jumuiya_id'] == newValue)['jumuiya_name'];
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Ghairi',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                addKiongoziJumuiya();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryLight,
              ),
              child: Text(
                'Ongeza',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: _searchController,
                style: GoogleFonts.poppins(color: MyColors.darkText),
                decoration: InputDecoration(
                  hintText: 'Tafuta kiongozi...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onChanged: filterViongozi,
              )
            : Text(
                'Viongozi wa Jumuiya',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: MyColors.darkText),
              ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  isSearching = false;
                  _searchController.clear();
                  filteredViongoziList = viongoziList;
                } else {
                  isSearching = true;
                }
              });
            },
          ),
        ],
        backgroundColor: MyColors.white,
        foregroundColor: MyColors.darkText,
      ),
      body: Column(
        children: [
          if (!isSearching)
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      color: Colors.grey.shade600, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Bonyeza ikoni ya utafutaji hapo juu kutafuta kiongozi...',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : filteredViongoziList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/animation/nodata.json',
                              height: 120,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Hakuna viongozi waliopatikana',
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredViongoziList.length,
                        itemBuilder: (context, index) {
                          final kiongozi = filteredViongoziList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              title: Text(
                                kiongozi.fname,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Wadhifa: ${kiongozi.wadhifa}',
                                    style: GoogleFonts.poppins(fontSize: 12),
                                  ),
                                  Text(
                                    'Jumuiya: ${kiongozi.jumuiya}',
                                    style: GoogleFonts.poppins(fontSize: 12),
                                  ),
                                  Text(
                                    'Simu: ${kiongozi.phoneNo}',
                                    style: GoogleFonts.poppins(fontSize: 12),
                                  ),
                                ],
                              ),
                              trailing: Switch(
                                value: kiongozi.status == '1',
                                onChanged: (bool value) {
                                  updateKiongoziStatus(
                                    kiongozi.id,
                                    value ? '1' : '0',
                                  );
                                },
                                activeColor: MyColors.primaryLight,
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddKiongoziDialog,
        backgroundColor: MyColors.primaryLight,
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
    _nameController.dispose();
    _phoneController.dispose();
    _wadhifaController.dispose();
    super.dispose();
  }
}
