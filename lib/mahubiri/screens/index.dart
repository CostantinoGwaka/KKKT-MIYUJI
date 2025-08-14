// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanisaapp/models/mahubiri_model.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

/// Creates list of video players
class MahubiriScreen extends StatefulWidget {
  const MahubiriScreen({super.key});

  @override
  _MahubiriScreenState createState() => _MahubiriScreenState();
}

class _MahubiriScreenState extends State<MahubiriScreen> {
  List<Mahubiri> _mahubiriList = [];
  List<YoutubePlayerController> _controllers = [];
  List<Mahubiri> filteredMahubiri = [];
  bool isSearching = false;
  BaseUser? currentUser;
  TextEditingController searchController = TextEditingController();
  Future<List<Mahubiri>>? _mahubiriFuture;

  @override
  void initState() {
    super.initState();
    _initializeData();
    searchController.addListener(_onSearchChanged);
  }

  Future<void> _initializeData() async {
    await checkLogin();
    setState(() {
      _mahubiriFuture = _fetchMahubiri();
    });
  }

  Future<List<Mahubiri>> _fetchMahubiri() async {
    currentUser = await UserManager.getCurrentUser();
    try {
      final response = await http.post(
        Uri.parse('${ApiUrl.BASEURL}get_mahubiri_kanisa.php'),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        _mahubiriList = (jsonResponse['data'] as List)
            .map((item) => Mahubiri.fromJson(item))
            .toList();

        _controllers = _mahubiriList
            .map((mahubiri) => YoutubePlayerController(
                  initialVideoId: mahubiri.videoId,
                  flags: const YoutubePlayerFlags(
                    autoPlay: false,
                  ),
                ))
            .toList();

        filteredMahubiri = _mahubiriList;
        return _mahubiriList;
      } else {
        throw Exception('Failed to load mahubiri');
      }
    } catch (e) {
      _showError('Error: $e');
      return [];
    }
  }

  void _onSearchChanged() {
    if (searchController.text.isEmpty) {
      setState(() {
        filteredMahubiri = _mahubiriList;
      });
    } else {
      setState(() {
        filteredMahubiri = _mahubiriList
            .where((mahubiri) => mahubiri.mahubiriName
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
      });
    }
  }

  Future<void> checkLogin() async {
    BaseUser? user = await UserManager.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: MyColors.primaryLight,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded,
                    color: Colors.white),
                onPressed: () {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitDown,
                    DeviceOrientation.portraitUp,
                  ]);
                  Navigator.pop(context);
                },
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    isSearching ? Icons.close_rounded : Icons.search_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
                      if (!isSearching) {
                        searchController.clear();
                        filteredMahubiri = _mahubiriList;
                      }
                    });
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      MyColors.primaryLight,
                      MyColors.primaryLight.withOpacity(0.8),
                      Colors.blue.withOpacity(0.6),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Hero(
                        tag: 'mahubiri_icon',
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.video_library_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Mahubiri",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Mahubiri ya kanisani",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (isSearching)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: searchController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Tafuta mahubiri...',
                              hintStyle: const TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              prefixIcon: const Icon(Icons.search,
                                  color: Colors.white70),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          FutureBuilder<List<Mahubiri>>(
            future: _mahubiriFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text('No mahubiri available'),
                  ),
                );
              }

              final displayedMahubiri = searchController.text.isEmpty
                  ? snapshot.data!
                  : filteredMahubiri;

              return SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final mahubiri = displayedMahubiri[index];
                      final controller =
                          _controllers[_mahubiriList.indexOf(mahubiri)];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mahubiri.mahubiriName,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Tarehe: ${mahubiri.tarehe}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(15.0),
                                ),
                                child: YoutubePlayer(
                                  key: ObjectKey(controller),
                                  controller: controller,
                                  actionsPadding:
                                      const EdgeInsets.only(left: 16.0),
                                  bottomActions: const [
                                    CurrentPosition(),
                                    SizedBox(width: 10.0),
                                    ProgressBar(isExpanded: true),
                                    SizedBox(width: 10.0),
                                    RemainingDuration(),
                                    FullScreenButton(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: displayedMahubiri.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
