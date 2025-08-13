// ignore_for_file: use_build_context_synchronously, use_super_parameters, depend_on_referenced_packages, deprecated_member_use

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
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoKwayaScreen extends StatefulWidget {
  const VideoKwayaScreen({Key? key}) : super(key: key);

  @override
  State<VideoKwayaScreen> createState() => _VideoKwayaScreenState();
}

class _VideoKwayaScreenState extends State<VideoKwayaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _kwayaController = TextEditingController();
  final TextEditingController _videoIdController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  BaseUser? currentUser;
  bool isLoading = false;
  bool _isSearching = false;
  List<Map<String, dynamic>> kwayaVideos = [];
  List<Map<String, dynamic>> _filteredVideos = [];

  void _filterVideos(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredVideos = List.from(kwayaVideos);
      } else {
        _filteredVideos = kwayaVideos
            .where((video) =>
                (() {
                  switch (video['kwaya']) {
                    case '0':
                      return 'Kwaya Kuu';
                    case '1':
                      return 'Kwaya ya Vijana';
                    case '2':
                      return 'Kwaya ya Uinjilisti';
                    case '3':
                      return 'Kwaya ya Nazareti';
                    case '4':
                      return 'Praise Team';
                    default:
                      return 'Unknown Kwaya';
                  }
                })()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                video['video_id']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _fetchKwayaVideos();
  }

  Future<void> _loadCurrentUser() async {
    BaseUser? user = await UserManager.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  Future<void> _fetchKwayaVideos() async {
    setState(() {
      isLoading = true;
    });
    BaseUser? user = await UserManager.getCurrentUser();
    setState(() {
      currentUser = user;
    });
    try {
      String myApi = "${ApiUrl.BASEURL}api2/kwaya_kanisa/get_kwaya_videos.php";
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
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == "200") {
          setState(() {
            kwayaVideos = List<Map<String, dynamic>>.from(jsonResponse['data']);
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching kwaya videos: $e");
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addKwayaVideo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      String myApi =
          "${ApiUrl.BASEURL}api2/kwaya_kanisa/ongeza_kwaya_video.php";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "kwaya": _kwayaController.text,
          "video_id": _videoIdController.text,
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Video imeongezwa kikamilifu!",
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.green,
            ),
          );
          clearForm();
          _fetchKwayaVideos();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                jsonResponse['message'] ?? "imeshindwa kuongeza video",
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
            "Error adding video: $e",
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

  Future<void> _updateKwayaVideo(String id) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      String myApi =
          "${ApiUrl.BASEURL}api2/kwaya_kanisa/ongeza_kwaya_video.php";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "id": id,
          "kwaya": _kwayaController.text,
          "video_id": _videoIdController.text,
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Video imesahihishwa kikamirifu!",
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.green,
            ),
          );
          clearForm();
          _fetchKwayaVideos();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                jsonResponse['message'] ?? "imeshindwa kusasisha video",
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
            "Error updating video: $e",
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

  Future<void> _deleteKwayaVideo(String id) async {
    try {
      String myApi =
          "${ApiUrl.BASEURL}api2/kwaya_kanisa/delete_kwaya_video.php";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "id": id,
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == "200") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Video imefutwa kikamilifu!",
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.green,
            ),
          );
          _fetchKwayaVideos();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                jsonResponse['message'] ?? "imeshindwa kufuta video",
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
            "kuna changamoto kwenye kufuta video: $e",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void clearForm() {
    _kwayaController.clear();
    _videoIdController.clear();
  }

  void _showAddEditDialog({Map<String, dynamic>? video}) {
    if (video != null) {
      _kwayaController.text = video['kwaya'];
      _videoIdController.text = video['video_id'];
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          video == null ? 'Add New Video' : 'Edit Video',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: _kwayaController.text.isEmpty
                    ? null
                    : int.tryParse(_kwayaController.text),
                decoration: InputDecoration(
                  labelText: 'Chagua Kwaya',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Kwaya Kuu')),
                  DropdownMenuItem(value: 2, child: Text('Kwaya ya Vijana')),
                  DropdownMenuItem(
                      value: 3, child: Text('Kwaya ya Uinjilisti')),
                  DropdownMenuItem(value: 4, child: Text('Kwaya ya Nazareti')),
                  DropdownMenuItem(value: 5, child: Text('Praise Team')),
                ],
                onChanged: (value) {
                  setState(() {
                    _kwayaController.text = value.toString();
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Tafadhari chagua kwaya';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _videoIdController,
                decoration: InputDecoration(
                  labelText: 'Video ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter video ID';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => {clearForm(), Navigator.pop(context)},
            child: Text(
              'Sitisha',
              style: GoogleFonts.poppins(
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (video == null) {
                _addKwayaVideo();
              } else {
                _updateKwayaVideo(video['id'].toString());
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.primaryLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              video == null ? 'Ongeza' : 'Sasisha',
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
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _fetchKwayaVideos,
      child: Scaffold(
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
                  onChanged: _filterVideos,
                )
              : Text(
                  'Kwaya Videos',
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
                    _filteredVideos = List.from(kwayaVideos);
                  } else {
                    _isSearching = true;
                    _filteredVideos = List.from(kwayaVideos);
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
            : kwayaVideos.isEmpty
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
                        const SizedBox(height: 20),
                        Text(
                          'No videos available',
                          style: GoogleFonts.poppins(),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _isSearching
                        ? _filteredVideos.length
                        : kwayaVideos.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final video = _isSearching
                          ? _filteredVideos[index]
                          : kwayaVideos[index];
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    (() {
                                      switch (video['kwaya']) {
                                        case '1':
                                          return 'Kwaya Kuu';
                                        case '2':
                                          return 'Kwaya ya Vijana';
                                        case '3':
                                          return 'Kwaya ya Uinjilisti';
                                        case '4':
                                          return 'Kwaya ya Nazareti';
                                        case '5':
                                          return 'Praise Team';
                                        default:
                                          return 'Unknown Kwaya';
                                      }
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
                                            _showAddEditDialog(video: video),
                                        color: Colors.blue,
                                      ),
                                      IconButton(
                                        icon:
                                            const Icon(Icons.delete, size: 20),
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
                                                    clearForm(),
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
                                                    _deleteKwayaVideo(
                                                        video['id'].toString());
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    shape:
                                                        RoundedRectangleBorder(
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
                                          'Video ID: ${video['video_id']}',
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
                                        'Tarehe: ${video['tarehe']?.toString().split(' ')[0] ?? 'N/A'}',
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
                                  initialVideoId: video['video_id'].toString(),
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
                    },
                  ),
      ),
    );
  }
}
