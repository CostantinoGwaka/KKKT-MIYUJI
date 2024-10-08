import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kinyerezi/utils/TextStyles.dart';
import 'package:kinyerezi/utils/my_colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Creates list of video players
class MahubiriScreen extends StatefulWidget {
  @override
  _MahubiriScreenState createState() => _MahubiriScreenState();
}

class _MahubiriScreenState extends State<MahubiriScreen> {
  final List<YoutubePlayerController> _controllers = [
    'DrO-jEqQAkE',
    '107XsuZ93Hg',
    'x8muNhrQjtg',
    'mHLmOotdv_c',
    'TXepCfWV9jE',
    'sLccaUGc23g',
    'Ts_Eb8ocuJw',
    'vMNz1NugNvU',
  ]
      .map<YoutubePlayerController>(
        (videoId) => YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
          ),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios),
          onTap: () {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitDown,
              DeviceOrientation.portraitUp,
            ]);
            Navigator.pop(context);
          },
        ),
        middle: Text(
          "Mahubiri",
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
