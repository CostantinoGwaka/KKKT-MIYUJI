// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, use_super_parameters, library_private_types_in_public_api, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import 'package:lottie/lottie.dart';

class WalimuKanisaniScreen extends StatefulWidget {
  const WalimuKanisaniScreen({Key? key}) : super(key: key);

  @override
  _WalimuKanisaniScreenState createState() => _WalimuKanisaniScreenState();
}

class _WalimuKanisaniScreenState extends State<WalimuKanisaniScreen> {
  List<Map<String, dynamic>> walimuList = [];
  List<Map<String, dynamic>> filteredWalimuList = [];
  List<Map<String, dynamic>> wadhifaList = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  BaseUser? currentUser;

  // Controllers for form fields
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  String? selectedWadhifa;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    BaseUser? user = await UserManager.getCurrentUser();
    setState(() {
      currentUser = user;
    });
    if (user != null) {
      getWadhifa();
      getWalimuKanisa();
    }
  }

  // Fetch wadhifa list
  Future<void> getWadhifa() async {
    BaseUser? user = await UserManager.getCurrentUser();
    setState(() {
      currentUser = user;
    });
    try {
      String myApi =
          "${ApiUrl.BASEURL}api2/wadhifa_kanisa/get_wadhifa_kanisa.php";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == "200") {
          setState(() {
            wadhifaList = List<Map<String, dynamic>>.from(jsonResponse['data']);
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching wadhifa: $e");
      }
    }
  }

  // Fetch walimu list
  Future<void> getWalimuKanisa() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      String myApi =
          "${ApiUrl.BASEURL}api2/walimu_kanisani/get_walimu_kanisa.php";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 200) {
          setState(() {
            walimuList = List<Map<String, dynamic>>.from(jsonResponse['data']);
            filteredWalimuList = walimuList;
            isLoading = false;
          });
        } else {
          setState(() {
            hasError = true;
            errorMessage = jsonResponse['message'] ?? 'Failed to load data';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          hasError = true;
          errorMessage = 'Server error occurred';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Network error occurred';
        isLoading = false;
      });
    }
  }

  // Add new mwalimu
  Future<void> addMwalimuKanisa() async {
    try {
      String myApi = "${ApiUrl.BASEURL}ongeza_mwalimu_wa_kanisa.php";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "fname": fnameController.text,
          "phone_no": phoneController.text,
          "wadhifa": selectedWadhifa,
          "status": "active",
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == '200') {
          // Clear form and refresh list
          _clearFields();
          getWalimuKanisa();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mwalimu ameongezwa kikamilifu')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(jsonResponse['message'] ?? 'Failed to add mwalimu')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Update mwalimu
  Future<void> updateMwalimuKanisa(
      String id, String fname, String phone, String wadhifa) async {
    try {
      String myApi = "${ApiUrl.BASEURL}update_mwalimu_wa_kanisa.php";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "id": id,
          "fname": fname,
          "phone_no": phone,
          "wadhifa": wadhifa,
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == '200') {
          getWalimuKanisa();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Taarifa zimebadilishwa kikamilifu')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(jsonResponse['message'] ?? 'Failed to update')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Delete mwalimu
  Future<void> deleteMwalimu(String id) async {
    try {
      String myApi = "${ApiUrl.BASEURL}delete_mwalimu_wa_kanisa.php";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "id": id,
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == '200') {
          getWalimuKanisa();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mwalimu amefutwa kikamilifu')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(jsonResponse['message'] ?? 'Failed to delete')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Update mwalimu status
  Future<void> updateMwalimuStatus(String id, String status) async {
    try {
      String myApi = "${ApiUrl.BASEURL}update_mwalimu_status.php";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "id": id,
          "status": status,
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == '200') {
          getWalimuKanisa();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error updating status: $e");
      }
    }
  }

  void _clearFields() {
    fnameController.clear();
    phoneController.clear();
    selectedWadhifa = null;
  }

  void filterWalimu(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredWalimuList = walimuList;
      });
    } else {
      setState(() {
        filteredWalimuList = walimuList.where((mwalimu) {
          return mwalimu['fname']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              mwalimu['phone_no']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              mwalimu['wadhifa']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void _showAddMwalimuDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'Ongeza Mwalimu',
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
                  controller: fnameController,
                  decoration: InputDecoration(
                    labelText: 'Jina la Mwalimu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Namba ya Simu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedWadhifa,
                  decoration: InputDecoration(
                    labelText: 'Wadhifa',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: wadhifaList.map((wadhifa) {
                    return DropdownMenuItem<String>(
                      value: wadhifa['jina_wadhifa'],
                      child: Text(wadhifa['jina_wadhifa']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedWadhifa = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _clearFields();
              },
              child: Text('Ghairi'),
            ),
            ElevatedButton(
              onPressed: () {
                if (fnameController.text.isEmpty ||
                    phoneController.text.isEmpty ||
                    selectedWadhifa == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tafadhali jaza taarifa zote')),
                  );
                  return;
                }
                Navigator.pop(context);
                addMwalimuKanisa();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryLight,
              ),
              child: Text('Hifadhi'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditMwalimuDialog(Map<String, dynamic> mwalimu) {
    final editFnameController = TextEditingController(text: mwalimu['fname']);
    final editPhoneController =
        TextEditingController(text: mwalimu['phone_no']);
    String? editWadhifa = mwalimu['wadhifa'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'Hariri Taarifa za Mwalimu',
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
                  controller: editFnameController,
                  decoration: InputDecoration(
                    labelText: 'Jina la Mwalimu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: editPhoneController,
                  decoration: InputDecoration(
                    labelText: 'Namba ya Simu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: editWadhifa,
                  decoration: InputDecoration(
                    labelText: 'Wadhifa',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: wadhifaList.map((wadhifa) {
                    return DropdownMenuItem<String>(
                      value: wadhifa['wadhifa'],
                      child: Text(wadhifa['wadhifa']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      editWadhifa = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ghairi'),
            ),
            ElevatedButton(
              onPressed: () {
                if (editFnameController.text.isEmpty ||
                    editPhoneController.text.isEmpty ||
                    editWadhifa == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tafadhali jaza taarifa zote')),
                  );
                  return;
                }
                Navigator.pop(context);
                updateMwalimuKanisa(
                  mwalimu['id'],
                  editFnameController.text,
                  editPhoneController.text,
                  editWadhifa!,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryLight,
              ),
              child: Text('Hifadhi'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Thibitisha Kufuta',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text('Una uhakika unataka kufuta mwalimu huyu?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Ghairi'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              deleteMwalimu(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Futa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Walimu wa Kanisa',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: MyColors.primaryLight,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: filterWalimu,
              decoration: InputDecoration(
                hintText: 'Tafuta...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
                          style: GoogleFonts.poppins(),
                        ),
                      ],
                    ),
                  )
                : hasError
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                size: 60, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              errorMessage,
                              style: GoogleFonts.poppins(),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: getWalimuKanisa,
                              child: Text('Jaribu tena'),
                            ),
                          ],
                        ),
                      )
                    : filteredWalimuList.isEmpty
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
                                  'Hakuna walimu waliosajiliwa',
                                  style: GoogleFonts.poppins(),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredWalimuList.length,
                            itemBuilder: (context, index) {
                              final mwalimu = filteredWalimuList[index];
                              final isActive = mwalimu['status'] == 'active';

                              return Card(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(16),
                                  title: Text(
                                    mwalimu['fname'],
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Wadhifa: ${mwalimu['wadhifa']}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Simu: ${mwalimu['phone_no']}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Switch(
                                        value: isActive,
                                        onChanged: (bool value) {
                                          updateMwalimuStatus(
                                            mwalimu['id'],
                                            value ? 'active' : 'inactive',
                                          );
                                        },
                                        activeColor: MyColors.primaryLight,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () =>
                                            _showEditMwalimuDialog(mwalimu),
                                        color: Colors.blue,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () =>
                                            _showDeleteConfirmationDialog(
                                                mwalimu['id']),
                                        color: Colors.red,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddMwalimuDialog,
        label: const Text(
          'Ongeza Mwalimu',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: MyColors.primaryLight,
      ),
    );
  }
}
