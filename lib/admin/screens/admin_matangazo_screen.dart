// ignore_for_file: use_build_context_synchronously

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
  String? _selectedImage;
  // ignore: unused_field
  bool _isLoading = false;
  BaseUser? currentUser;
  File? _image;
  List<Matangazo> _matangazoList = [];
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadMatangazo();
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
        Uri.parse("${ApiUrl.BASEURL}add_matangazo.php"),
      );

      // Add text fields
      request.fields['title'] = _titleController.text;
      request.fields['descp'] = _descriptionController.text;
      request.fields['tarehe'] = _dateController.text;
      request.fields['kanisa_id'] = '1'; // Replace with actual kanisa_id

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
            const SnackBar(content: Text('Tangazo added successfully')),
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
        Uri.parse("${ApiUrl.BASEURL}delete_matangazo.php"),
        body: {'id': id},
      );

      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == '200') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tangazo deleted successfully')),
          );
          _loadMatangazo(); // Refresh the list
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete tangazo')),
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
        title: Text(
          'Manage Matangazo',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: MyColors.primaryLight,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: MyColors.primaryLight,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _loadMatangazo,
        child: _isInitialLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/animation/loading.json',
                      height: 100,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Loading...',
                      style: GoogleFonts.poppins(),
                    ),
                  ],
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
        itemCount: _matangazoList.length,
        itemBuilder: (context, index) {
          final matangazo = _matangazoList[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              matangazo.image ?? '',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 60,
              height: 60,
              color: Colors.grey[300],
              child: const Icon(Icons.error),
            );
              },
            ),
          ),
          title: Text(
            matangazo.title ?? '',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
            matangazo.descp ?? '',
            style: GoogleFonts.poppins(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
            'Date: ${matangazo.tarehe?.toString().split(' ')[0] ?? ''}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showAddEditDialog(matangazo),
            color: Colors.blue,
              ),
              IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
              'Delete Tangazo',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),
                ),
                content: Text(
              'Are you sure you want to delete this tangazo?',
              style: GoogleFonts.poppins(),
                ),
                actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(),
                ),
              ),
              TextButton(
                onPressed: () {
                  _deleteMatangazo(matangazo.id);
                  Navigator.pop(context);
                },
                child: Text(
                  'Delete',
                  style: GoogleFonts.poppins(
                color: Colors.red,
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
            ),
          );
        },
          
        
                ),)
    );
  }
}
