// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import 'package:lottie/lottie.dart';

class WadhifaScreen extends StatefulWidget {
  const WadhifaScreen({super.key});

  @override
  State<WadhifaScreen> createState() => _WadhifaScreenState();
}

class _WadhifaScreenState extends State<WadhifaScreen> {
  final _wadhifa = <Map<String, dynamic>>[];
  final _filteredWadhifa = <Map<String, dynamic>>[];
  final _searchController = TextEditingController();
  var _isLoading = true;
  var _isSearching = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchWadhifa();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterWadhifa(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredWadhifa.clear();
        _filteredWadhifa.addAll(_wadhifa);
      } else {
        final searchLower = query.toLowerCase();
        _filteredWadhifa.clear();
        _filteredWadhifa.addAll(
          _wadhifa.where((item) {
            final wadhifaName = item['jina_wadhifa']?.toString().toLowerCase() ?? '';
            return wadhifaName.contains(searchLower);
          }),
        );
      }
    });
  }

  Future<void> fetchWadhifa() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final currentUser = await UserManager.getCurrentUser();
      if (currentUser == null) {
        setState(() {
          _error = "User not logged in";
          _isLoading = false;
        });
        return;
      }

      final response = await http.post(
        Uri.parse(
            "${ApiUrl.BASEURL}api2/wadhifa_kanisa/get_wadhifa_kanisa.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "kanisa_id": currentUser.kanisaId,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == '200') {
          final newWadhifa = List<Map<String, dynamic>>.from(jsonResponse['data']);
          setState(() {
            _wadhifa.clear();
            _wadhifa.addAll(newWadhifa);
            _filteredWadhifa.clear();
            _filteredWadhifa.addAll(_wadhifa);
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = jsonResponse['message'] ?? "Failed to load wadhifa";
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = "Server error";
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching wadhifa: $e");
      }
      setState(() {
        _error = "Failed to connect to server";
        _isLoading = false;
      });
    }
  }

  void _showDeleteDialog(Map<String, dynamic> wadhifaItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Futa Wadhifa',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: Text(
            'Una uhakika unataka kufuta wadhifa wa "${wadhifaItem['jina_wadhifa']}"?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Hapana',
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  setState(() {
                    _isLoading = true;
                  });
                  final currentUser = await UserManager.getCurrentUser();
                  if (currentUser == null) {
                    Navigator.pop(context);
                    setState(() {
                      _isLoading = false;
                    });
                    return;
                  }

                  final response = await http.post(
                    Uri.parse(
                        "${ApiUrl.BASEURL}api2/wadhifa_kanisa/delete_wadhifa.php"),
                    headers: {'Accept': 'application/json'},
                    body: jsonEncode({
                      "id": wadhifaItem['id'],
                    }),
                  );

                  if (response.statusCode == 200) {
                    final jsonResponse = json.decode(response.body);
                    if (jsonResponse['status'] == '200') {
                      if (mounted) {
                        Navigator.pop(context);
                        setState(() {
                          _wadhifa.removeWhere(
                              (item) => item['id'] == wadhifaItem['id']);
                        });
                        fetchWadhifa(); // Refresh the list
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Wadhifa umefutwa kikamilifu',
                              style: GoogleFonts.poppins(),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } else {
                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              jsonResponse['message'] ??
                                  'Imeshindwa kufuta wadhifa',
                              style: GoogleFonts.poppins(),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                } catch (e) {
                  if (kDebugMode) {
                    print("Error deleting wadhifa: $e");
                  }
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Imeshindwa kufuta wadhifa',
                          style: GoogleFonts.poppins(),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text(
                'Ndio',
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditBottomSheet(Map<String, dynamic> wadhifaItem) {
    final formKey = GlobalKey<FormState>();
    String jinaWadhifa = wadhifaItem['jina_wadhifa'] ?? '';
    final TextEditingController controller =
        TextEditingController(text: jinaWadhifa);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Hariri Wadhifa',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primaryLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'Jina la Wadhifa',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.work_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tafadhali ingiza jina la wadhifa';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    jinaWadhifa = value ?? '';
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      try {
                        final currentUser = await UserManager.getCurrentUser();
                        if (currentUser == null) {
                          Navigator.pop(context);
                          return;
                        }

                        final response = await http.post(
                          Uri.parse(
                              "${ApiUrl.BASEURL}api2/wadhifa_kanisa/ongeza_wadhifa.php"),
                          headers: {'Accept': 'application/json'},
                          body: jsonEncode({
                            "id": wadhifaItem['id'],
                            "jina_wadhifa": jinaWadhifa,
                            "kanisa_id": currentUser.kanisaId,
                          }),
                        );

                        if (response.statusCode == 200) {
                          final jsonResponse = json.decode(response.body);

                          if (jsonResponse['status'] == 200) {
                            fetchWadhifa(); // Refresh the list

                            Navigator.pop(context); // Dismiss bottom sheet

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Wadhifa umebadilishwa kikamilifu',
                                  style: GoogleFonts.poppins(),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    jsonResponse['message'] ??
                                        'Imeshindwa kubadili wadhifa',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      } catch (e) {
                        if (kDebugMode) {
                          print("Error updating wadhifa: $e");
                        }
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Imeshindwa kubadili wadhifa',
                                style: GoogleFonts.poppins(),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryLight,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Hifadhi Mabadiliko',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCreateBottomSheet() {
    final formKey = GlobalKey<FormState>();
    String jinaWadhifa = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Ongeza Wadhifa',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primaryLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Jina la Wadhifa',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.work_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tafadhali ingiza jina la wadhifa';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    jinaWadhifa = value ?? '';
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      try {
                        final currentUser = await UserManager.getCurrentUser();
                        if (currentUser == null) {
                          Navigator.pop(context);
                          return;
                        }

                        final response = await http.post(
                          Uri.parse("${ApiUrl.BASEURL}create_wadhifa.php"),
                          headers: {'Accept': 'application/json'},
                          body: jsonEncode({
                            "jina_wadhifa": jinaWadhifa,
                            "kanisa_id": currentUser.kanisaId,
                            "tarehe": DateTime.now().toIso8601String(),
                          }),
                        );

                        if (response.statusCode == 200) {
                          final jsonResponse = json.decode(response.body);
                          if (jsonResponse['status'] == '200') {
                            Navigator.pop(context);
                            fetchWadhifa(); // Refresh the list
                          } else {
                            // Show error
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    jsonResponse['message'] ??
                                        'Failed to create wadhifa',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      } catch (e) {
                        if (kDebugMode) {
                          print("Error creating wadhifa: $e");
                        }
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Failed to create wadhifa',
                                style: GoogleFonts.poppins(),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateBottomSheet,
        backgroundColor: MyColors.primaryLight,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                style: GoogleFonts.poppins(color: MyColors.darkText),
                decoration: InputDecoration(
                  hintText: 'Tafuta wadhifa...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onChanged: _filterWadhifa,
              )
            : Text(
                'Nyadhifa Za Uongozi',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: MyColors.darkText),
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  _filteredWadhifa.clear();
                  _filteredWadhifa.addAll(_wadhifa);
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
        backgroundColor: MyColors.white,
        foregroundColor: MyColors.darkText,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    child: Lottie.asset(
                      'assets/animation/loading.json',
                      height: 100,
                    ),
                  ),
                  Text(
                    'Inapakia...',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
            onRefresh: fetchWadhifa,
            child:
          _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _error = null;
                          });
                          fetchWadhifa();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.primaryLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Jaribu tena',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              : _filteredWadhifa.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 48,
                            color: Colors.blue.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Hakuna nyadhifa zilizopatikana',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredWadhifa.length,
                      itemBuilder: (context, index) {
                        final wadhifaItem = _filteredWadhifa[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _showEditBottomSheet(wadhifaItem),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: MyColors.primaryLight
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.work_rounded,
                                          color: MyColors.primaryLight,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              wadhifaItem['jina_wadhifa'] ??
                                                  'Unknown',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: MyColors.darkText,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Tarehe: ${wadhifaItem['tarehe'] ?? 'N/A'}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Colors.grey[600],
                                        ),
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            _showEditBottomSheet(wadhifaItem);
                                          } else if (value == 'delete') {
                                            _showDeleteDialog(wadhifaItem);
                                          }
                                        },
                                        itemBuilder: (BuildContext context) => [
                                          PopupMenuItem(
                                            value: 'edit',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.edit_rounded,
                                                  color: MyColors.primaryLight,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  'Hariri',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.delete_rounded,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  'Futa',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
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
                      },
                    ),
    ),);
  }
}
