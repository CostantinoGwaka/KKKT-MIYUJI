// ignore_for_file: use_build_context_synchronously, use_super_parameters, depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import '../../shared/alerts.dart';
import 'package:lottie/lottie.dart';

class VideoKwayaScreen extends StatefulWidget {
  const VideoKwayaScreen({Key? key}) : super(key: key);

  @override
  State<VideoKwayaScreen> createState() => _VideoKwayaScreenState();
}

class _VideoKwayaScreenState extends State<VideoKwayaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _kwayaController = TextEditingController();
  final TextEditingController _videoIdController = TextEditingController();
  BaseUser? currentUser;
  bool isLoading = false;
  List<Map<String, dynamic>> kwayaVideos = [];

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

    try {
      String myApi = "${ApiUrl.BASEURL}get_kwaya_videos.php";
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
        if (jsonResponse['status'] == '200') {
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
      String myApi = "${ApiUrl.BASEURL}add_kwaya_video.php";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "kwaya": _kwayaController.text,
          "video_id": _videoIdController.text,
          "kanisa_id": currentUser?.kanisaId ?? '',
          "tarehe": DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == '200') {
          Alerts.showMessage(context, "Video added successfully!");
          _clearForm();
          _fetchKwayaVideos();
        } else {
          Alerts.showMessage(
              context, jsonResponse['message'] ?? "Failed to add video");
        }
      }
    } catch (e) {
      Alerts.showMessage(context, "Error adding video: $e");
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
      String myApi = "${ApiUrl.BASEURL}update_kwaya_video.php";
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
        if (jsonResponse['status'] == '200') {
          Alerts.showMessage(context, "Video updated successfully!");
          _clearForm();
          _fetchKwayaVideos();
        } else {
          Alerts.showMessage(
              context, jsonResponse['message'] ?? "Failed to update video");
        }
      }
    } catch (e) {
      Alerts.showMessage(context, "Error updating video: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteKwayaVideo(String id) async {
    try {
      String myApi = "${ApiUrl.BASEURL}delete_kwaya_video.php";
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
        if (jsonResponse['status'] == '200') {
          Alerts.showMessage(context, "Video deleted successfully!");
          _fetchKwayaVideos();
        } else {
          Alerts.showMessage(
              context, jsonResponse['message'] ?? "Failed to delete video");
        }
      }
    } catch (e) {
      Alerts.showMessage(context, "Error deleting video: $e");
    }
  }

  void _clearForm() {
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
                  DropdownMenuItem(value: 0, child: Text('Kwaya Kuu')),
                  DropdownMenuItem(value: 1, child: Text('Kwaya ya Vijana')),
                  DropdownMenuItem(
                      value: 2, child: Text('Kwaya ya Uinjilisti')),
                  DropdownMenuItem(value: 3, child: Text('Kwaya ya Nazareti')),
                  DropdownMenuItem(value: 4, child: Text('Praise Team')),
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
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
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
                _updateKwayaVideo(video['id']);
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
              video == null ? 'Add' : 'Update',
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kwaya Videos',
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
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    child: Lottie.asset(
                      'assets/animation/loading.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Loading...',
                    style: GoogleFonts.poppins(),
                  ),
                ],
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
                  itemCount: kwayaVideos.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final video = kwayaVideos[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          video['kwaya'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Video ID: ${video['video_id']}',
                          style: GoogleFonts.poppins(),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showAddEditDialog(video: video),
                              color: Colors.blue,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteKwayaVideo(video['id']),
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
}
