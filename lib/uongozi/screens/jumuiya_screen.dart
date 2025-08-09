// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kanisaapp/models/jumuiya_data.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';

class JumuiyaScreen extends StatefulWidget {
  const JumuiyaScreen({super.key});

  @override
  State<JumuiyaScreen> createState() => _JumuiyaScreenState();
}

class _JumuiyaScreenState extends State<JumuiyaScreen> {
  final TextEditingController _nameController = TextEditingController();
  List<JumuiyaData> jumuiya = [];
  bool isLoading = true;
  String? error;
  BaseUser? currentUser;

  @override
  void initState() {
    super.initState();
    checkLogin();
    fetchJumuiya();
  }

  void checkLogin() async {
    BaseUser? user = await UserManager.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> fetchJumuiya() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    BaseUser? user = await UserManager.getCurrentUser();
    setState(() {
      currentUser = user;
    });

    try {
      if (currentUser == null) {
        setState(() {
          error = "User not logged in";
          isLoading = false;
        });
        return;
      }

      final response = await http.post(
        Uri.parse("${ApiUrl.BASEURL}api2/jumuiya_kanisa/get_jumuiya_za_kanisa.php"),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          "kanisa_id": currentUser!.kanisaId,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == '200') {
          setState(() {
            jumuiya = (jsonResponse['data'] as List)
                .map((item) => JumuiyaData.fromJson(item))
                .toList();
            isLoading = false;
          });
        } else {
          setState(() {
            error = jsonResponse['message'] ?? "Failed to load jumuiya";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = "Server error";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "Failed to connect to server";
        isLoading = false;
      });
    }
  }

  void _showDeleteDialog(JumuiyaData jumuiyaItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Futa Jumuiya',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: Text(
            'Una uhakika unataka kufuta jumuiya ya "${jumuiyaItem.jumuiyaName}"?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Hapana',
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  setState(() {
                    isLoading = true;
                  });
                  
                  if (currentUser == null) {
                    Navigator.pop(context);
                    setState(() {
                      isLoading = false;
                    });
                    return;
                  }

                  final response = await http.post(
                    Uri.parse("${ApiUrl.BASEURL}api2/jumuiya_kanisa/delete_jumuiya_kanisa.php"),
                    headers: {'Accept': 'application/json'},
                    body: jsonEncode({
                      "id": jumuiyaItem.id,
                    }),
                  );

                  if (response.statusCode == 200) {
                    final jsonResponse = json.decode(response.body);
                    if (jsonResponse['status'] == '200') {
                      Navigator.pop(context);
                      fetchJumuiya(); // Refresh the list
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Jumuiya imefutwa kikamilifu',
                            style: GoogleFonts.poppins(),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            jsonResponse['message'] ?? 'Imeshindwa kufuta jumuiya',
                            style: GoogleFonts.poppins(),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Imeshindwa kufuta jumuiya',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(
                'Ndio',
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditBottomSheet(JumuiyaData jumuiyaItem) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController controller =
        TextEditingController(text: jumuiyaItem.jumuiyaName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Hariri Jumuiya',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primaryLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'Jina la Jumuiya',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.groups_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tafadhali ingiza jina la jumuiya';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        if (currentUser == null) {
                          Navigator.pop(context);
                          return;
                        }

                        final response = await http.post(
                          Uri.parse(
                              "${ApiUrl.BASEURL}api2/jumuiya_kanisa/ongeza_jumuiya_kanisa.php"),
                          headers: {'Accept': 'application/json'},
                          body: jsonEncode({
                            "id": jumuiyaItem.id,
                            "jumuiya_name": controller.text,
                            "kanisa_id": currentUser!.kanisaId,
                          }),
                        );

                        if (response.statusCode == 200) {
                          final jsonResponse = json.decode(response.body);

                          if (jsonResponse['status'] == 200) {
                            fetchJumuiya(); // Refresh the list
                            Navigator.pop(context); // Dismiss bottom sheet

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Jumuiya imebadilishwa kikamilifu',
                                  style: GoogleFonts.poppins(),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  jsonResponse['message'] ??
                                      'Failed to update jumuiya',
                                  style: GoogleFonts.poppins(),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Imeshindwa kubadili jumuiya',
                              style: GoogleFonts.poppins(),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryLight,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Hifadhi Mabadiliko',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCreateBottomSheet() {
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Ongeza Jumuiya',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primaryLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Jina la Jumuiya',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.groups_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tafadhali ingiza jina la jumuiya';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nameController.text = value ?? '';
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      try {
                        if (currentUser == null) {
                          Navigator.pop(context);
                          return;
                        }

                        final response = await http.post(
                          Uri.parse("${ApiUrl.BASEURL}api2/jumuiya_kanisa/ongeza_jumuiya_kanisa.php"),
                          headers: {'Accept': 'application/json'},
                          body: jsonEncode({
                            "jumuiya_name": _nameController.text,
                            "kanisa_id": currentUser!.kanisaId,
                            "tarehe": DateTime.now().toIso8601String(),
                          }),
                        );


                        if (response.statusCode == 200) {
                          final jsonResponse = json.decode(response.body);
                          if (jsonResponse['status'] == 200) {
                            Navigator.pop(context);
                            fetchJumuiya(); // Refresh the list
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  jsonResponse['message'] ??
                                      'Failed to create jumuiya',
                                  style: GoogleFonts.poppins(),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Failed to create jumuiya',
                              style: GoogleFonts.poppins(),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryLight,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Ongeza',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateBottomSheet,
        backgroundColor: MyColors.primaryLight,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        title: Text(
          'Jumuiya Za Kanisa',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: MyColors.darkText),
        ),
        backgroundColor: MyColors.white,
        foregroundColor: MyColors.darkText,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchJumuiya,
              child: error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            error!,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                                error = null;
                              });
                              fetchJumuiya();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColors.primaryLight,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Jaribu tena',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )
                  : jumuiya.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 48,
                                color: Colors.blue.shade300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Hakuna jumuiya zilizopatikana',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: jumuiya.length,
                          itemBuilder: (context, index) {
                            final jumuiyaItem = jumuiya[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _showEditBottomSheet(jumuiyaItem),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: MyColors.primaryLight
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.groups_rounded,
                                              color: MyColors.primaryLight,
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  jumuiyaItem.jumuiyaName,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: MyColors.darkText,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Tarehe: ${jumuiyaItem.tarehe}',
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                    if (jumuiyaItem.katibuJina != null && jumuiyaItem.katibuJina!.isNotEmpty)
                                                      Container(
                                                        margin: const EdgeInsets.only(top: 8),
                                                        padding: const EdgeInsets.all(8),
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey[50],
                                                          borderRadius: BorderRadius.circular(8),
                                                          border: Border.all(color: Colors.grey[200]!),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                                                                const SizedBox(width: 8),
                                                                Expanded(
                                                                  child: Text(
                                                                    'Katibu: ${jumuiyaItem.katibuJina}',
                                                                    style: GoogleFonts.poppins(
                                                                      fontSize: 13,
                                                                      color: Colors.grey[700],
                                                                      fontWeight: FontWeight.w500,
                                                                    ),
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            if (jumuiyaItem.katibuSimu != null && jumuiyaItem.katibuSimu!.isNotEmpty)
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 4),
                                                                child: Row(
                                                                  children: [
                                                                    const Icon(Icons.phone_outlined, size: 16, color: Colors.grey),
                                                                    const SizedBox(width: 8),
                                                                    Expanded(
                                                                      child: Text(
                                                                        jumuiyaItem.katibuSimu!,
                                                                        style: GoogleFonts.poppins(
                                                                          fontSize: 13,
                                                                          color: Colors.grey[600],
                                                                        ),
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            icon: Icon(
                                              Icons.more_vert,
                                              color: Colors.grey[600],
                                            ),
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            onSelected: (value) {
                                              if (value == 'edit') {
                                                _showEditBottomSheet(jumuiyaItem);
                                              } else if (value == 'delete') {
                                                _showDeleteDialog(jumuiyaItem);
                                              }
                                            },
                                            itemBuilder: (BuildContext context) => [
                                              PopupMenuItem(
                                                value: 'edit',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.edit_rounded,
                                                      color: MyColors.primaryLight,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Text(
                                                      'Hariri',
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 'delete',
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.delete_rounded,
                                                      color: Colors.red,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Text(
                                                      'Futa',
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
    );
  }
}
