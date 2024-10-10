import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miyuji/models/livestream.dart';
import 'package:miyuji/utils/TextStyles.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

var videoId = '';

class LiveYoutubePlayer extends StatefulWidget {
  final LiveStreams? media;
  const LiveYoutubePlayer({Key? key, this.media}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<LiveYoutubePlayer> with WidgetsBindingObserver {
  late YoutubePlayerController _controller;
  bool load = false;

  Future<dynamic> getVideoId() async {
    setState(() {
      load = true;
    });
    String myApi = "https://kkktmiyuji.nitusue.com/api/get_streamId.php";
    final response = await http.post(
      Uri.parse(myApi),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        setState(() {
          videoId = json;
          load = false;
        });
      }
    }

    setState(() {});
    return videoId;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getVideoId().whenComplete(() {
      setState(() {});
    });
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        hideControls: true,
        loop: false,
        isLive: true,
        forceHD: false,
        enableCaption: true,
      ),
    );
    super.initState();
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _controller.dispose();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();

    super.dispose();
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
          "Mubashara",
          style: TextStyles.headline(context).copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MyColors.primaryLight,
          ),
        ),
      ),
      child: Stack(
        children: <Widget>[
          _buildWidgetAlbumCoverBlur(),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.5),
              ],
            )),
          ),
          load
              ? CircularProgressIndicator(
                  color: MyColors.primary,
                )
              : FutureBuilder(
                  future: getVideoId(),
                  builder: (_, index) {
                    return Column(
                      children: <Widget>[
                        Expanded(
                          child: YoutubePlayer(
                            controller: _controller,
                            showVideoProgressIndicator: true,
                            bottomActions: const <Widget>[
                              SizedBox(width: 14.0),
                              CurrentPosition(),
                              SizedBox(width: 8.0),
                              ProgressBar(isExpanded: true),
                              RemainingDuration(),
                              PlaybackSpeedButton(),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
        ],
      ),
    );
  }

  Widget _buildWidgetAlbumCoverBlur() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: NetworkImage("https://www.technocrazed.com/wp-content/uploads/2015/12/Landscape-wallpaper-36.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.0),
          ),
        ),
      ),
    );
  }
}
