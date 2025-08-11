// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors

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

class KiongoziJumuiya {
  final int id;
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

  Future<void> fetchData() async {
    await Future.wait([
      getViongoziJumuiya(),
      getWadhifa(),
      getJumuiya(),
    ]);
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
    BaseUser? user = await UserManager.getCurrentUser();
    setState(() {
      currentUser = user;
    });
    try {
      String myApi =
          "${ApiUrl.BASEURL}api2/viongozi_wa_jumuiya/get_kiongozi_wa_kanisa.php";
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
        if (jsonResponse['status'] == 200) {
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
    // Validate all required fields
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
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

    setState(() {
      isLoading = true;
    });

    try {
      String myApi =
          "${ApiUrl.BASEURL}api2/viongozi_wa_jumuiya/ongeza_kiongozi_wa_kanisa.php";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "fname": _nameController.text,
          "phone_no": _phoneController.text.startsWith('0')
              ? '255${_phoneController.text.substring(1)}'
              : _phoneController.text,
          "wadhifa": _wadhifaController.text,
          "jumuiya_id": selectedJumuiyaId,
          "jumuiya": selectedJumuiyaName,
          "status": 'active',
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
          setState(() {
            isLoading = false;
          });
          _clearFields();
          getViongoziJumuiya();
        } else {
          setState(() {
            isLoading = false;
          });
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
      setState(() {
        isLoading = false;
      });
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

  Future<void> deleteKiongozi(int kiongoziId) async {
    try {
      setState(() {
        isLoading = true;
      });
      String myApi =
          "${ApiUrl.BASEURL}api2/viongozi_wa_jumuiya/delete_kiongozi_wa_kanisa.php";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "id": kiongoziId.toString(),
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              jsonResponse['message'],
              style: GoogleFonts.poppins(),
            ),
            backgroundColor:
                jsonResponse['status'] == 200 ? Colors.green : Colors.red,
          ),
        );
        setState(() {
          isLoading = false;
        });
        if (jsonResponse['status'] == 200) {
          getViongoziJumuiya();
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
        print("Error deleting kiongozi: $e");
      }
    }
  }

  Future<void> updateKiongoziJumuiya(int kiongoziId) async {
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
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

    setState(() {
      isLoading = true;
    });

    try {
      String myApi =
          "${ApiUrl.BASEURL}api2/viongozi_wa_jumuiya/ongeza_kiongozi_wa_kanisa.php";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "id": kiongoziId.toString(),
          "fname": _nameController.text,
          "phone_no": _phoneController.text.startsWith('0')
              ? '255${_phoneController.text.substring(1)}'
              : _phoneController.text,
          "wadhifa": selectedWadhifa,
          "jumuiya_id": selectedJumuiyaId,
          "jumuiya": selectedJumuiyaName,
          "status": 'active',
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              jsonResponse['message'],
              style: GoogleFonts.poppins(),
            ),
            backgroundColor:
                jsonResponse['status'] == 200 ? Colors.green : Colors.red,
          ),
        );
        setState(() {
          isLoading = false;
        });
        if (jsonResponse['status'] == 200) {
          _clearFields();
          getViongoziJumuiya();
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
        print("Error updating kiongozi: $e");
      }
    }
  }

  Future<void> updateKiongoziStatus(String kiongoziId, String newStatus) async {
    try {
      String myApi =
          "${ApiUrl.BASEURL}api2/viongozi_wa_jumuiya/update_status_kiongozi_wa_kanisa.php";
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

      setState(() {
        isLoading = true;
      });
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                jsonResponse['message'],
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            isLoading = false;
          });
          getViongoziJumuiya();
        } else {
          setState(() {
            isLoading = false;
          });
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
      setState(() {
        isLoading = false;
      });
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

  void _showEditKiongoziDialog(KiongoziJumuiya kiongozi) {
    _nameController.text = kiongozi.fname;
    _phoneController.text = kiongozi.phoneNo.startsWith('255')
        ? '0${kiongozi.phoneNo.substring(3)}'
        : kiongozi.phoneNo;
    String? dialogWadhifa = kiongozi.wadhifa;
    String? dialogJumuiyaId = kiongozi.jumuiyaId;
    String? dialogJumuiyaName = kiongozi.jumuiya;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text(
                'Hariri Kiongozi wa Jumuiya',
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
                      maxLength: 10,
                      decoration: InputDecoration(
                        labelText: 'Namba ya Simu',
                        hintText: '07xxxxxxxx or 06xxxxxxxx',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        counterText: '',
                      ),
                      onChanged: (value) {
                        if (value.length >= 2) {
                          if (!value.startsWith('07') &&
                              !value.startsWith('06')) {
                            _phoneController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Namba ya simu ianze na 06 au 07',
                                  style: GoogleFonts.poppins(),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: dialogWadhifa,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  wadhifa['jina_wadhifa'],
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setDialogState(() {
                              dialogWadhifa = newValue;
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
                          value: dialogJumuiyaId!.isNotEmpty &&
                                  jumuiyaList.any((j) =>
                                      j['id'].toString() == dialogJumuiyaId)
                              ? dialogJumuiyaId
                              : null,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  jumuiya['jumuiya_name'] ?? '',
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setDialogState(() {
                              dialogJumuiyaId = newValue;
                              if (newValue != null) {
                                final selectedJumuiya = jumuiyaList.firstWhere(
                                  (j) => j['id'].toString() == newValue,
                                  orElse: () => {'jumuiya_name': ''},
                                );
                                dialogJumuiyaName =
                                    selectedJumuiya['jumuiya_name'] ?? '';
                              }
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
                  onPressed: () {
                    _clearFields();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Ghairi',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedWadhifa = dialogWadhifa;
                      selectedJumuiyaId = dialogJumuiyaId;
                      selectedJumuiyaName = dialogJumuiyaName;
                    });
                    Navigator.pop(context);
                    updateKiongoziJumuiya(kiongozi.id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryLight,
                  ),
                  child: Text(
                    'Hariri',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
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
    String? dialogWadhifa = selectedWadhifa;
    String? dialogJumuiyaId = selectedJumuiyaId;
    String? dialogJumuiyaName = selectedJumuiyaName;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, StateSetter setDialogState) {
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
                            value: dialogWadhifa,
                            isExpanded: true,
                            hint: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'Chagua Wadhifa',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ),
                            items: wadhifaList.map((wadhifa) {
                              return DropdownMenuItem<String>(
                                value: wadhifa['jina_wadhifa'],
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    wadhifa['jina_wadhifa'],
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setDialogState(() {
                                dialogWadhifa = newValue;
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
                            value: dialogJumuiyaId,
                            isExpanded: true,
                            hint: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'Chagua Jumuiya',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ),
                            items: jumuiyaList.map((jumuiya) {
                              return DropdownMenuItem<String>(
                                value: jumuiya['id'].toString(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    jumuiya['jumuiya_name'],
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setDialogState(() {
                                dialogJumuiyaId = newValue;
                                dialogJumuiyaName = jumuiyaList.firstWhere(
                                        (j) => j['id'].toString() == newValue)[
                                    'jumuiya_name'];
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
                      setState(() {
                        selectedWadhifa = dialogWadhifa;
                        selectedJumuiyaId = dialogJumuiyaId;
                        selectedJumuiyaName = dialogJumuiyaName;
                      });
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
        });
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
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: Column(
          children: [
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
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      kiongozi.fname,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Wadhifa: ${kiongozi.wadhifa}',
                                          style:
                                              GoogleFonts.poppins(fontSize: 12),
                                        ),
                                        Text(
                                          'Jumuiya: ${kiongozi.jumuiya}',
                                          style:
                                              GoogleFonts.poppins(fontSize: 12),
                                        ),
                                        Text(
                                          'Simu: ${kiongozi.phoneNo}',
                                          style:
                                              GoogleFonts.poppins(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(height: 0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Edit button
                                      TextButton.icon(
                                        onPressed: () {
                                          _showEditKiongoziDialog(kiongozi);
                                        },
                                        icon: Icon(Icons.edit,
                                            size: 20, color: Colors.blue),
                                        label: Text('Hariri',
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.blue)),
                                      ),
                                      // Delete button
                                      TextButton.icon(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Thibitisha!',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                content: Text(
                                                  'Una uhakika unataka kumfuta ${kiongozi.fname}?',
                                                  style: GoogleFonts.poppins(),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text(
                                                      'Ghairi',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      deleteKiongozi(
                                                          kiongozi.id);
                                                    },
                                                    child: Text(
                                                      'Futa',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(Icons.delete,
                                            size: 20, color: Colors.red),
                                        label: Text(
                                          'Futa',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      // Status switch
                                      Row(
                                        children: [
                                          Text('Hali:',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 12)),
                                          Switch(
                                            value: kiongozi.status == 'active',
                                            onChanged: (bool value) {
                                              updateKiongoziStatus(
                                                kiongozi.id.toString(),
                                                value ? 'active' : 'not-active',
                                              );
                                            },
                                            activeColor: MyColors.primaryLight,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
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
