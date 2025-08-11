// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, prefer_typing_uninitialized_variables, deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:kanisaapp/matangazo/screens/single_post_screen_new.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/image.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/models/matangazo.dart';
import 'package:http/http.dart' as http;
import 'package:kanisaapp/utils/user_manager.dart';
import 'dart:convert';
import 'package:lottie/lottie.dart';

class MatangazoScreen extends StatefulWidget {
  const MatangazoScreen({super.key});

  @override
  _MatangazoScreenState createState() => _MatangazoScreenState();
}

class _MatangazoScreenState extends State<MatangazoScreen> {
  List<Matangazo> listmatangazo = <Matangazo>[];
  List<Matangazo> filteredMatangazo = <Matangazo>[];
  BaseUser? currentUser;
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  late Future<List<Matangazo>> _matangazoFuture;

  Future<List<Matangazo>> getMatangazoNew() async {
    checkLogin();

    String myApi = "${ApiUrl.BASEURL}get_matangazo.php";

    final response = await http.post(Uri.parse(myApi),
        headers: {'Accept': 'application/json'},
        body: jsonEncode(
          {
            "kanisa_id": currentUser?.kanisaId ?? "0",
          },
        ));

    try {
      var matangazoList = <Matangazo>[];
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == "200" && jsonResponse['data'] != null) {
          var data = jsonResponse['data'] as List;
          matangazoList = data.map((item) => Matangazo.fromJson(item)).toList();
        }
      }

      return matangazoList;
    } catch (e) {
      if (kDebugMode) {
        print("error: $e");
      }
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
    _matangazoFuture = getMatangazoNew();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      // Trigger rebuild when search text changes
    });
  }

  void _filterMatangazo(List<Matangazo> allMatangazo) {
    String searchText = searchController.text.toLowerCase().trim();

    if (searchText.isEmpty) {
      filteredMatangazo = allMatangazo;
    } else {
      filteredMatangazo = allMatangazo.where((matangazo) {
        return matangazo.title?.toLowerCase().contains(searchText) == true ||
            matangazo.descp?.toLowerCase().contains(searchText) == true;
      }).toList();
    }
  }

  void checkLogin() async {
    // Get current user using UserManager
    BaseUser? user = await UserManager.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _matangazoFuture = getMatangazoNew();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: MyColors.primaryLight,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded,
                    color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    isSearching ? Icons.close_rounded : Icons.search_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
                      if (!isSearching) {
                        searchController.clear();
                      }
                    });
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      MyColors.primaryLight,
                      MyColors.primaryLight.withOpacity(0.8),
                      Colors.blue.withOpacity(0.6),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Hero(
                        tag: 'announcements_icon',
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.campaign_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Matangazo",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Taarifa na matangazo muhimu",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isSearching)
            SliverToBoxAdapter(
              child: _buildSearchBar(),
            ),
          SliverToBoxAdapter(
            child: RefreshIndicator(
              onRefresh: _pullRefresh,
              child: _buildAnnouncementsList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Tafuta matangazo kwa jina au maudhui...',
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey[500],
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: MyColors.primaryLight,
          ),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: Colors.grey[500],
                  ),
                  onPressed: () {
                    searchController.clear();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildAnnouncementsList() {
    return FutureBuilder<List<Matangazo>>(
      future: _matangazoFuture,
      builder: (context, AsyncSnapshot<List<Matangazo>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return _buildEmptyState();
        } else if (snapshot.hasData) {
          _filterMatangazo(snapshot.data!);
          return _buildAnnouncementsGrid(filteredMatangazo);
        } else {
          return _buildEmptyState();
        }
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
              child: Lottie.asset('assets/animation/fetching.json'),
            ),
            const SizedBox(height: 20),
            Text(
              "Inapanga matangazo...",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: MyColors.primaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Tafadhari subiri kidogo",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
              child: Lottie.asset('assets/animation/nodata.json'),
            ),
            const SizedBox(height: 20),
            Text(
              "Hakuna Matangazo",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: MyColors.primaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Matangazo mapya yataonekana hapa",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pullRefresh,
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: Text(
                "Jaribu Tena",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            "Hakuna matokeo",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: MyColors.primaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Hakuna matangazo yoyote yanayolingana na utafutaji wako",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  searchController.clear();
                },
                icon: const Icon(Icons.clear_rounded, color: Colors.white),
                label: Text(
                  "Futa utafutaji",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primaryLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              const SizedBox(width: 15),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    isSearching = false;
                    searchController.clear();
                  });
                },
                icon: Icon(Icons.close_rounded, color: MyColors.primaryLight),
                label: Text(
                  "Funga",
                  style: GoogleFonts.poppins(
                    color: MyColors.primaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: MyColors.primaryLight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsGrid(List<Matangazo> announcements) {
    if (announcements.isEmpty && searchController.text.isNotEmpty) {
      return _buildNoSearchResults();
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                searchController.text.isNotEmpty
                    ? Icons.search_rounded
                    : Icons.notifications_active_rounded,
                color: MyColors.primaryLight,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                searchController.text.isNotEmpty
                    ? "Matokeo ya utafutaji (${announcements.length})"
                    : "Matangazo (${announcements.length})",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          if (searchController.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: MyColors.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Unatafuta: "${searchController.text}"',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: MyColors.primaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              return _buildAnnouncementCard(announcements[index], index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard(Matangazo announcement, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    SingleTangazoScreen(postdata: announcement),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnnouncementImage(announcement),
              _buildAnnouncementContent(announcement),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncementImage(Matangazo announcement) {
    return Hero(
      tag: 'announcement_${announcement.id}',
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Stack(
            children: [
              ImagePreview(
                img:
                    'https://kkktmiyuji.nitusue.com/admin/matangazo/${announcement.image}',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: MyColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd MMM').format(announcement.tarehe!),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
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
    );
  }

  Widget _buildAnnouncementContent(Matangazo announcement) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MyColors.primaryLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 24,
                  height: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (currentUser != null &&
                              currentUser!.kanisaName.isNotEmpty)
                          ? currentUser!.kanisaName
                          : "KANISANI",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: MyColors.primaryLight,
                      ),
                    ),
                    Text(
                      DateFormat('dd MMMM yyyy, HH:mm')
                          .format(announcement.tarehe!),
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: Colors.green[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildHighlightedText(
            announcement.title.toString(),
            searchController.text,
            GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              height: 1.3,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Text(
                "Bonyeza kusoma zaidi",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedText(
    String text,
    String searchTerm,
    TextStyle style, {
    int? maxLines,
  }) {
    if (searchTerm.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      );
    }

    List<TextSpan> spans = [];
    String lowerText = text.toLowerCase();
    String lowerSearchTerm = searchTerm.toLowerCase();

    int start = 0;
    int indexOfHighlight = lowerText.indexOf(lowerSearchTerm, start);

    while (indexOfHighlight >= 0) {
      // Add normal text before highlight
      if (indexOfHighlight > start) {
        spans.add(TextSpan(
          text: text.substring(start, indexOfHighlight),
          style: style,
        ));
      }

      // Add highlighted text
      spans.add(TextSpan(
        text: text.substring(
            indexOfHighlight, indexOfHighlight + searchTerm.length),
        style: style.copyWith(
          backgroundColor: MyColors.primaryLight.withOpacity(0.3),
          fontWeight: FontWeight.bold,
        ),
      ));

      start = indexOfHighlight + searchTerm.length;
      indexOfHighlight = lowerText.indexOf(lowerSearchTerm, start);
    }

    // Add remaining text
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: style,
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
