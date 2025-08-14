// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  List<Map<String, dynamic>> filteredMahubiri = [];
  bool isLoading = false;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _fetchMahubiri();
    filteredMahubiri = mahubiriList;
  }

  void _filterMahubiri(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredMahubiri = mahubiriList;
      } else {
        filteredMahubiri = mahubiriList
            .where((mahubiri) =>
                mahubiri['mahubiri_name']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                mahubiri['video_id']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                mahubiri['tarehe']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
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
    currentUser = await UserManager.getCurrentUser();

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
        if (jsonResponse['status'] == "200") {
          setState(() {
            mahubiriList =
                List<Map<String, dynamic>>.from(jsonResponse['data']);
            filteredMahubiri = List.from(mahubiriList);
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
        if (jsonResponse['status'] == 200) {
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
        if (jsonResponse['status'] == 200) {
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
                  labelText: 'Jina la Mahubiri',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _videoIdController,
                decoration: InputDecoration(
                  labelText: 'Namba ya Video',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _tareheController,
                decoration: InputDecoration(
                  labelText: 'Tarehe',
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
              'Ghairi',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (mahubiri == null) {
                _addMahubiri();
              } else {
                _updateMahubiri(mahubiri['id'].toString());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.primaryLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              mahubiri == null ? 'Ongeza' : 'Sahihisha',
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
        title: _isSearching
            ? TextField(
                controller: _searchController,
                style: GoogleFonts.poppins(color: MyColors.darkText),
                decoration: InputDecoration(
                  hintText: 'Tafuta video...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onChanged: _filterMahubiri,
              )
            : Text(
                'Mahubiri Kanisani',
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
                  filteredMahubiri = List.from(mahubiriList);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: MyColors.primaryLight,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredMahubiri.isEmpty
              ? Center(
                  child: Text(
                    _isSearching
                        ? 'Hakuna mahubiri yaliyopatikana'
                        : 'Hakuna mahubiri yaliyopo',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: filteredMahubiri.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final mahubiri = filteredMahubiri[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  (() {
                                    return mahubiri['mahubiri_name'] ??
                                        'Jina la Mahubiri';
                                  })(),
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: MyColors.primaryLight,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 20),
                                      onPressed: () =>
                                          _showAddEditDialog(mahubiri),
                                      color: Colors.blue,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, size: 20),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                              'Delete Video',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            content: Text(
                                              'Are you sure you want to delete this video?',
                                              style: GoogleFonts.poppins(),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => {
                                                  Navigator.pop(context),
                                                },
                                                child: Text(
                                                  'Sitisha',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  _deleteMahubiri(mahubiri['id']
                                                      .toString());
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Delete',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Video ID: ${mahubiri['video_id']}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Tarehe: ${mahubiri['tarehe']?.toString().split(' ')[0] ?? 'N/A'}',
                                      style: const TextStyle(
                                        color: Color(0xFF757575),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                            child: YoutubePlayer(
                              controller: YoutubePlayerController(
                                initialVideoId: mahubiri['video_id'].toString(),
                                flags: const YoutubePlayerFlags(
                                  autoPlay: false,
                                  disableDragSeek: false,
                                  loop: false,
                                  isLive: false,
                                  forceHD: false,
                                  enableCaption: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    // return Card(
                    //   elevation: 2,
                    //   margin: const EdgeInsets.only(bottom: 16),
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   child: ListTile(
                    //     contentPadding: const EdgeInsets.all(16),
                    //     title: Text(
                    //       mahubiri['mahubiri_name'],
                    //       style: GoogleFonts.poppins(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 16,
                    //       ),
                    //     ),
                    //     subtitle: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         const SizedBox(height: 8),
                    //         Text(
                    //           'Namba ya Video: ${mahubiri['video_id']}',
                    //           style: GoogleFonts.poppins(
                    //             fontSize: 14,
                    //             color: Colors.grey[600],
                    //           ),
                    //         ),
                    //         Text(
                    //           'Tarehe: ${mahubiri['tarehe']}',
                    //           style: GoogleFonts.poppins(
                    //             fontSize: 14,
                    //             color: Colors.grey[600],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     trailing: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         IconButton(
                    //           icon: const Icon(Icons.edit),
                    //           onPressed: () => _showAddEditDialog(mahubiri),
                    //           color: Colors.blue,
                    //         ),
                    //         IconButton(
                    //           icon: const Icon(Icons.delete),
                    //           onPressed: () =>
                    //               _deleteMahubiri(mahubiri['id'].toString()),
                    //           color: Colors.red,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // );
                  },
                ),
    );
  }

  @override
  void dispose() {
    _mahubiriNameController.dispose();
    _videoIdController.dispose();
    _tareheController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
