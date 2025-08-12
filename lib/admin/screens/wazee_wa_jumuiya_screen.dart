// ignore_for_file: use_build_context_synchronously, use_super_parameters, depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kanisaapp/models/mwaka_wa_kanisa.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/models/wazee_data.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import '../../models/jumuiya_data.dart';

class WazeeWaJumuiyaScreen extends StatefulWidget {
  const WazeeWaJumuiyaScreen({Key? key}) : super(key: key);

  @override
  State<WazeeWaJumuiyaScreen> createState() => _WazeeWaJumuiyaScreenState();
}

class _WazeeWaJumuiyaScreenState extends State<WazeeWaJumuiyaScreen> {
  bool isLoading = false;
  String? error;
  List<WazeeData> wazee = [];
  List<WazeeData> filteredWazee = [];
  List<JumuiyaData> jumuiya = [];
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;
  BaseUser? currentUser;
  String? krid;
  InactiveYear? inactiveYearData;
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController _jinaController = TextEditingController();
  final TextEditingController _nambaYaSimuController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _memberNoController = TextEditingController();
  final TextEditingController _eneoController = TextEditingController();
  String? selectedJumuiyaId;
  String? selectedJumuiyaName;

  @override
  void initState() {
    super.initState();
    fetchData();
    getActiveKanisaYearDetails();
  }

