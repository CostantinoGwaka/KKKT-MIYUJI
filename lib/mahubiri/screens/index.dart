// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kanisaapp/models/mahubiri_model.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/TextStyles.dart';
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
  bool _isLoading = true;
  BaseUser? currentUser;

  @override
  void initState() {
    super.initState();
    _fetchMahubiri();
  }

  Future<void> _fetchMahubiri() async {
    currentUser = await UserManager.getCurrentUser();
    setState(() {
      _isLoading = true;
    });
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
        setState(() {
          setState(() {
            _mahubiriList = (jsonResponse['data'] as List)
                .map((item) => Mahubiri.fromJson(item))
                .toList();
          });
          _controllers = _mahubiriList
              .map((mahubiri) => YoutubePlayerController(
                    initialVideoId: mahubiri.videoId,
                    flags: const YoutubePlayerFlags(
                      autoPlay: false,
                    ),
                  ))
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        _showError('Failed to load mahubiri');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Error: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back_ios),
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
      child: _isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : _controllers.isEmpty
              ? const Center(child: Text('No mahubiri available'))
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final mahubiri = _mahubiriList[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mahubiri.mahubiriName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Tarehe: ${mahubiri.tarehe}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ClipRRect(
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
                        ],
                      ),
                    );
                  },
                  itemCount: _controllers.length,
                  separatorBuilder: (context, _) =>
                      const SizedBox(height: 10.0),
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
