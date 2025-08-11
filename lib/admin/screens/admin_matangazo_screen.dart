// ignore_for_file: use_build_context_synchronously, unused_field

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kanisaapp/models/matangazo.dart';
import 'package:kanisaapp/models/user_models.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/user_manager.dart';
import 'package:lottie/lottie.dart';

class AdminMatangazoScreen extends StatefulWidget {
  const AdminMatangazoScreen({super.key});

  @override
  State<AdminMatangazoScreen> createState() => _AdminMatangazoScreenState();
}

class _AdminMatangazoScreenState extends State<AdminMatangazoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _searchController = TextEditingController();
  String? _selectedImage;
  bool _isLoading = false;
  BaseUser? currentUser;
  File? _image;
  List<Matangazo> _matangazoList = [];
  List<Matangazo> _filteredMatangazoList = [];
  bool _isInitialLoading = true;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadMatangazo();
    _filteredMatangazoList = _matangazoList;
  }

  void _filterMatangazo(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMatangazoList = _matangazoList;
      } else {
        _filteredMatangazoList = _matangazoList
            .where((matangazo) =>
                (matangazo.title ?? '').toLowerCase().contains(query.toLowerCase()) ||
                (matangazo.descp ?? '').toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _loadCurrentUser() async {
    currentUser = await UserManager.getCurrentUser();
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _loadMatangazo() async {
    setState(() {
      _isLoading = true;
    });

    currentUser = await UserManager.getCurrentUser();

    try {
      String myApi = "${ApiUrl.BASEURL}api2/matangazo_kanisa/get_matangazo_kanisa.php";
      final response = await http.post(
        Uri.parse(myApi),
        headers: {
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "kanisa_id": currentUser?.kanisaId ?? '',
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == "200" && jsonResponse['data'] != null) {
          setState(() {
            if (jsonResponse['data'] is List) {
              _matangazoList = (jsonResponse['data'] as List)
                  .map((item) => Matangazo.fromJson(item))
                  .toList();
              _filteredMatangazoList = _matangazoList;
            }
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading matangazo: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
        _isInitialLoading = false;
      });
    }

  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _selectedImage = pickedFile.path;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error picking image: $e');
      }
    }
  }

  Future<void> _addMatangazo() async {
    if (!_formKey.currentState!.validate() || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${ApiUrl.BASEURL}api2/matangazo_kanisa/ongeza_matangazo_kanisa.php"),
      );

      // Add text fields
      request.fields['title'] = _titleController.text;
      request.fields['descp'] = _descriptionController.text;
      request.fields['tarehe'] = _dateController.text;
      request.fields['kanisa_id'] =currentUser?.kanisaId ?? '';// Replace with actual kanisa_id

      // Add image file
      if (_image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _image!.path,
        ));
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      if (response.statusCode == 200 && jsonResponse['status'] == '200') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tangazo limeongezwa kwa mafanikio')),
          );
          _clearForm();
          _loadMatangazo(); // Refresh the list
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${jsonResponse['message']}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteMatangazo(String id) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiUrl.BASEURL}api2/matangazo_kanisa/delete_matangazo_makanisa.php"),
        body: jsonEncode({'id': id}),
      );

      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == '200') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Tangazo limefutwa kwa mafanikio', style: GoogleFonts.poppins(),), backgroundColor: Colors.green,),
            
          );
          _loadMatangazo(); // Refresh the list
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('imefaili kufuta tangazo')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _updateMatangazo(Matangazo matangazo) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${ApiUrl.BASEURL}update_matangazo.php"),
      );

      request.fields['id'] = matangazo.id.toString();
      request.fields['title'] = _titleController.text;
      request.fields['descp'] = _descriptionController.text;
      request.fields['tarehe'] = _dateController.text;

      if (_image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _image!.path,
        ));
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (response.statusCode == 200 && jsonResponse['status'] == '200') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tangazo updated successfully')),
          );
          _clearForm();
          _loadMatangazo(); // Refresh the list
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${jsonResponse['message']}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _dateController.clear();
    setState(() {
      _selectedImage = null;
      _image = null;
    });
  }

  void _showAddEditDialog([Matangazo? matangazo]) {
    if (matangazo != null) {
      _titleController.text = matangazo.title ?? '';
      _descriptionController.text = matangazo.descp ?? '';
      _dateController.text = matangazo.tarehe?.toString().split(' ')[0] ?? '';
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    matangazo == null ? 'Add New Tangazo' : 'Edit Tangazo',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a date';
                      }
                      return null;
                    },
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                        setState(() {
                          _dateController.text = formattedDate;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Select Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primaryLight,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  if (_selectedImage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Image selected',
                      style: GoogleFonts.poppins(
                        color: Colors.green,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (matangazo == null) {
                            _addMatangazo();
                          } else {
                            _updateMatangazo(matangazo);
                          }
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.primaryLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          matangazo == null ? 'Add' : 'Update',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: _searchController,
                style: GoogleFonts.poppins(color: MyColors.darkText),
                decoration: InputDecoration(
                  hintText: 'Tafuta neno...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onChanged: _filterMatangazo,
              )
            : Text(
                'Matangazo ya Kanisa',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: MyColors.darkText),
              ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  isSearching = false;
                  _searchController.clear();
                  _filteredMatangazoList = _matangazoList;
                } else {
                  isSearching = true;
                }
              });
            },
          ),
        ],
        backgroundColor: MyColors.white,
        foregroundColor: MyColors.darkText,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: MyColors.primaryLight,
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      body: RefreshIndicator(
        onRefresh: _loadMatangazo,
        child: _isInitialLoading
            ? const Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.black,
                  ),
                ),
              ),
            )
            : _matangazoList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/animation/nodata.json',
                          height: 200,
                        ),
                        Text(
                          'No matangazo found',
                          style: GoogleFonts.poppins(),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _filteredMatangazoList.length,
        itemBuilder: (context, index) {
          final matangazo = _filteredMatangazoList[index];
            return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                    ApiUrl.IMAGEURL + (matangazo.image ?? ''),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[100],
                      child: const Center(
                        child: CircularProgressIndicator(
                        strokeWidth: 2,
                        ),
                      ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                      );
                    },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(
                      matangazo.title ?? '',
                      style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Date: ${matangazo.tarehe ?? ''}',
                      style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      matangazo.descp ?? '',
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    ],
                  ),
                  ),
                ],
                ),
                const SizedBox(height: 8),
                Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showAddEditDialog(matangazo),
                  color: Colors.blue,
                  ),
                  IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                    title: Text(
                      'Delete Tangazo',
                      style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      ),
                    ),
                    content: Text(
                      'Are you sure you want to delete this tangazo?',
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    actions: [
                      TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel', 
                        style: GoogleFonts.poppins(fontSize: 12)),
                      ),
                      TextButton(
                      onPressed: () {
                        _deleteMatangazo(matangazo.id.toString());
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Delete',
                        style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontSize: 12,
                        ),
                      ),
                      ),
                    ],
                    ),
                  ),
                  color: Colors.red,
                  ),
                ],
                ),
              ],
              ),
            ),
            );
        },
          
        
                ),)
    );
  }
}
