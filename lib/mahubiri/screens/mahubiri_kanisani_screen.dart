// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';

class MahubiriKanisaniScreen extends StatefulWidget {
  const MahubiriKanisaniScreen({super.key});

  @override
  State<MahubiriKanisaniScreen> createState() => _MahubiriKanisaniScreenState();
}

class _MahubiriKanisaniScreenState extends State<MahubiriKanisaniScreen> {
  final TextEditingController _mahubiriNameController = TextEditingController();
  final TextEditingController _videoIdController = TextEditingController();
  final TextEditingController _tareheController = TextEditingController();

  BaseUser? currentUser;
  List<Map<String, dynamic>> mahubiriList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _fetchMahubiri();
  }

  Future<void> _loadCurrentUser() async {
    currentUser = await UserManager.getCurrentUser();
    setState(() {});
  }

  // Fetch Mahubiri
  Future<void> _fetchMahubiri() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/mahubiri_kanisa/get_mahaburi_makanisa.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == '200') {
          setState(() {
            mahubiriList =
                List<Map<String, dynamic>>.from(jsonResponse['data']);
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching mahubiri: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Add Mahubiri
  Future<void> _addMahubiri() async {
    if (_mahubiriNameController.text.isEmpty ||
        _videoIdController.text.isEmpty ||
        _tareheController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tafadhali jaza nafasi zote zinazohitajika',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/mahubiri_kanisa/ongeza_mahubiri_kanisa.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "mahubiri_name": _mahubiriNameController.text,
          "video_id": _videoIdController.text,
          "tarehe": _tareheController.text,
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == '200') {
          Navigator.pop(context);
          _fetchMahubiri();
          _clearControllers();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Mahubiri yameongezwa kwa mafanikio',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                jsonResponse['message'] ?? 'Imeshindwa kuongeza mahubiri',
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
            'Imeshindwa kuongeza mahubiri',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Update Mahubiri
  Future<void> _updateMahubiri(String id) async {
    if (_mahubiriNameController.text.isEmpty ||
        _videoIdController.text.isEmpty ||
        _tareheController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tafadhali jaza nafasi zote zinazohitajika',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/mahubiri_kanisa/ongeza_mahubiri_kanisa.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "id": id,
          "mahubiri_name": _mahubiriNameController.text,
          "video_id": _videoIdController.text,
          "tarehe": _tareheController.text,
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == '200') {
          Navigator.pop(context);
          _fetchMahubiri();
          _clearControllers();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Mahubiri yamerekebishwa kwa mafanikio',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                jsonResponse['message'] ?? 'Imeshindwa kurekebisha mahubiri',
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
            'Imeshindwa kurekebisha mahubiri',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Delete Mahubiri
  Future<void> _deleteMahubiri(String id) async {
    try {
      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/mahubiri_kanisa/delete_mahubiri_makanisa.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "id": id,
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == '200') {
          _fetchMahubiri();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Mahubiri yamefutwa kwa mafanikio',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                jsonResponse['message'] ?? 'Imeshindwa kufuta mahubiri',
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
            'Imeshindwa kufuta mahubiri',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _clearControllers() {
    _mahubiriNameController.clear();
    _videoIdController.clear();
    _tareheController.clear();
  }

  void _showAddEditDialog([Map<String, dynamic>? mahubiri]) {
    if (mahubiri != null) {
      _mahubiriNameController.text = mahubiri['mahubiri_name'];
      _videoIdController.text = mahubiri['video_id'];
      _tareheController.text = mahubiri['tarehe'];
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          mahubiri == null ? 'Ongeza  Mahubiri' : 'Sahihisha Mahubiri',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _mahubiriNameController,
                decoration: InputDecoration(
                  labelText: 'Mahubiri Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _videoIdController,
                decoration: InputDecoration(
                  labelText: 'Video ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _tareheController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearControllers();
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (mahubiri == null) {
                _addMahubiri();
              } else {
                _updateMahubiri(mahubiri['id']);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.primaryLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              mahubiri == null ? 'Add' : 'Update',
              style: GoogleFonts.poppins(color: Colors.white),
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
        title: Text(
          'Mahubiri Management',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: MyColors.primaryLight,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: MyColors.primaryLight,
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : mahubiriList.isEmpty
              ? Center(
                  child: Text(
                    'No mahubiri available',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: mahubiriList.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final mahubiri = mahubiriList[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          mahubiri['mahubiri_name'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              'Video ID: ${mahubiri['video_id']}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'Date: ${mahubiri['tarehe']}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showAddEditDialog(mahubiri),
                              color: Colors.blue,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteMahubiri(mahubiri['id']),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  @override
  void dispose() {
    _mahubiriNameController.dispose();
    _videoIdController.dispose();
    _tareheController.dispose();
    super.dispose();
  }
}
