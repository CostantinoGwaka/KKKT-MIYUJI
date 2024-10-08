import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:miyuji/kwayazetu/screens/video_list_screen.dart';
import 'package:miyuji/utils/TextStyles.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:miyuji/utils/spacer.dart';

class KwayaZetu extends StatefulWidget {
  const KwayaZetu({Key key}) : super(key: key);

  @override
  _KwayaZetuState createState() => _KwayaZetuState();
}

class _KwayaZetuState extends State<KwayaZetu> {
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
          "Kwaya zetu",
          style: TextStyles.headline(context).copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MyColors.primaryLight,
          ),
        ),
      ),
      child: Stack(
        children: [
          CustomScrollView(physics: BouncingScrollPhysics(), slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: deviceHeight(context) / 3,
              pinned: false,
              stretch: true,
              backgroundColor: MyColors.primaryLight,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: "msimu",
                  child: Image.asset(
                    "assets/images/kwaya.jpg",
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: deviceHeight(context) / 200),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Material(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoListScreen(kwayaid: 0)));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: MyColors.white,
                                ),
                                width: double.infinity,
                                height: 80,
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
                                        // Center(
                                        //   child: Image.asset(
                                        //     "assets/images/kwaya_logo.png",
                                        //     fit: BoxFit.cover,
                                        //     width: double.infinity,
                                        //   ),
                                        // ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: MyColors.white,

                                            // gradient: LinearGradient(
                                            //   colors: [
                                            //     Color(0xFF343434).withOpacity(0.4),
                                            //     Color(0xFF343434).withOpacity(0.15),
                                            //   ],
                                            // ),
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
                                                  'Kwaya Kuu',
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
                            ),
                          ),
                        ),
                        manualStepper(step: 5),
                        Material(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoListScreen(kwayaid: 1)));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: MyColors.white,
                                ),
                                width: double.infinity,
                                height: 80,
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: MyColors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 10,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Stack(
                                      children: [
                                        // Center(
                                        //   child: Image.asset(
                                        //     "assets/images/kwaya_logo.png",
                                        //     fit: BoxFit.cover,
                                        //     width: double.infinity,
                                        //   ),
                                        // ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: MyColors.primaryLight,

                                            // gradient: LinearGradient(
                                            //   colors: [
                                            //     Color(0xFF343434).withOpacity(0.4),
                                            //     Color(0xFF343434).withOpacity(0.15),
                                            //   ],
                                            // ),
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
                                                  'Kwaya ya Vijana',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: deviceHeight(context) / 30,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                manualStepper(step: deviceWidth(context) ~/ 50),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        manualStepper(step: 5),
                        Material(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoListScreen(kwayaid: 2)));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: MyColors.white,
                                ),
                                width: double.infinity,
                                height: 80,
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
                                        // Center(
                                        //   child: Image.asset(
                                        //     "assets/images/kwaya_logo.png",
                                        //     fit: BoxFit.cover,
                                        //     width: double.infinity,
                                        //   ),
                                        // ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: MyColors.white,

                                            // gradient: LinearGradient(
                                            //   colors: [
                                            //     Color(0xFF343434).withOpacity(0.4),
                                            //     Color(0xFF343434).withOpacity(0.15),
                                            //   ],
                                            // ),
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
                                                  'Kwaya ya Uinjilisti',
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
                            ),
                          ),
                        ),
                        manualStepper(step: 5),
                        Material(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoListScreen(kwayaid: 3)));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: MyColors.white,
                                ),
                                width: double.infinity,
                                height: 80,
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: MyColors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 10,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Stack(
                                      children: [
                                        // Center(
                                        //   child: Image.asset(
                                        //     "assets/images/kwaya_logo.png",
                                        //     fit: BoxFit.cover,
                                        //     width: double.infinity,
                                        //   ),
                                        // ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: MyColors.primaryLight,

                                            // gradient: LinearGradient(
                                            //   colors: [
                                            //     Color(0xFF343434).withOpacity(0.4),
                                            //     Color(0xFF343434).withOpacity(0.15),
                                            //   ],
                                            // ),
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
                                                  'Kwaya ya Nazareti',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: MyColors.white,
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
                            ),
                          ),
                        ),
                        manualStepper(step: 5),
                        Material(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoListScreen(kwayaid: 4)));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: MyColors.white,
                                ),
                                width: double.infinity,
                                height: 80,
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
                                        // Center(
                                        //   child: Image.asset(
                                        //     "assets/images/kwaya_logo.png",
                                        //     fit: BoxFit.cover,
                                        //     width: double.infinity,
                                        //   ),
                                        // ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: MyColors.white,

                                            // gradient: LinearGradient(
                                            //   colors: [
                                            //     Color(0xFF343434).withOpacity(0.4),
                                            //     Color(0xFF343434).withOpacity(0.15),
                                            //   ],
                                            // ),
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
                                                  'Praise Team',
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
                            ),
                          ),
                        ),
                        manualStepper(step: 5),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ])
        ],
      ),
    );
  }
}
