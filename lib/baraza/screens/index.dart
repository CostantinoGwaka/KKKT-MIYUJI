import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kanisaapp/baraza/screens/baraza_wazee_screen.dart';
import 'package:kanisaapp/baraza/screens/kamati_screen.dart';
import 'package:kanisaapp/baraza/screens/walimu_screen.dart';
import 'package:kanisaapp/baraza/screens/watumishi_screen.dart';
import 'package:kanisaapp/utils/TextStyles.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/spacer.dart';

class BarazaLaWazee extends StatefulWidget {
  const BarazaLaWazee({super.key});

  @override
  _BarazaLaWazeeState createState() => _BarazaLaWazeeState();
}

class _BarazaLaWazeeState extends State<BarazaLaWazee> {
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
          "Baraza la wazee",
          style: TextStyles.headline(context).copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MyColors.primaryLight,
          ),
        ),
      ),
      child: Stack(
        children: [
          CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
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
                    "assets/images/miyuji_2.jpg",
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
                          //chnages
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              onTap: () {
                                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => WatumishiScreen()));
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: MyColors.white,
                                ),
                                width: double.infinity,
                                height: 80,
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(color: MyColors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 10,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Stack(
                                      children: [
                                        // Center(
                                        //   child: Image.asset(
                                        //     "assets/images/topbanner.png",
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
                                                  'Taarifa',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
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
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) => const BarazaWazeeScreen()));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                decoration: const BoxDecoration(
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
                                        //     "assets/images/topbanner.png",
                                        //     fit: BoxFit.cover,
                                        //     width: double.infinity,
                                        //   ),
                                        // ),
                                        Container(
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
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
                                                  'Baraza la wazee',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: MyColors.primaryLight,
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
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) => const KamatiUsharikaScreen()));
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: MyColors.white,
                                ),
                                width: double.infinity,
                                height: 80,
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(color: MyColors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 10,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Stack(
                                      children: [
                                        // Center(
                                        //   child: Image.asset(
                                        //     "assets/images/topbanner.png",
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
                                                  'Kamati za usharika',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
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
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) => const WatumishiScreen()));
                              },
                              child: Container(
                                decoration: const BoxDecoration(
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
                                        //     "assets/images/topbanner.png",
                                        //     fit: BoxFit.cover,
                                        //     width: double.infinity,
                                        //   ),
                                        // ),
                                        Container(
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
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
                                                  'Watumishi wa usharika',
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
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) => const WalimuScreen()));
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: MyColors.white,
                                ),
                                width: double.infinity,
                                height: 80,
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(color: MyColors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 10,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Stack(
                                      children: [
                                        // Center(
                                        //   child: Image.asset(
                                        //     "assets/images/topbanner.png",
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
                                                  'Walimu',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
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
