// ignore_for_file: use_build_context_synchronously

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
import '../../models/neno_lasiku.dart';

class NenoLaSikuScreen extends StatefulWidget {
  const NenoLaSikuScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NenoLaSikuScreenState createState() => _NenoLaSikuScreenState();
}

class _NenoLaSikuScreenState extends State<NenoLaSikuScreen> {
  final TextEditingController _nenoController = TextEditingController();
  String? nenoUpdateId;
  bool _isLoading = false;
  List<NenoLaSikuData> _nenoList = [];
  BaseUser? currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadNenoLaSiku();
  }

  Future<void> _loadCurrentUser() async {
    currentUser = await UserManager.getCurrentUser();
    setState(() {});
  }

  Future<void> _loadNenoLaSiku() async {
    setState(() {
      _isLoading = true;
    });

    currentUser = await UserManager.getCurrentUser();

    try {
      String myApi = "${ApiUrl.BASEURL}api2/neno_la_siku/get_neno_la_siku.php";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == '200' && jsonResponse['data'] != null) {
          setState(() {
            if (jsonResponse['data'] is List) {
              setState(() {
                _nenoList = (jsonResponse['data'] as List)
                    .map((item) => NenoLaSikuData.fromJson(item))
                    .toList();
              });
            } else {
              setState(() {
                _nenoList = [NenoLaSikuData.fromJson(jsonResponse['data'])];
              });
            }
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading neno la siku: $e");
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addNenoLaSiku() async {
    if (_nenoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tafadhali ingiza neno la siku')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String myApi =
          "${ApiUrl.BASEURL}api2/neno_la_siku/ongeza_neno_la_siku.php";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "id": nenoUpdateId,
          "neno": _nenoController.text,
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 200) {
          _nenoController.clear();
          nenoUpdateId = null; // Reset the update ID after adding
          _loadNenoLaSiku();
         
          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Neno la siku limeongezwa kikamilifu',
                                  style: GoogleFonts.poppins(),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    jsonResponse['message'] ?? 'Kuna tatizo, jaribu tena')),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error adding neno la siku: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kuna tatizo, jaribu tena baadae')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Neno la Siku',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: MyColors.darkText),
        ),
        backgroundColor: MyColors.white,
        foregroundColor: MyColors.darkText,
      ),
      body: Column(
        children: [
          if (currentUser?.userType == 'ADMIN') ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nenoController,
                    onChanged: (value) {
                      setState(() {
                        // This will trigger a rebuild when text changes
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Andika Neno la Siku',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _nenoController.text.isNotEmpty
                      ? ElevatedButton(
                          onPressed: _isLoading ? null : _addNenoLaSiku,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.primaryLight,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Ongeza Neno',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ))
                      : const Text(
                          'Andika Neno la Siku',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                ],
              ),
            ),
            const Divider(),
          ],
          Expanded(
            child: _isLoading
                ? Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Lottie.asset(
                        'assets/animation/loading.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : _nenoList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 200,
                              child: Lottie.asset(
                                'assets/animation/nodata.json',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Text(
                              'Hakuna neno la siku kwa sasa',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _nenoList.length,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          final neno = _nenoList[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          neno.neno ?? '',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                      if (currentUser?.userType == 'ADMIN') ...[
                                        PopupMenuButton<String>(
                                          icon: const Icon(Icons.more_vert),
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              _showEditDialog(neno);
                                            } else if (value == 'delete') {
                                              _showDeleteConfirmationDialog(
                                                  neno);
                                            }
                                          },
                                          itemBuilder: (BuildContext context) =>
                                              [
                                            PopupMenuItem(
                                              value: 'edit',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.edit,
                                                    size: 20,
                                                    color:
                                                        MyColors.primaryLight,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'Badili',
                                                    style:
                                                        GoogleFonts.poppins(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.delete,
                                                    size: 20,
                                                    color: Colors.red,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'Futa',
                                                    style:
                                                        GoogleFonts.poppins(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tarehe: ${neno.tarehe ?? ''}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
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
    );
  }

  Future<void> _deleteNenoLaSiku(int? id) async {
    try {
      setState(() {
        _isLoading = true;
      });

      String myApi =
          "${ApiUrl.BASEURL}api2/neno_la_siku/delete_neno_la_siku.php";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "id": id,
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == '200') {
          _loadNenoLaSiku();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Neno la siku limefutwa kikamilifu')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    jsonResponse['message'] ?? 'Kuna tatizo, jaribu tena')),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting neno la siku: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kuna tatizo, jaribu tena baadae')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showEditDialog(NenoLaSikuData neno) {
    _nenoController.text = neno.neno ?? '';
    nenoUpdateId = neno.id.toString();
  }

  void _showDeleteConfirmationDialog(NenoLaSikuData neno) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Futa Neno la Siku',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Una uhakika unataka kufuta neno hili?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Ghairi',
              style: GoogleFonts.poppins(
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteNenoLaSiku(neno.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Futa',
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nenoController.dispose();
    super.dispose();
  }
}