  @override
  void dispose() {
    _jinaController.dispose();
    _nambaYaSimuController.dispose();
    _passwordController.dispose();
    _memberNoController.dispose();
    _eneoController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterWazee(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredWazee = wazee;
      } else {
        filteredWazee = wazee.where((mzee) {
          final searchLower = query.toLowerCase();
          final jumuiyaName = jumuiya
              .firstWhere(
                (j) => j.id == mzee.jumuiyaId,
                orElse: () => JumuiyaData(
                  id: '',
                  jumuiyaName: '',
                  tarehe: '',
                  kanisaId: '',
                ),
              )
              .jumuiyaName
              .toLowerCase();

          return mzee.jina.toLowerCase().contains(searchLower) ||
              mzee.nambaYaSimu.toLowerCase().contains(searchLower) ||
              mzee.memberNo.toLowerCase().contains(searchLower) ||
              jumuiyaName.contains(searchLower);
        }).toList();
      }
    });
  }

  Future<void> fetchData() async {
    await Future.wait([
      fetchWazee(),
      fetchJumuiya(),
    ]);
  }

  Future<void> getActiveKanisaYearDetails() async {
    String myApi = "${ApiUrl.BASEURL}get_kanisa_year.php";
    final response = await http.get(
      Uri.parse(myApi),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 200) {
        setState(() {
          inactiveYearData = InactiveYear.fromJson(jsonResponse['data']);
          krid = inactiveYearData?.id.toString();
        });
      }
    }
  }

  Future<void> fetchJumuiya() async {
    setState(() {
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
            "${ApiUrl.BASEURL}api2/jumuiya_kanisa/get_jumuiya_za_kanisa.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "kanisa_id": currentUser!.kanisaId,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == '200') {
          setState(() {
            jumuiya = (jsonResponse['data'] as List)
                .map((item) => JumuiyaData.fromJson(item))
                .toList();
          });
        } else {
          setState(() {
            error = jsonResponse['message'] ?? "Failed to load jumuiya";
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
    }
  }

  Future<void> fetchWazee() async {
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
            "${ApiUrl.BASEURL}api2/wazee_wajumuiya/get_wazee_wanajumuiya.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "kanisa_id": currentUser!.kanisaId,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == "200") {
          setState(() {
            wazee = (jsonResponse['data'] as List)
                .map((item) => WazeeData.fromJson(item))
                .toList();
            filteredWazee = wazee;
          });
        } else {
          setState(() {
            error = jsonResponse['message'] ?? "Failed to load wazee";
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

  Future<void> addMzee() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/wazee_wajumuiya/ongeza_wazee_jumuiya.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "jina": _jinaController.text,
          "namba_ya_simu":
              _nambaYaSimuController.text.replaceFirst(RegExp(r'^0'), '255'),
          "password": _passwordController.text,
          "eneo": _eneoController.text,
          "jumuiya_id": selectedJumuiyaId,
          "jumuiya": selectedJumuiyaName,
          "mwaka": krid,
          "member_no": _memberNoController.text,
          "kanisa_id": currentUser!.kanisaId,
        }),
      );

      final jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 200) {
        fetchWazee();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Mzee ameongezwa!',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
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
            "${ApiUrl.BASEURL}api2/wazee_wajumuiya/ongeza_wazee_jumuiya.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "id": id.toString(),
          "jina": _jinaController.text,
          "namba_ya_simu":
              _nambaYaSimuController.text.replaceFirst(RegExp(r'^0'), '255'),
          "eneo": _eneoController.text,
          "jumuiya_id": selectedJumuiyaId,
          "jumuiya": selectedJumuiyaName,
          "mwaka": krid,
          "member_no": _memberNoController.text,
          "kanisa_id": currentUser!.kanisaId,
        }),
      );

      final jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 200) {
        fetchWazee();
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
            "${ApiUrl.BASEURL}api2/wazee_wajumuiya/delete_mzee_jumuiya.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "id": id.toString(),
        }),
      );

      final jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 200) {
        await fetchWazee();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Mzee amefutwa!',
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
              "Imeshindwa kufuta mzee",
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
            "Imeshindwa kufuta mzee",
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

  void _showAddEditDialog({WazeeData? mzee}) {
    _jinaController.text = mzee?.jina ?? '';
    _nambaYaSimuController.text =
        mzee?.nambaYaSimu.replaceFirst('255', '0') ?? '';
    _memberNoController.text = mzee?.memberNo ?? '';
    _eneoController.text = mzee?.eneo ?? '';
    selectedJumuiyaId = mzee?.jumuiyaId.toString();
    selectedJumuiyaName = mzee?.jumuiya;
    _passwordController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                  controller: _jinaController,
                  decoration: const InputDecoration(
                    labelText: 'Jina la Mzee',
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
                  decoration: const InputDecoration(
                    labelText: 'Namba ya Simu',
                  ),
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tafadhali jaza namba ya simu';
                    }
                    if (!RegExp(r'^(0[67])\d{8}$').hasMatch(value)) {
                      return 'Namba ya simu inapaswa kuanza na 06 au 07 na kuwa na tarakimu 10';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedJumuiyaId,
                  hint: const Text('Chagua Jumuiya'),
                  items: jumuiya.map((j) {
                    return DropdownMenuItem<String>(
                      value: j.id,
                      child: Text(j.jumuiyaName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedJumuiyaId = value;
                      selectedJumuiyaName =
                          jumuiya.firstWhere((j) => j.id == value).jumuiyaName;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tafadhali chagua jumuiya';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _memberNoController,
                  decoration: const InputDecoration(
                    labelText: 'Namba ya Usajili',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tafadhali jaza namba ya usajili';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _eneoController,
                  decoration: const InputDecoration(
                    labelText: 'Eneo',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tafadhali jaza eneo';
                    }
                    return null;
                  },
                ),
                if (mzee == null) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tafadhali jaza password';
                      }
                      if (value.length < 6) {
                        return 'Password inapaswa kuwa na urefu wa angalau herufi 6';
                      }
                      return null;
                    },
                  ),
                ],
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
                    if (mzee == null) {
                      addMzee();
                    } else {
                      updateMzee(mzee.id);
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.primaryLight,
            ),
            child: Text(
              isLoading
                  ? 'Inahifadhi...'
                  : (mzee == null ? 'Ongeza' : 'Badilisha'),
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
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
                'Wazee wa Jumuiya',
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
                  filteredWazee = wazee;
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
                          final jumuiyaName = jumuiya
                              .firstWhere(
                                (j) => j.id == mzee.jumuiyaId,
                                orElse: () => JumuiyaData(
                                  id: '',
                                  jumuiyaName: 'Unknown',
                                  tarehe: '',
                                  kanisaId: '',
                                ),
                              )
                              .jumuiyaName;

                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
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
                                  mzee.jina[0].toUpperCase(),
                                  style: GoogleFonts.poppins(
                                      color: MyColors.primaryLight,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(
                                mzee.jina,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Namba ya Usajili: ${mzee.memberNo}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    'Jumuiya: $jumuiyaName',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      _buildInfoRow(
                                        Icons.people_outline,
                                        'Jumuiya',
                                        jumuiyaName,
                                      ),
                                      _buildInfoRow(
                                        Icons.phone_outlined,
                                        'Namba ya Simu',
                                        mzee.nambaYaSimu,
                                      ),
                                      _buildInfoRow(
                                        Icons.location_on_outlined,
                                        'Eneo',
                                        mzee.eneo,
                                      ),
                                      _buildInfoRow(
                                        Icons.calendar_today_outlined,
                                        'Mwaka',
                                        mzee.mwaka,
                                      ),
                                      _buildInfoRow(
                                        Icons.access_time_outlined,
                                        'Tarehe ya Usajili',
                                        mzee.tarehe,
                                      ),
                                      _buildInfoRow(
                                        Icons.info_outline,
                                        'Status',
                                        mzee.status,
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
                                                    'Una uhakika unataka kumfuta mzee huyu?',
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
