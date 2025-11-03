// ignore_for_file: use_build_context_synchronously, use_super_parameters, depend_on_referenced_packages, deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kanisaapp/models/mwaka_wa_kanisa.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import '../../models/jumuiya_data.dart';
import '../../models/katibu_data.dart';

class MakatibunJumuiyaScreen extends StatefulWidget {
  const MakatibunJumuiyaScreen({Key? key}) : super(key: key);

  @override
  State<MakatibunJumuiyaScreen> createState() => _MakatibunJumuiyaScreenState();
}

class _MakatibunJumuiyaScreenState extends State<MakatibunJumuiyaScreen> {
  bool isLoading = false;
  String? error;
  List<KatibuData> makatibu = [];
  List<KatibuData> filteredMakatibu = [];
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
  String? selectedJumuiyaId;
  String? selectedJumuiyaName;
  String? katibuStatus;

  @override
  void initState() {
    super.initState();
    fetchData();
    getActiveKanisaYearDetails();
  }

  Future<InactiveYear?> getActiveKanisaYearDetails() async {
    String myApi = "${ApiUrl.BASEURL}get_kanisa_year.php";
    final response = await http.post(
      Uri.parse(myApi),
      headers: {'Accept': 'application/json'},
    );

    // ignore: prefer_typing_uninitialized_variables
    var mwaka;

    var jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        mwaka = json;
      }
    }

    if (mwaka != null) {
      if (mwaka is Map && mwaka.containsKey('data')) {
        // Handle single object response
        setState(() {
          inactiveYearData = InactiveYear.fromJson(mwaka['data']);
          krid = inactiveYearData!.yearId;
        });
      }
    }

    return inactiveYearData; // Return a list with the kanisa data or an empty list
  }

  @override
  void dispose() {
    _jinaController.dispose();
    _nambaYaSimuController.dispose();
    _passwordController.dispose();
    _memberNoController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterMakatibu(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredMakatibu = makatibu;
      } else {
        filteredMakatibu = makatibu.where((katibu) {
          final searchLower = query.toLowerCase();
          final jumuiyaName = jumuiya
              .firstWhere(
                (j) => j.id == katibu.jumuiyaId,
                orElse: () => JumuiyaData(
                  id: '',
                  jumuiyaName: '',
                  tarehe: '',
                  kanisaId: '',
                ),
              )
              .jumuiyaName
              .toLowerCase();

          return katibu.jina.toLowerCase().contains(searchLower) ||
              katibu.nambaYaSimu.toLowerCase().contains(searchLower) ||
              katibu.memberNo.toLowerCase().contains(searchLower) ||
              jumuiyaName.contains(searchLower);
        }).toList();
      }
    });
  }

  Future<void> fetchData() async {
    await Future.wait([
      fetchMakatibu(),
      fetchJumuiya(),
    ]);
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

  Future<void> fetchMakatibu() async {
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
            "${ApiUrl.BASEURL}api2/makatibu_kanisa/get_makatibu_kanisa.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "kanisa_id": currentUser!.kanisaId,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == '200') {
          setState(() {
            makatibu = (jsonResponse['data'] as List)
                .map((item) => KatibuData.fromJson(item))
                .toList();
            filteredMakatibu = makatibu;
          });
        } else {
          setState(() {
            error = jsonResponse['message'] ?? "Failed to load makatibu";
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

  Future<void> addKatibu() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/makatibu_kanisa/ongeza_katibu_kanisa.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "jina": _jinaController.text,
          "namba_ya_simu":
              _nambaYaSimuController.text.replaceFirst(RegExp(r'^0'), '255'),
          "password": _passwordController.text,
          "jumuiya_id": selectedJumuiyaId,
          "jumuiya": selectedJumuiyaName,
          "mwaka": krid,
          "member_no": _memberNoController.text,
          "kanisa_id": currentUser!.kanisaId,
        }),
      );

      final jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 200) {
        fetchMakatibu();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Katibu ameongezwa!',
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
              jsonResponse['message'] ?? "Imeshindwa kuongeza katibu",
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
          ),
        );
        // setState(() {
        //   error = jsonResponse['message'] ?? "Failed to add katibu";
        // });
      }
    } catch (e) {
      Navigator.pop(context);

      // setState(() {
      //   error = "Failed to connect to server";
      // });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateKatibu(int id) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/makatibu_kanisa/ongeza_katibu_kanisa.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "id": id.toString(),
          "jina": _jinaController.text,
          "namba_ya_simu":
              _nambaYaSimuController.text.replaceFirst(RegExp(r'^0'), '255'),
          "jumuiya_id": selectedJumuiyaId,
          "jumuiya": selectedJumuiyaName,
          "mwaka": krid,
          "status": katibuStatus ?? '1',
          "member_no": _memberNoController.text,
          "kanisa_id": currentUser!.kanisaId,
        }),
      );

      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 200) {
        fetchMakatibu();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Katibu amesahihishwa!',
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
              jsonResponse['message'] ?? "Imeshindwa kuongeza katibu",
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
            "Imeshindwa kuongeza katibu",
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

  Future<void> deleteKatibu(int id) async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/makatibu_kanisa/delete_katibu_kanisa.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "id": id.toString(),
          "kanisa_id": currentUser!.kanisaId,
        }),
      );

      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == '200') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Katibu amefutwa Kikamirifu!',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.green,
          ),
        );
        fetchMakatibu();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Imeshindwa kufuta katibu",
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Imeshindwa kufuta katibu",
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

  void _showAddEditDialog({KatibuData? katibu}) {
    _jinaController.text = katibu?.jina ?? '';
    _nambaYaSimuController.text =
        katibu?.nambaYaSimu.replaceFirst('255', '0') ?? '';
    _memberNoController.text = katibu?.memberNo ?? '';
    selectedJumuiyaId = katibu?.jumuiyaId;
    selectedJumuiyaName = katibu?.jumuiya;
    _passwordController.clear();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      katibu == null ? 'Ongeza Katibu' : 'Badilisha Taarifa',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _jinaController,
                      decoration: const InputDecoration(
                        labelText: 'Jina la Katibu',
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
                          selectedJumuiyaName = jumuiya
                              .firstWhere((j) => j.id == value)
                              .jumuiyaName;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tafadhali chagua jumuiya';
                        }
                        return null;
                      },
                    ),
                    if (katibu != null) ...[
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: (katibu.status.toString() == '1' ||
                                katibu.status.toString() == 'active'
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
                              katibuStatus = '1';
                            } else {
                              katibuStatus = '0';
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
                    ],
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
                    if (katibu == null) ...[
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
                    if (error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        error!,
                        style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Ghairi',
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        isLoading
                            ? const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black,
                                ),
                              )
                            : ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        if (katibu == null) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          addKatibu();
                                        } else {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          updateKatibu(katibu.id);
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColors.primaryLight,
                                ),
                                child: Text(
                                  isLoading
                                      ? 'Inahifadhi...'
                                      : (katibu == null
                                          ? 'Ongeza'
                                          : 'Badilisha'),
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
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
                  hintText: 'Tafuta katibu...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onChanged: _filterMakatibu,
              )
            : Text(
                'Makatibu wa Jumuiya',
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
                  filteredMakatibu = makatibu;
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
                : filteredMakatibu.isEmpty
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
                                  : 'Hakuna makatibu bado',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredMakatibu.length,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final katibu = filteredMakatibu[index];
                          final jumuiyaName = jumuiya
                              .firstWhere(
                                (j) => j.id == katibu.jumuiyaId,
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
                                  katibu.jina[0].toUpperCase(),
                                  style: GoogleFonts.poppins(
                                      color: MyColors.primaryLight,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(
                                katibu.jina,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                'Namba ya Usajili: ${katibu.memberNo}',
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
                                        Icons.people_outline,
                                        'Jumuiya',
                                        jumuiyaName,
                                      ),
                                      _buildInfoRow(
                                        Icons.phone_outlined,
                                        'Namba ya Simu',
                                        katibu.nambaYaSimu,
                                      ),
                                      _buildInfoRow(
                                        Icons.calendar_today_outlined,
                                        'Mwaka',
                                        katibu.mwaka,
                                      ),
                                      _buildInfoRow(
                                        Icons.access_time_outlined,
                                        'Tarehe ya Usajili',
                                        katibu.tarehe,
                                      ),
                                      _buildInfoRow(
                                        Icons.info_outline,
                                        'Hali Ya Katibu',
                                        katibu.status.toString() == '1' ||
                                                katibu.status.toString() ==
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
                                            onPressed: () => _showAddEditDialog(
                                                katibu: katibu),
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
                                                    'Futa Neno la Siku',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    'Una uhakika unataka kufuta neno hili?',
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
                                                        deleteKatibu(katibu.id);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Futa',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.white,
                                                        ),
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

  // Add this helper method in the class
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
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
}
