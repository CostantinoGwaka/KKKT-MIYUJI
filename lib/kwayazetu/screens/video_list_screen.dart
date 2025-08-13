// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, deprecated_member_use

import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/models/video_kwaya.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/TextStyles.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:lottie/lottie.dart';

List<VideoKwaya> videoList = [];
// late List<YoutubePlayerController> _controllers;

/// Creates list of video players
class VideoListScreen extends StatefulWidget {
  final dynamic kwayaid;
  final String? title;
  const VideoListScreen({
    super.key,
    this.kwayaid,
    this.title,
  });

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  bool load = false;

  BaseUser? currentUser;

  Future<void> _loadCurrentUser() async {
    try {
      currentUser = await UserManager.getCurrentUser();
      setState(() {});
    } catch (e) {
      // Handle error
    }
  }

  Future<List<VideoKwaya>> getVideoKwaya() async {
    setState(() {
      load = true;
      videoList = [];
    });

    String myApi = "${ApiUrl.BASEURL}get_video_kwaya.php/";

    try {
      await _loadCurrentUser();

      final response = await http.post(Uri.parse(myApi),
          headers: {
            'Accept': 'application/json',
          },
          body: jsonEncode({
            "kwaya_id": '${widget.kwayaid}',
            "kanisa_id": currentUser != null ? currentUser!.kanisaId : '',
          }));

      // ignore: prefer_typing_uninitialized_variables
      var videos;

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse != null && jsonResponse != 404) {
          var json = jsonDecode(response.body);
          if (json is Map &&
              json.containsKey('data') &&
              json['data'] != null &&
              json['data'] is List) {
            videos = (json['data'] as List)
                .map((item) => VideoKwaya.fromJson(item))
                .toList();

            setState(() {
              videoList = videos;
              load = false;
            });
          }
        } else {
          setState(() {
            videoList = [];
            load = false;
          });
          return [];
        }
      }
      return videos;
    } catch (e) {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    getVideoKwaya();
  }

  @override
  void dispose() {
    // for (var controller in _controllers) {
    //   controller.dispose();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: MyColors.primaryLight,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.kwayaid == 1
              ? "Kwaya Kuu"
              : widget.kwayaid == 2
                  ? "Kwaya ya Vijana"
                  : widget.kwayaid == 3
                      ? "Uinjilisti"
                      : widget.kwayaid == 4
                          ? "Nazareti"
                          : "Praise Team ${videoList.length} ${videoList.isEmpty}",
          style: TextStyles.headline(context).copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MyColors.primaryLight,
          ),
        ),
      ),
      body: load
          ? Center(
              child: Lottie.asset(
                'assets/animation/loading.json',
                width: 200,
                height: 200,
              ),
            )
          : videoList.isEmpty
              ? Text(
                  'No videos available',
                  style: TextStyles.subtitle(context).copyWith(
                    color: MyColors.nearlyBlack,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        transform: Matrix4.translationValues(0, 0, 0)
                          ..scale(1.0),
                        child: Container(
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
                                        return widget.title ?? 'Kwaya Videos';
                                      })(),
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: MyColors.primaryLight,
                                      ),
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
                                            'Video ID: ${videoList[index].videoId}',
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
                                          'Tarehe: ${videoList[index].tarehe?.toString().split(' ')[0] ?? 'N/A'}',
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
                                    initialVideoId:
                                        videoList[index].videoId.toString(),
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
                        ),
                      );
                    },
                    itemCount: videoList.length,
                  ),
                ),
    );
  }
}
