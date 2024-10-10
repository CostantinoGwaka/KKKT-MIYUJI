import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miyuji/models/video_kwaya.dart';
import 'package:miyuji/utils/ApiUrl.dart';
import 'package:miyuji/utils/TextStyles.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

List<dynamic> videoList = [];
late List<YoutubePlayerController> _controllers;

/// Creates list of video players
class VideoListScreen extends StatefulWidget {
  final dynamic kwayaid;
  const VideoListScreen({
    Key? key,
    this.kwayaid,
  }) : super(key: key);

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  bool load = false;
  Future<List<dynamic>> getVideoKwaya() async {
    setState(() {
      load = true;
    });
    String myApi = "${ApiUrl.BASEURL}get_video_kwaya.php/";
    final response = await http.post(myApi as Uri, headers: {
      'Accept': 'application/json',
    }, body: {
      "kwaya_id": '${widget.kwayaid}',
    });

    // ignore: prefer_typing_uninitialized_variables
    var tangazo;

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        tangazo = json;
      }
    }

    videoList.clear();

    tangazo.forEach(
      (element) {
        VideoKwaya video = VideoKwaya.fromJson(element);
        videoList.add(video.videoId);
      },
    );
    setState(() {
      load = false;
    });
    // print("videoid $videoList");
    setState(() {
      videoList = videoList;
    });
    return videoList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // videoList.clear();
    getVideoKwaya();
    print("video is $videoList");
    _controllers = videoList
        .map<YoutubePlayerController>(
          (videoId) => YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back_ios),
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
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: YoutubePlayer(
                key: ObjectKey(_controllers[index]),
                controller: _controllers[index],
                actionsPadding: const EdgeInsets.only(left: 16.0),
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
          );
        },
        itemCount: _controllers.length,
        separatorBuilder: (context, _) => const SizedBox(height: 10.0),
      ),
    );
  }
}
