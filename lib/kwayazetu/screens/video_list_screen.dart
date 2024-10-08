import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinyerezi/models/matangazo.dart';
import 'package:kinyerezi/models/video_kwaya.dart';
import 'package:kinyerezi/utils/TextStyles.dart';
import 'package:kinyerezi/utils/my_colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

List<dynamic> videoList = [];
List<YoutubePlayerController> _controllers;

/// Creates list of video players
class VideoListScreen extends StatefulWidget {
  final dynamic kwayaid;
  const VideoListScreen({
    Key key,
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
    String myApi = "http://kinyerezikkkt.or.tz/api/get_video_kwaya.php/";
    final response = await http.post(myApi, headers: {
      'Accept': 'application/json',
    }, body: {
      "kwaya_id": '${widget.kwayaid}',
    });

    var matangazoList = new Map();
    var tangazo;

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print("data video ${response.body}");
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
    print("videoid $videoList");
    setState(() {
      videoList = videoList;
    });
    // return videoList;
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
          child: Icon(Icons.arrow_back_ios),
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
        physics: BouncingScrollPhysics(),
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
                bottomActions: [
                  CurrentPosition(),
                  const SizedBox(width: 10.0),
                  ProgressBar(isExpanded: true),
                  const SizedBox(width: 10.0),
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
