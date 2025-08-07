// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kanisaapp/kwayazetu/screens/video_list_screen.dart';
import 'package:kanisaapp/utils/TextStyles.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/spacer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class KwayaZetu extends StatefulWidget {
  const KwayaZetu({super.key});

  @override
  _KwayaZetuState createState() => _KwayaZetuState();
}

class _KwayaZetuState extends State<KwayaZetu> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildChoir({
    required String title,
    required int kwayaId,
    required bool isPrimary,
  }) {
    return AnimationConfiguration.staggeredList(
      position: kwayaId,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Material(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => VideoListScreen(kwayaid: kwayaId),
                      ),
                    );
                  },
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: isPrimary
                          ? LinearGradient(
                              colors: [
                                MyColors.primaryLight,
                                // ignore: deprecated_member_use
                                MyColors.primaryLight.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isPrimary ? null : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: isPrimary ? Colors.transparent : MyColors.primaryLight,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isPrimary ? Colors.white : MyColors.primaryLight,
                          fontSize: deviceHeight(context) / 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
          "Kwaya Zetu",
          style: TextStyles.headline(context).copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MyColors.primaryLight,
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0.8),
      ),
      child: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: deviceHeight(context) / 2.5,
                pinned: true,
                stretch: true,
                backgroundColor: MyColors.primaryLight,
                flexibleSpace: FlexibleSpaceBar(
                  background: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Hero(
                      tag: "msimu",
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: const AssetImage("assets/images/kwaya.jpg"),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.2),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  title: const Text(
                    "Karibu Kwaya Zetu",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: true,
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(height: deviceHeight(context) / 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: AnimationLimiter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildChoir(
                              title: 'Kwaya Kuu',
                              kwayaId: 0,
                              isPrimary: false,
                            ),
                            _buildChoir(
                              title: 'Kwaya ya Vijana',
                              kwayaId: 1,
                              isPrimary: true,
                            ),
                            _buildChoir(
                              title: 'Kwaya ya Uinjilisti',
                              kwayaId: 2,
                              isPrimary: false,
                            ),
                            _buildChoir(
                              title: 'Kwaya ya Nazareti',
                              kwayaId: 3,
                              isPrimary: true,
                            ),
                            _buildChoir(
                              title: 'Praise Team',
                              kwayaId: 4,
                              isPrimary: false,
                            ),
                            SizedBox(height: deviceHeight(context) / 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
