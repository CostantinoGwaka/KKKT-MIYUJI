// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import '../models/akaunti_model.dart';

class AkauntiZaKanisaScreen extends StatefulWidget {
  const AkauntiZaKanisaScreen({super.key});

  @override
  State<AkauntiZaKanisaScreen> createState() => _AkauntiZaKanisaScreenState();
}

class _AkauntiZaKanisaScreenState extends State<AkauntiZaKanisaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jinaController = TextEditingController();
  final TextEditingController _nambaController = TextEditingController();
  bool _isLoading = false;
  List<AkauntiModel> _akauntiList = [];
  BaseUser? currentUser;

  Future<void> _loadCurrentUser() async {
    try {
      currentUser = await UserManager.getCurrentUser();
      setState(() {});
    } catch (e) {
      // Handle error
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAkaunti();
  }

  Future<void> _fetchAkaunti() async {
    setState(() => _isLoading = true);

    await _loadCurrentUser();
    try {
      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/akaunti_kanisa/get_akaunti_kanisa.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "kanisa_id": currentUser != null ? currentUser!.kanisaId : '',
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == '200') {
          setState(() {
            _akauntiList = (jsonResponse['data'] as List)
                .map((item) => AkauntiModel.fromJson(item))
                .toList();
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createAkaunti(String? id) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/akaunti_kanisa/ongeza_akaunti_kanisa.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          'id': id,
          'jina': _jinaController.text,
          'namba': _nambaController.text,
          "kanisa_id": currentUser != null ? currentUser!.kanisaId : '',
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        _fetchAkaunti();
        _jinaController.clear();
        _nambaController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _deleteAkaunti(String id) async {
    try {
      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/akaunti_kanisa/delete_akaunti_kanisa.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({'id': id}),
      );

      if (response.statusCode == 200) {
        _fetchAkaunti();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showCreateBottomSheet(String? id) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ongeza Akaunti',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _jinaController,
                decoration: InputDecoration(
                  labelText: 'Jina la Akaunti',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tafadhali jaza jina la akaunti';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nambaController,
                decoration: InputDecoration(
                  labelText: 'Namba ya Akaunti',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tafadhali jaza namba ya akaunti';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _createAkaunti(id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryLight,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Ongeza',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Akaunti za Kanisa',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: MyColors.darkText),
        ),
        backgroundColor: MyColors.white,
        foregroundColor: MyColors.darkText,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateBottomSheet(null),
        backgroundColor: MyColors.primaryLight,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchAkaunti,
              child: _akauntiList.isEmpty
                  ? Center(
                      child: Text(
                        'Hakuna akaunti zilizopatikana',
                        style: GoogleFonts.poppins(),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _akauntiList.length,
                      itemBuilder: (context, index) {
                        final akaunti = _akauntiList[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: MyColors.primaryLight.withOpacity(0.1),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: MyColors.primaryLight
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.account_balance,
                                        color: MyColors.primaryLight,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        akaunti.jina,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: MyColors.darkText,
                                        ),
                                      ),
                                    ),
                                    PopupMenuButton(
                                      icon: const Icon(Icons.more_vert),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: const Row(
                                            children: [
                                              Icon(Icons.edit,
                                                  color: Colors.blue, size: 20),
                                              SizedBox(width: 8),
                                              Text('Hariri'),
                                            ],
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _jinaController.text =
                                                  akaunti.jina;
                                              _nambaController.text =
                                                  akaunti.namba;
                                            });
                                            _showCreateBottomSheet(akaunti.id);
                                          },
                                        ),
                                        PopupMenuItem(
                                          child: const Row(
                                            children: [
                                              Icon(Icons.delete,
                                                  color: Colors.red, size: 20),
                                              SizedBox(width: 8),
                                              Text('Futa'),
                                            ],
                                          ),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Thibitisha',
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    'Una uhakika unataka kufuta akaunti hii?',
                                                    style:
                                                        GoogleFonts.poppins(),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text(
                                                        'Hapana',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                    ),
                                                    TextButton(
                                                      child: Text(
                                                        'Ndiyo',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        _deleteAkaunti(
                                                            akaunti.id);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.numbers,
                                            size: 18, color: Colors.grey),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Namba ya Akaunti:',
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          akaunti.namba,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today,
                                            size: 18, color: Colors.grey),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Iliundwa:',
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          akaunti.tarehe,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
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
    );
  }

  @override
  void dispose() {
    _jinaController.dispose();
    _nambaController.dispose();
    super.dispose();
  }
}
