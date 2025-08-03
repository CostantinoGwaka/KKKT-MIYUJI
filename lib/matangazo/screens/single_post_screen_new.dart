// ignore_for_file: library_private_types_in_public_api, avoid_unnecessary_containers, deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kanisaapp/models/matangazo.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanisaapp/utils/user_manager.dart';

class SingleTangazoScreen extends StatefulWidget {
  final Matangazo postdata;
  const SingleTangazoScreen({super.key, required this.postdata});

  @override
  _SingleTangazoScreenState createState() => _SingleTangazoScreenState();
}

class _SingleTangazoScreenState extends State<SingleTangazoScreen> {
  bool isBookmarked = false;
  BaseUser? currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          _buildPostContent(context),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadBookmarkStatus();
    checkLogin();
  }

  // Load bookmark status from local storage
  _loadBookmarkStatus() async {
    // In a real app, you would load this from SharedPreferences or a database
    // For now, we'll just set a default value
    setState(() {
      isBookmarked = false; // Default to not bookmarked
    });
  }

  // Share post functionality
  void _sharePost() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Shiriki Tangazo',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.copy, color: Colors.blue),
              ),
              title: Text(
                'Nakili kwenye Clipboard',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                'Nakili maudhui ya tangazo',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              onTap: () {
                _copyToClipboard();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.share, color: Colors.green),
              ),
              title: Text(
                'Shiriki kwenye Programu Nyingine',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                'Fungua menyu ya kushiriki',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              onTap: () {
                _shareToOtherApps();
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard() {
    final String shareText = '''
📢 Tangazo la KKKT Miyuji

${widget.postdata.title ?? 'Tangazo'}

${widget.postdata.descp ?? 'Hakuna maelezo ya ziada.'}

Tarehe: ${widget.postdata.tarehe?.toString() ?? 'Tarehe haijulikani'}

Imetumwa na KKKT Miyuji
    ''';

    Clipboard.setData(ClipboardData(text: shareText));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Tangazo limehifadhiwa kwenye clipboard',
              style: GoogleFonts.poppins(),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _shareToOtherApps() {
    final String shareText = '''
📢 Tangazo la KKKT Miyuji

${widget.postdata.title ?? 'Tangazo'}

${widget.postdata.descp ?? 'Hakuna maelezo ya ziada.'}

Tarehe: ${widget.postdata.tarehe?.toString() ?? 'Tarehe haijulikani'}

Imetumwa na KKKT Miyuji
    ''';

    // For now, copy to clipboard as a fallback
    Clipboard.setData(ClipboardData(text: shareText));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Maudhui yamehifadhiwa. Unaweza yabandia kwenye programu nyingine',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void checkLogin() async {
    // Get current user using UserManager
    BaseUser? user = await UserManager.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  // Save/bookmark post functionality
  void _toggleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
    });

    // In a real app, you would save this to SharedPreferences or a database
    // For now, we'll just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isBookmarked ? Icons.bookmark_added : Icons.bookmark_remove,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              isBookmarked ? 'Tangazo limehifadhiwa!' : 'Tangazo limeondolewa kwenye vinavyohifadhiwa',
              style: GoogleFonts.poppins(),
            ),
          ],
        ),
        backgroundColor: isBookmarked ? Colors.green : Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: MyColors.primaryLight,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            onPressed: _sharePost,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Hero(
              tag: "msimu",
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: widget.postdata.image != null && widget.postdata.image!.isNotEmpty
                        ? NetworkImage('https://kkktmiyuji.nitusue.com/admin/matangazo/${widget.postdata.image!}')
                        : const AssetImage("assets/images/miyuji.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: MyColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.campaign_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Tangazo",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.postdata.title ?? "Tangazo",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostContent(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
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
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPostHeader(),
              const SizedBox(height: 20),
              _buildPostBody(),
              const SizedBox(height: 25),
              _buildPostFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MyColors.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                "assets/images/logo.png",
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (currentUser != null && currentUser!.kanisaName.isNotEmpty) ? currentUser!.kanisaName : "KANISANI",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: MyColors.primaryLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.postdata.tarehe?.toString() ?? "Tarehe haijulikani",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_rounded,
                    size: 14,
                    color: Colors.green[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Rasmi",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          widget.postdata.title ?? "Tangazo",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildPostBody() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.article_rounded,
                color: MyColors.primaryLight,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Maudhui ya Tangazo",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: MyColors.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            widget.postdata.descp ?? "Hakuna maelezo ya ziada.",
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.6,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildPostFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyColors.primaryLight.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: MyColors.primaryLight.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.admin_panel_settings_rounded,
                color: MyColors.primaryLight,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                "Imetumwa na:",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "@admin",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: MyColors.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: isBookmarked ? Icons.bookmark_added_rounded : Icons.bookmark_add_rounded,
                  label: isBookmarked ? "Imehifadhiwa" : "Hifadhi",
                  onTap: _toggleBookmark,
                  isActive: isBookmarked,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.share_rounded,
                  label: "Shiriki",
                  onTap: _sharePost,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isActive ? MyColors.primaryLight.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? MyColors.primaryLight : Colors.grey[200]!,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: MyColors.primaryLight,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MyColors.primaryLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
