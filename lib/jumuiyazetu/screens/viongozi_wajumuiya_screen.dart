// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, deprecated_member_use

import 'dart:convert';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanisaapp/models/viongozi_jumuiya.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/TextStyles.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ViongoziJumuiya extends StatefulWidget {
  final dynamic jumuiya;
  const ViongoziJumuiya({super.key, this.jumuiya});

  @override
  _ViongoziJumuiyaState createState() => _ViongoziJumuiyaState();
}

class _ViongoziJumuiyaState extends State<ViongoziJumuiya> {
  Future<List<ViongoziJumuiyaPodo>> getWatumishiWasharika() async {
    String myApi = "${ApiUrl.BASEURL}get_jumuiya_viongozi_id.php";
    final response = await http.post(
      Uri.parse(myApi),
      body: jsonEncode({
        "jumuiya_id": widget.jumuiya.id,
      }),
      headers: {
        'Accept': 'application/json',
      },
    );

    var barazaList = <ViongoziJumuiyaPodo>[];

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        if (json is Map &&
            json.containsKey('data') &&
            json['data'] != null &&
            json['data'] is List) {
          barazaList = (json['data'] as List)
              .map((item) => ViongoziJumuiyaPodo.fromJson(item))
              .toList();
        }
      }
    }
    return barazaList;
  }

  Future<void> _pullRefresh() async {
    getWatumishiWasharika().then((value) {
      setState(() {
        //finish
      });
      return;
    });
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
          "Watumishi wa jumuiya",
          style: TextStyles.headline(context).copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: MyColors.primaryLight,
          ),
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: StreamBuilder(
          //Error number 2
          stream: getWatumishiWasharika().asStream(),
          builder:
              (context, AsyncSnapshot<List<ViongoziJumuiyaPodo>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(60.0),
                    child: Column(
                      children: [
                        SizedBox(
                          child: Lottie.asset(
                            'assets/animation/fetching.json',
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Material(
                          child: Text(
                            "Inapanga taarifa",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.0,
                              color: MyColors.primaryLight,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return RefreshIndicator(
                onRefresh: _pullRefresh,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            SizedBox(
                              child: Lottie.asset(
                                'assets/animation/nodata.json',
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Material(
                              child: Text(
                                "Hakuna taarifa zilizopatikana",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0,
                                  color: MyColors.primaryLight,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 4.0),
                    child: Card(
                      elevation: 2,
                      shadowColor: MyColors.primaryLight.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: ExpansionTileCard(
                        baseColor: MyColors.white,
                        expandedColor: Colors.red[50],
                        elevation: 0,
                        leading: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: MyColors.primaryLight.withOpacity(0.2)),
                          ),
                          child: CircleAvatar(
                            backgroundColor: MyColors.white,
                            radius: 20,
                            child: Image.asset("assets/images/profile.png"),
                          ),
                        ),
                        title: Text(
                          snapshot.data![index].fname!,
                          style: TextStyles.headline(context).copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          snapshot.data![index].wadhifa!,
                          style: TextStyles.caption(context).copyWith(
                            fontSize: 11,
                            color: MyColors.primaryLight.withOpacity(0.7),
                          ),
                        ),
                        children: <Widget>[
                          const Divider(thickness: 1.0, height: 1.0),
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                _buildInfoRow(
                                  context,
                                  leading: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data![index].fname!,
                                            style: TextStyles.body2(context)
                                                .copyWith(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            snapshot.data![index].phoneNo!,
                                            style: TextStyles.body2(context)
                                                .copyWith(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: InkWell(
                                    onTap: () => launch(
                                        "tel://${snapshot.data![index].phoneNo}"),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: MyColors.primaryLight,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: MyColors.primaryLight
                                                .withOpacity(0.3),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(Icons.call,
                                          color: MyColors.white, size: 16),
                                    ),
                                  ),
                                ),
                                const Divider(height: 18),
                                _buildInfoRow(
                                  context,
                                  label: "Jina La Jumuiya",
                                  value: snapshot.data![index].jumuiya!,
                                ),
                                const Divider(height: 18),
                                _buildInfoRow(
                                  context,
                                  label: "Tarehe ya kuadiwa",
                                  value: snapshot.data![index].tarehe!,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Text("new videos");
            }
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    Widget? leading,
    String? label,
    String? value,
    Widget? trailing,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (leading != null)
          Expanded(child: leading)
        else
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (label != null)
                  Text(
                    label,
                    style: TextStyles.caption(context).copyWith(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                if (value != null)
                  Text(
                    value,
                    style: TextStyles.body2(context).copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        if (trailing != null) trailing,
      ],
    );
  }
}
