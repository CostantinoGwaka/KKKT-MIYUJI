// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanisaapp/models/video_kwaya.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/TextStyles.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:lottie/lottie.dart';

List<VideoKwaya> videoList = [];
late List<YoutubePlayerController> _controllers;

/// Creates list of video players
class VideoListScreen extends StatefulWidget {
  final dynamic kwayaid;
  const VideoListScreen({
    super.key,
    this.kwayaid,
  });

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  bool load = false;
  Future<List<VideoKwaya>> getVideoKwaya() async {
    setState(() {
      load = true;
    });

    String myApi = "${ApiUrl.BASEURL}get_video_kwaya.php/";

    try {
      final response = await http.post(Uri.parse(myApi), headers: {
        'Accept': 'application/json',
      }, body: jsonEncode(
        {
        "kwaya_id": '${widget.kwayaid}',
        "kanisa_id": '1',
      }
      ));


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
    getVideoKwaya().then((_) {
      if (mounted) {
        setState(() {
          _controllers = videoList
              .map<YoutubePlayerController>(
                (videoId) {
                  return YoutubePlayerController(
                  initialVideoId: videoId.videoId.toString(),
                  flags: const YoutubePlayerFlags(
                    autoPlay: false,
                     disableDragSeek: false,
                      loop: false,
                      isLive: false,
                      forceHD: false,
                      enableCaption: true,
                  ),
                );
              })
              .toList();
        });
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.grey[100],
      navigationBar: CupertinoNavigationBar(
        // ignore: deprecated_member_use
        backgroundColor: Colors.white.withOpacity(0.9),
        border: const Border(
          bottom: BorderSide(
            color: Colors.transparent,
            width: 0.0,
          ),
        ),
        leading: GestureDetector(
          child:  Icon(
            Icons.arrow_back_ios,
            color: MyColors.primaryLight,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        middle: Text(
          widget.kwayaid == 0
              ? "Kwaya Kuu"
              : widget.kwayaid == 1
                  ? "Kwaya ya Vijana"
                  : widget.kwayaid == 2
                      ? "Uinjilisti"
                      : widget.kwayaid == 3
                          ? "Nazareti"
                          : "Praise Team",
          style: TextStyles.headline(context).copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MyColors.primaryLight,
          ),
        ),
      ),
      child: load 
          ? Center(
              child: Lottie.asset(
                'assets/animation/loading.json',
                width: 200,
                height: 200,
              ),
            )
          : videoList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animation/nodata.json',
                        width: 200,
                        height: 200,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No videos available',
                        style: TextStyles.subtitle(context).copyWith(
                          color: MyColors.primaryLight,
                        ),
                      ),
                    ],
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    transform: Matrix4.translationValues(0, 0, 0)
                      ..scale(1.0),
                    child: Container(
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                        ),
                      ],
                      ),
                      child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Column(
                        children: [
                          Text(_controllers[index].metadata.title),
                          YoutubePlayer(
                          key: ObjectKey(_controllers[index]),
                          controller: _controllers[index],
                          actionsPadding: const EdgeInsets.only(left: 16.0),
                          bottomActions: [
                            const CurrentPosition(),
                            const SizedBox(width: 10.0),
                            const ProgressBar(isExpanded: true),
                            const SizedBox(width: 10.0),
                            const RemainingDuration(),
                            Container(
                            margin: const EdgeInsets.only(right: 8.0),
                            child: const FullScreenButton(),
                            ),
                          ],
                          ),
                          Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              // ignore: deprecated_member_use
                              Colors.black.withOpacity(0.05),
                            ],
                            ),
                          ),
                          ),
                        ],
                        ),
                      ),
                      ),
                    ),
                    );
                  },
                  itemCount: _controllers.length,
                  separatorBuilder: (context, _) => const SizedBox(height: 16.0),
                  ),
                )
    );
  }
}
