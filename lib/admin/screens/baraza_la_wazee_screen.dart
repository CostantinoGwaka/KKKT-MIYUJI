// ignore_for_file: use_build_context_synchronously, use_super_parameters, depend_on_referenced_packages, deprecated_member_use

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kanisaapp/models/baraza_data.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';

class BarazaLaWazeeScreen extends StatefulWidget {
  const BarazaLaWazeeScreen({Key? key}) : super(key: key);

  @override
  State<BarazaLaWazeeScreen> createState() => _BarazaLaWazeeScreenState();
}

class _BarazaLaWazeeScreenState extends State<BarazaLaWazeeScreen> {
  bool isLoading = false;
  String? error;
  List<BarazaData> wazeeBara = [];
  List<BarazaData> filteredWazee = [];
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;
  BaseUser? currentUser;
  List<Map<String, dynamic>> wadhifaList = [];

  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _nambaYaSimuController = TextEditingController();
  final TextEditingController _wadhifaController = TextEditingController();
  String? mzeeStatus;

  @override
  void initState() {
    super.initState();
    fetchData();
    getWadhifa();
  }

  @override
  void dispose() {
    _fnameController.dispose();
    _nambaYaSimuController.dispose();
    _wadhifaController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterWazee(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredWazee = wazeeBara;
      } else {
        filteredWazee = wazeeBara.where((mzee) {
          final searchLower = query.toLowerCase();
          return mzee.fname.toLowerCase().contains(searchLower) ||
              mzee.nambaYaSimu.toLowerCase().contains(searchLower) ||
              mzee.wadhifa.toLowerCase().contains(searchLower);
        }).toList();
      }
    });
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    BaseUser? user = await UserManager.getCurrentUser();
    setState(() {
      currentUser = user;
    });

    try {
      if (currentUser == null) {
        setState(() {
          error = "User not logged in";
          isLoading = false;
        });
        return;
      }

      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/baraza_la_wazee/get_baraza_la_wazee.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "kanisa_id": currentUser!.kanisaId,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 200) {
          setState(() {
            wazeeBara = (jsonResponse['data'] as List)
                .map((item) => BarazaData.fromJson(item))
                .toList();
            filteredWazee = wazeeBara;
          });
        } else {
          setState(() {
            error = jsonResponse['message'] ?? "Failed to load baraza data";
          });
        }
      } else {
        setState(() {
          error = "Server error";
        });
      }
    } catch (e) {
      setState(() {
        error = "Failed to connect to server";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
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

  Future<void> addMzee() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/baraza_la_wazee/ongeza_baraza_la_wazee.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "fname": _fnameController.text,
          "namba_ya_simu":
              _nambaYaSimuController.text.replaceFirst(RegExp(r'^0'), '255'),
          "wadhifa": _wadhifaController.text,
          "kanisa_id": currentUser!.kanisaId,
        }),
      );

      final jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 200) {
        await fetchData();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Mzee ameongezwa kwenye baraza!',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              jsonResponse['message'] ?? "Imeshindwa kuongeza mzee",
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Imeshindwa kuongeza mzee",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateMzee(int id) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/baraza_la_wazee/ongeza_baraza_la_wazee.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "id": id.toString(),
          "fname": _fnameController.text,
          "namba_ya_simu":
              _nambaYaSimuController.text.replaceFirst(RegExp(r'^0'), '255'),
          "wadhifa": _wadhifaController.text,
          "status": mzeeStatus ?? '1',
          "kanisa_id": currentUser!.kanisaId,
        }),
      );

      final jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 200) {
        await fetchData();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Taarifa za mzee zimesahihishwa!',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              jsonResponse['message'] ?? "Imeshindwa kubadili taarifa",
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Imeshindwa kubadili taarifa",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteMzee(int id) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/baraza_la_wazee/delete_baraza_la_wazee.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "id": id.toString(),
        }),
      );

      final jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 200) {
        setState(() {
          isLoading = false;
        });
        await fetchData();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Mzee wa baraza amefutwa kikamilifu!',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Imeshindwa kumtoa mzee",
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Imeshindwa kumtoa mzee",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showAddEditDialog({BarazaData? mzee}) {
    _fnameController.text = mzee?.fname ?? '';
    _nambaYaSimuController.text =
        mzee?.nambaYaSimu.replaceFirst('255', '0') ?? '';
    _wadhifaController.text = mzee?.wadhifa ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: Text(
              mzee == null ? 'Ongeza Mzee' : 'Badilisha Taarifa',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _fnameController,
                      decoration: InputDecoration(
                        labelText: 'Jina la Mzee',
                        labelStyle: GoogleFonts.poppins(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tafadhali jaza jina';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nambaYaSimuController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                        labelText: 'Namba ya Simu',
                        labelStyle: GoogleFonts.poppins(),
                        hintText: '07XXXXXXXX',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tafadhali jaza namba ya simu';
                        }
                        if (!RegExp(r'^(06|07)[0-9]{8}$').hasMatch(value)) {
                          return 'Namba ya simu ianze na 06 au 07 na iwe na tarakimu 10';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: wadhifaList.any((w) =>
                              w['jina_wadhifa'] == _wadhifaController.text)
                          ? _wadhifaController.text
                          : null, // kama haipo kwenye list, tuchukue null
                      decoration: InputDecoration(
                        labelText: 'Wadhifa',
                        labelStyle: GoogleFonts.poppins(),
                      ),
                      items: wadhifaList.map((wadhifa) {
                        return DropdownMenuItem<String>(
                          value: wadhifa['jina_wadhifa'],
                          child: Text(
                            wadhifa['jina_wadhifa'],
                            style: GoogleFonts.poppins(),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _wadhifaController.text = newValue ?? '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tafadhali chagua wadhifa';
                        }
                        return null;
                      },
                    ),
                    if (mzee != null) ...[
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: (mzee.status.toString() == '1' ||
                                mzee.status.toString() == 'active'
                            ? 'Bado Yupo Kazini'
                            : 'Hayupo Kazini'),
                        decoration: InputDecoration(
                          labelText: 'Hali Ya Mzee',
                          labelStyle: GoogleFonts.poppins(),
                        ),
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'Bado Yupo Kazini',
                            child: Text('Bado Yupo Kazini'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Hayupo Kazini',
                            child: Text('Hayupo Kazini'),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            if (newValue == 'Bado Yupo Kazini') {
                              mzeeStatus = '1';
                            } else {
                              mzeeStatus = '0';
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tafadhali chagua hali ya mzee';
                          }
                          return null;
                        },
                      ),
                    ]
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Ghairi',
                  style: GoogleFonts.poppins(),
                ),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        setStateDialog(() {
                          isLoading = true;
                        });
                        if (mzee == null) {
                          addMzee();
                        } else {
                          updateMzee(mzee.id);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primaryLight,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        mzee == null ? 'Ongeza' : 'Badilisha',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
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
                  hintText: 'Tafuta mzee...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onChanged: _filterWazee,
              )
            : Text(
                'Baraza la Wazee',
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
                  filteredWazee = wazeeBara;
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
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.black,
                    ),
                  ),
                ),
              )
            : error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          error!,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: fetchData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.primaryLight,
                          ),
                          child: Text(
                            'Jaribu tena',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : filteredWazee.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.people_outline,
                              size: 60,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              isSearching
                                  ? 'Hakuna matokeo'
                                  : 'Hakuna wazee bado',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredWazee.length,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final mzee = filteredWazee[index];

                          return Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ExpansionTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    MyColors.primaryLight.withOpacity(0.2),
                                child: Text(
                                  mzee.fname[0].toUpperCase(),
                                  style: GoogleFonts.poppins(
                                      color: MyColors.primaryLight,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(
                                mzee.fname,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                mzee.wadhifa,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      _buildInfoRow(
                                        Icons.person_outline,
                                        'Wadhifa',
                                        mzee.wadhifa,
                                      ),
                                      _buildInfoRow(
                                        Icons.phone_outlined,
                                        'Namba ya Simu',
                                        mzee.nambaYaSimu,
                                      ),
                                      _buildInfoRow(
                                        Icons.calendar_today_outlined,
                                        'Tarehe ya Usajili',
                                        mzee.tarehe,
                                      ),
                                      _buildInfoRow(
                                        Icons.info_outline,
                                        'Hali Ya Mzee',
                                        mzee.status.toString() == '1' ||
                                                mzee.status.toString() ==
                                                    'active'
                                            ? 'Bado Yupo Kazini'
                                            : 'Hayupo Kazini',
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton.icon(
                                            icon: const Icon(Icons.edit,
                                                size: 20),
                                            label: Text('Hariri',
                                                style: GoogleFonts.poppins()),
                                            onPressed: () =>
                                                _showAddEditDialog(mzee: mzee),
                                          ),
                                          const SizedBox(width: 8),
                                          TextButton.icon(
                                            icon: const Icon(Icons.delete,
                                                size: 20, color: Colors.red),
                                            label: Text(
                                              'Futa',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.red),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text(
                                                    'Futa Mzee',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    'Una uhakika unataka kumtoa mzee huyu kwenye baraza?',
                                                    style:
                                                        GoogleFonts.poppins(),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text(
                                                        'Ghairi',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        deleteMzee(mzee.id);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Futa',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: MyColors.primaryLight,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
