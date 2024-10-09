import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miyuji/utils/TextStyles.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:miyuji/utils/spacer.dart';

class SingleTangazoScreen extends StatefulWidget {
  const SingleTangazoScreen({super.key});

  @override
  _SingleTangazoScreenState createState() => _SingleTangazoScreenState();
}

class _SingleTangazoScreenState extends State<SingleTangazoScreen> {
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
          "POST TITLE",
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
                  Material(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "POST TITLE POST TITLE POST TITLE",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Helvetica",
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                manualStepper(step: 5),
                                const Text(
                                  "12-02-2021 09:30 AM",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Helvetica",
                                    color: Colors.black87,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                manualStepper(step: 5),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Kwa kawaida, maneno “neno la Mungu” yanawakilisha ujumbe kutoka kwa Mungu au mkusanyo wa ujumbe huo. (Luka 11:28) Katika sehemu chache, “Neno la Mungu” au “Neno” hutumiwa kuwakilisha cheo cha mtu.​—Ufunuo 19:13; Yohana 1:​14. Ujumbe kutoka kwa Mungu. Mara nyingi manabii walisema kwamba ujumbe ambao walitoa ulikuwa Neno la Mungu. Kwa mfano, Yeremia alianza ujumbe wake wa kinabii kwa kusema “neno la Yehova likaanza kunijia.” (Yeremia 1:4, 11, 13; 2:1) Kabla ya kumwambia Sauli kwamba Mungu alikuwa amemchagua kuwa mfalme, nabii Samweli alisema hivi: “Simama tuli sasa ili nikuambie neno la Mungu.”​—1 Samweli 9:27.Cheo cha mtu. Pia “Neno” linaonekana katika Biblia likiwa cheo cha Yesu Kristo, akiwa roho mbinguni na pia akiwa mwanadamu duniani. Fikiria sababu kadhaa za kufikia mkataa huo: Kwa kawaida, maneno “neno la Mungu” yanawakilisha ujumbe kutoka kwa Mungu au mkusanyo wa ujumbe huo. (Luka 11:28) Katika sehemu chache, “Neno la Mungu” au “Neno” hutumiwa kuwakilisha cheo cha mtu.​—Ufunuo 19:13; Yohana 1:​14. Ujumbe kutoka kwa Mungu. Mara nyingi manabii walisema kwamba ujumbe ambao walitoa ulikuwa Neno la Mungu. Kwa mfano, Yeremia alianza ujumbe wake wa kinabii kwa kusema “neno la Yehova likaanza kunijia.” (Yeremia 1:4, 11, 13; 2:1) Kabla ya kumwambia Sauli kwamba Mungu alikuwa amemchagua kuwa mfalme, nabii Samweli alisema hivi: “Simama tuli sasa ili nikuambie neno la Mungu.”​—1 Samweli 9:27.Cheo cha mtu. Pia “Neno” linaonekana katika Biblia likiwa cheo cha Yesu Kristo, akiwa roho mbinguni na pia akiwa mwanadamu duniani. Fikiria sababu kadhaa za kufikia mkataa huo:",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  letterSpacing: 1.4,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                manualStepper(step: 5),
                                const Text(
                                  "Imetumwa na @admin",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Helvetica",
                                    color: Colors.black87,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
