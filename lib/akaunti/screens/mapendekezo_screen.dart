// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import 'package:kanisaapp/models/user_models.dart';

class MapendekezoScreen extends StatefulWidget {
  const MapendekezoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapendekezoScreenState createState() => _MapendekezoScreenState();
}

class _MapendekezoScreenState extends State<MapendekezoScreen> {
  TextEditingController xsuggestion = TextEditingController();
  bool isregistered = false;
  BaseUser? currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      currentUser = await UserManager.getCurrentUser();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
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
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      MyColors.primaryLight,
                      MyColors.primaryLight.withOpacity(0.8),
                      Colors.purple.withOpacity(0.6),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Hero(
                        tag: 'feedback_icon',
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
                            Icons.feedback_outlined,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Maoni & Mapendekezo",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "Tupe maoni yako ili tuendelee kuboresha huduma zetu",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildFeedbackForm(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackForm(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: 20),
          _buildFeedbackCard(),
          const SizedBox(height: 25),
          _buildSubmitButton(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Colors.orange[600],
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tunakusikiliza!",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      "Maoni yako ni muhimu kwetu",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            "Mapendekezo yako au maoni yako kuhusu mfumo wetu huu yanaweza kusaida wengi sana na kusaidia kuboresha huduma zetu. Tuandikie chochote kuhusu mfumo ama changamoto yeyote unayokutana nayo.",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard() {
    return Container(
      padding: const EdgeInsets.all(25),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.edit_note_rounded,
                color: MyColors.primaryLight,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                "Andika Maoni Yako",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
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
              controller: xsuggestion,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              minLines: 6,
              maxLines: 10,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey[800],
                height: 1.5,
              ),
              decoration: InputDecoration(
                hintText: "Mfano: Ningedandia kuongeza kipengele cha...\n\nau\n\nNimekutana na tatizo la...",
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey[400],
                  fontSize: 14,
                  height: 1.5,
                ),
                fillColor: Colors.grey[50],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: MyColors.primaryLight, width: 2),
                ),
                contentPadding: const EdgeInsets.all(20),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Colors.blue[600],
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Maoni yako yatatumiwa kuboresha huduma zetu zaidi",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.blue[600],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            MyColors.primaryLight,
            Colors.purple.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primaryLight.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : () async => _handleSubmitFeedback(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Inatuma...",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Tuma Maoni",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _handleSubmitFeedback() async {
    if (xsuggestion.text.trim().isEmpty) {
      _showErrorSnackBar("Tafadhari weka maoni au mapendekezo yako");
      return;
    }

    if (xsuggestion.text.trim().length < 10) {
      _showErrorSnackBar("Maoni yako yawe ya kina zaidi (angalau herufi 10)");
      return;
    }

    if (currentUser != null) {
      await sendsuggestion(currentUser!.memberNo, xsuggestion.text.trim());
    } else {
      _showErrorSnackBar("Tatizo la mtumiaji, tafadhari jaribu tena");
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> sendsuggestion(
    String memberNo,
    String suggestion,
  ) async {
    setState(() {
      isLoading = true;
    });

    try {
      String mydataApi = "${ApiUrl.BASEURL}mapendekezo.php";

      final response = await http.post(
        Uri.parse(mydataApi),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          "member_no": memberNo,
          "maoni": suggestion,
        },
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        dynamic jsonResponse = json.decode(response.body);
        if (jsonResponse != null && jsonResponse != 404 && jsonResponse != 500) {
          setState(() {
            xsuggestion.clear();
          });

          _showSuccessSnackBar("Maoni yako yamepokelewa, Asante sana!");

          // Navigate back after a short delay
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });

          Fluttertoast.showToast(
            msg: "Maoni yako yamepokelewa, Ahsante",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: MyColors.primaryLight,
            textColor: Colors.white,
          );
        } else {
          _showErrorSnackBar("Kuna tatizo la kimtandao, jaribu tena");
          Fluttertoast.showToast(
            msg: "Kuna makosa kwenye kutuma maoni...",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: MyColors.primaryLight,
            textColor: Colors.white,
          );
        }
      } else {
        _showErrorSnackBar("Kuna tatizo la kimtandao, jaribu tena");
        Fluttertoast.showToast(
          msg: "Kuna makosa kwenye kutuma maoni...",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: MyColors.primaryLight,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar("Hitilafu ya mtandao, jaribu tena");
      Fluttertoast.showToast(
        msg: "Kuna makosa kwenye kutuma maoni...",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: MyColors.primaryLight,
        textColor: Colors.white,
      );
    }
  }
}
