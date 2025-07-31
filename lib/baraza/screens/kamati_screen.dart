import 'dart:convert';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanisaapp/baraza/screens/viongozi_kamati_screen.dart';
import 'package:kanisaapp/models/kamatiusharika.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/TextStyles.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/spacer.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class KamatiUsharikaScreen extends StatefulWidget {
  const KamatiUsharikaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _KamatiUsharikaScreenState createState() => _KamatiUsharikaScreenState();
}

class _KamatiUsharikaScreenState extends State<KamatiUsharikaScreen> {
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();

  List<KamatiUsharika> listkamati = <KamatiUsharika>[];

  Future<List<KamatiUsharika>> getMatangazoNew() async {
    String myApi = "${ApiUrl.BASEURL}get_kamati.php";
    final response = await http.post(Uri.parse(myApi), headers: {'Accept': 'application/json'});

    var kamatilist = <KamatiUsharika>[];
    var kamati;

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        kamati = json;
      }
    }

    kamati.forEach(
      (element) {
        KamatiUsharika video = KamatiUsharika.fromJson(element);
        kamatilist.add(video);
      },
    );
    return kamatilist;
  }

  Future<void> _pullRefresh() async {
    getMatangazoNew().then((value) {
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
          "Kamati za usharika",
          style: TextStyles.headline(context).copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MyColors.primaryLight,
          ),
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: StreamBuilder(
          //Error number 2
          stream: getMatangazoNew().asStream(),
          builder: (context, AsyncSnapshot<List<KamatiUsharika>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(90.0),
                    child: Column(
                      children: [
                        SizedBox(
                          child: Lottie.asset(
                            'assets/animation/fetching.json',
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Material(
                          child: Text(
                            "Inapanga taarifa",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              color: MyColors.primaryLight,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError || !snapshot.hasData) {
              return RefreshIndicator(
                onRefresh: _pullRefresh,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(70.0),
                      child: Column(
                        children: [
                          SizedBox(
                            child: Lottie.asset(
                              'assets/animation/nodata.json',
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Material(
                            child: Text(
                              "Hakuna taarifa zilizopatikana",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                color: MyColors.primaryLight,
                              ),
                            ),
                          )
                        ],
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
                  return Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ViongoziWaKamati(
                              kamati: snapshot.data![index],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: MyColors.primaryLight, width: 2.0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: MyColors.primaryLight,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: deviceWidth(context) / 50,
                                  vertical: deviceWidth(context) / 30,
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        snapshot.data![index].jinaKamati!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: MyColors.primaryLight,
                                          fontSize: deviceHeight(context) / 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
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
              );
            } else {
              return const Text("new videos");
            }
          },
        ),
      ),
    );
  }
}
