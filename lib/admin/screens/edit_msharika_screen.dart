// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages, deprecated_member_use, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanisaapp/models/jumuiya_data.dart';
import 'package:kanisaapp/models/jumuiya_model.dart';
import 'package:kanisaapp/models/kanisa_model.dart';
import 'package:kanisaapp/models/makatibu.dart';
import 'package:kanisaapp/models/msharika_model.dart';
import 'package:kanisaapp/models/mwaka_wa_kanisa.dart';
import 'package:kanisaapp/usajili/screens/index.dart';
import 'package:kanisaapp/utils/Alerts.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:http/http.dart' as http;
import 'package:kanisaapp/utils/ApiUrl.dart';

enum MsharikaFormStep {
  personalInfo,
  familyInfo,
  childrenInfo,
  contactWork,
  churchInfo,
  status
}

class EditMsharikaScreen extends StatefulWidget {
  final MsharikaData msharika;
  final Function() onUpdateSuccess;

  const EditMsharikaScreen({
    super.key,
    required this.msharika,
    required this.onUpdateSuccess,
  });

  @override
  _EditMsharikaScreenState createState() => _EditMsharikaScreenState();
}

class _EditMsharikaScreenState extends State<EditMsharikaScreen> {
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  bool _isLoading = false;
  String idYaJumuiya = '';
  int _currentStep = 0;

  // All form controllers
  late final TextEditingController _jinaController;
  late final TextEditingController _jinsiaController;
  late final TextEditingController _umriController;
  late final TextEditingController _haliYaNdoaController;
  late final TextEditingController _jinaLaMwenziController;
  late final TextEditingController _nambaYaAhadiController;
  late final TextEditingController _ainaNdoaController;
  late final TextEditingController _jinaMtoto1Controller;
  late final TextEditingController _tareheMtoto1Controller;
  late final TextEditingController _uhusianoMtoto1Controller;
  late final TextEditingController _jinaMtoto2Controller;
  late final TextEditingController _tareheMtoto2Controller;
  late final TextEditingController _uhusianoMtoto2Controller;
  late final TextEditingController _jinaMtoto3Controller;
  late final TextEditingController _tareheMtoto3Controller;
  late final TextEditingController _uhusianoMtoto3Controller;
  late final TextEditingController _nambaSimuController;
  late final TextEditingController _jengoController;
  late final TextEditingController _ahadiController;
  late final TextEditingController _kaziController;
  late final TextEditingController _elimuController;
  late final TextEditingController _ujuziController;
  late final TextEditingController _mahaliPakaziController;
  late final TextEditingController _jumuiyaUshirikiController;
  late final TextEditingController _jinaLaJumuiyaController;
  late final TextEditingController _idYaJumuiyaController;
  late final TextEditingController _katibuJumuiyaController;
  late final TextEditingController _kamaUshirikiController;
  late final TextEditingController _katibuStatusController;
  late final TextEditingController _mzeeStatusController;
  late final TextEditingController _usharikaStatusController;
  late final TextEditingController _regYearIdController;
  late final TextEditingController _tareheController;
  late final TextEditingController _kanisaIdController;
  late final TextEditingController _passwordController;
  TextEditingController kamaUshiriki = TextEditingController();

  String _haliNdoa = '';
  String _ndoa = '';
  String _ushiriki = '';
  var jumuiyaList = <JumuiyaData>[];
  JumuiyaData? dropdownValue;
  String? _valProvince;
  List<Jumuiya>? _dataProvince;
  List<Katibu> katibuWaJumuiya = [];
  dynamic usajiliId;
  Kanisa? kanisaData;
  InactiveYear? inactiveYearData;

  @override
  void initState() {
    super.initState();
    _initializeControllers();

    getKanisaDetails(widget.msharika.kanisaId);
    _haliNdoa = widget.msharika.haliYaNdoa;
    _ndoa = widget.msharika.ainaNdoa;
    _ushiriki = widget.msharika.jumuiyaUshiriki;
    print(
        "data: ${widget.msharika.idYaJumuiya} : ${widget.msharika.jinaLaJumuiya} : ${widget.msharika.katibuJumuiya}");
    idYaJumuiya = widget.msharika.idYaJumuiya;
    _valProvince = widget.msharika.idYaJumuiya;
  }

  Future<Kanisa?> getKanisaDetails(kanisaId) async {
    String myApi = "${ApiUrl.BASEURL}get_kanisa_details_by_id.php";
    final response = await http.post(
      Uri.parse(myApi),
      headers: {'Accept': 'application/json'},
      body: jsonEncode({
        "kanisa_id": kanisaId,
      }),
    );

    dynamic kanisa;

    var jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        kanisa = json;
      }
    }

    if (kanisa != null) {
      if (kanisa is Map && kanisa.containsKey('data')) {
        // Handle single object response
        setState(() {
          kanisaData = Kanisa.fromJson(kanisa['data']);
        });
        getJumuiyaApi();
        getKatibu();
      }
    }

    return kanisaData; // Return a list with the kanisa data or an empty list
  }

  void getJumuiyaApi() async {
    String myApi = "${ApiUrl.BASEURL}getjumuiya.php";
    final response = await http.post(
      Uri.parse(myApi),
      headers: {'Accept': 'application/json'},
      body: jsonEncode({
        "kanisa_id": kanisaData != null ? kanisaData!.id : '',
      }),
    );
    dynamic jumuiya;

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        if (json is Map &&
            json.containsKey('data') &&
            json['data'] != null &&
            json['data'] is List) {
          jumuiya = (json['data'] as List)
              .map((item) => Jumuiya.fromJson(item))
              .toList();
        }
      }
    }
    setState(() {
      _dataProvince = jumuiya;
    });
  }

  void getKatibu() async {
    String myApi = "${ApiUrl.BASEURL}getkatibu.php";
    final response = await http.post(
      Uri.parse(myApi),
      headers: {'Accept': 'application/json'},
      body: jsonEncode({
        "kanisa_id": kanisaData != null ? kanisaData!.id : '',
      }),
    );
    dynamic katibus;
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        if (json is Map &&
            json.containsKey('data') &&
            json['data'] != null &&
            json['data'] is List) {
          katibus = (json['data'] as List)
              .map((item) => Katibu.fromJson(item))
              .toList();
        } else if (json is List) {
          katibus = json.map((item) => Katibu.fromJson(item)).toList();
        } else {
          katibus = [];
        }
      }
    }
    setState(() {
      katibuWaJumuiya = katibus;
    });
  }

  void _initializeControllers() {
    _jinaController =
        TextEditingController(text: widget.msharika.jinaLaMsharika);
    _jinsiaController = TextEditingController(text: widget.msharika.jinsia);
    _umriController = TextEditingController(text: widget.msharika.umri);
    _haliYaNdoaController =
        TextEditingController(text: widget.msharika.haliYaNdoa);
    _jinaLaMwenziController =
        TextEditingController(text: widget.msharika.jinaLaMwenziWako);
    _nambaYaAhadiController =
        TextEditingController(text: widget.msharika.nambaYaAhadi);
    _ainaNdoaController = TextEditingController(text: widget.msharika.ainaNdoa);
    _jinaMtoto1Controller =
        TextEditingController(text: widget.msharika.jinaMtoto1);
    _tareheMtoto1Controller =
        TextEditingController(text: widget.msharika.tareheMtoto1);
    _uhusianoMtoto1Controller =
        TextEditingController(text: widget.msharika.uhusianoMtoto1);
    _jinaMtoto2Controller =
        TextEditingController(text: widget.msharika.jinaMtoto2);
    _tareheMtoto2Controller =
        TextEditingController(text: widget.msharika.tareheMtoto2);
    _uhusianoMtoto2Controller =
        TextEditingController(text: widget.msharika.uhusianoMtoto2);
    _jinaMtoto3Controller =
        TextEditingController(text: widget.msharika.jinaMtoto3);
    _tareheMtoto3Controller =
        TextEditingController(text: widget.msharika.tareheMtoto3);
    _uhusianoMtoto3Controller =
        TextEditingController(text: widget.msharika.uhusianoMtoto3);
    _nambaSimuController =
        TextEditingController(text: widget.msharika.nambaYaSimu);
    _jengoController = TextEditingController(text: widget.msharika.jengo);
    _ahadiController = TextEditingController(text: widget.msharika.ahadi);
    _kaziController = TextEditingController(text: widget.msharika.kazi);
    _elimuController = TextEditingController(text: widget.msharika.elimu);
    _ujuziController = TextEditingController(text: widget.msharika.ujuzi);
    _mahaliPakaziController =
        TextEditingController(text: widget.msharika.mahaliPakazi);
    _jumuiyaUshirikiController =
        TextEditingController(text: widget.msharika.jumuiyaUshiriki);
    _jinaLaJumuiyaController =
        TextEditingController(text: widget.msharika.jinaLaJumuiya);
    _idYaJumuiyaController =
        TextEditingController(text: widget.msharika.idYaJumuiya);
    _katibuJumuiyaController =
        TextEditingController(text: widget.msharika.katibuJumuiya);
    _kamaUshirikiController =
        TextEditingController(text: widget.msharika.kamaUshiriki);
    _katibuStatusController =
        TextEditingController(text: widget.msharika.katibuStatus);
    _mzeeStatusController =
        TextEditingController(text: widget.msharika.mzeeStatus);
    _usharikaStatusController =
        TextEditingController(text: widget.msharika.idYaJumuiya);
    _regYearIdController =
        TextEditingController(text: widget.msharika.regYearId);
    _tareheController = TextEditingController(text: widget.msharika.tarehe);
    _kanisaIdController = TextEditingController(text: widget.msharika.kanisaId);
    _passwordController = TextEditingController(text: widget.msharika.password);
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isDate = false,
    bool isRequired = false,
    bool isPhoneNumber = false,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        // readOnly: isDate,
        readOnly: readOnly,
        keyboardType: isPhoneNumber ? TextInputType.phone : TextInputType.text,
        maxLength: isPhoneNumber ? 10 : null,
        onTap: isDate ? () => _selectDate(context, controller) : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: MyColors.primaryLight),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyColors.primaryLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: MyColors.primaryLight.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyColors.primaryLight),
          ),
          counterText: '',
        ),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return 'Please enter $label';
          }
          if (isPhoneNumber) {
            if (value == null || value.isEmpty) {
              return 'Tafadhali ingiza namba ya simu';
            }
            if (value.length != 10) {
              return 'Namba ya simu lazima iwe na tarakimu 10';
            }
            if (!value.startsWith('06') && !value.startsWith('07')) {
              return 'Namba ya simu lazima ianze na 06 au 07';
            }
            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
              return 'Namba ya simu lazima iwe na tarakimu tu';
            }
          }
          return null;
        },
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = "${picked.year}-${picked.month}-${picked.day}";
    }
  }

  List<Step> get formSteps => [
        Step(
          title: Text('Taarifa Binafsi', style: GoogleFonts.poppins()),
          content: Column(
            children: [
              _buildTextField(_jinaController, 'Jina Kamili', Icons.person),
              _buildTextField(
                  _jinsiaController, 'Jinsia', Icons.person_outline),
              _buildTextField(_umriController, 'Umri', Icons.calendar_today),
              _buildRadioGroup(
                title: 'Hali ya ndoa',
                options: ['Nimeoa', 'Sijaoa', 'Mgane', 'Talakiwa'],
                groupValue: _haliNdoa,
                onChanged: (value) {
                  setState(() {
                    _haliNdoa = value;
                    _haliYaNdoaController.text = value;
                  });
                },
              ),
            ],
          ),
          isActive: _currentStep >= 0,
        ),
        Step(
          title: Text('Taarifa za Familia', style: GoogleFonts.poppins()),
          content: Column(
            children: [
              _buildRadioGroup(
                title: '7. Aina ya ndoa',
                options: [
                  'Ndoa ya Kikristo',
                  'Ndoa isiyo ya Kikristo',
                  'Hakuna Ndoa'
                ],
                groupValue: _ndoa,
                onChanged: (value) {
                  setState(() {
                    _ndoa = value;
                    _ainaNdoaController.text = value;
                  });
                },
              ),
              if (_ndoa == 'Ndoa ya Kikristo') ...[
                _buildTextField(
                    _jinaLaMwenziController, 'Jina la Mwenzi', Icons.people),
              ]
            ],
          ),
          isActive: _currentStep >= 1,
        ),
        Step(
          title: Text('Taarifa za Watoto', style: GoogleFonts.poppins()),
          content: Column(
            children: [
              _buildChildSection(
                'Mtoto 1',
                _jinaMtoto1Controller,
                _tareheMtoto1Controller,
                _uhusianoMtoto1Controller,
                isDateEnabled: true,
              ),
              _buildChildSection(
                'Mtoto 2',
                _jinaMtoto2Controller,
                _tareheMtoto2Controller,
                _uhusianoMtoto2Controller,
                isDateEnabled: true,
              ),
              _buildChildSection(
                'Mtoto 3',
                _jinaMtoto3Controller,
                _tareheMtoto3Controller,
                _uhusianoMtoto3Controller,
                isDateEnabled: true,
              ),
            ],
          ),
          isActive: _currentStep >= 2,
        ),
        Step(
          title: Text('Mawasiliano na Kazi', style: GoogleFonts.poppins()),
          content: Column(
            children: [
              _buildTextField(
                _nambaSimuController,
                'Namba ya Simu',
                Icons.phone,
                isPhoneNumber: true,
              ),
              _buildTextField(_kaziController, 'Kazi', Icons.work),
              _buildTextField(_elimuController, 'Elimu', Icons.school),
              _buildTextField(_ujuziController, 'Ujuzi', Icons.psychology),
              _buildTextField(
                  _mahaliPakaziController, 'Mahali pa Kazi', Icons.location_on),
            ],
          ),
          isActive: _currentStep >= 3,
        ),
        Step(
          title: Text('Taarifa za Kanisa', style: GoogleFonts.poppins()),
          content: Column(
            children: [
              _buildTextField(_nambaYaAhadiController, 'Namba ya Ahadi',
                  Icons.confirmation_number),
              _buildTextField(_jengoController, 'Jengo', Icons.home),
              _buildTextField(_ahadiController, 'Ahadi', Icons.description),
              // _buildTextField(
              //     _jinaLaJumuiyaController, 'Jina la Jumuiya', Icons.groups),
              _buildRadioGroup(
                title: 'Unashiriki ibada za nyumba kwa nyumba $_ushiriki',
                options: ['Ndio', 'Hapana'],
                groupValue: _ushiriki,
                onChanged: (value) {
                  setState(() {
                    _ushiriki = value;
                    _jumuiyaUshirikiController.text = value;
                  });
                },
              ),
              if (_ushiriki == 'Ndio') ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '2. Jina la jumuiya',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDropdown(),
                    const SizedBox(height: 16),
                  ],
                ),
              ] else if (_ushiriki == 'Hapana') ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kama Haushiriki weka sababu ya kutokushiriki',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextFieldValue(
                      controller: _kamaUshirikiController,
                      labelText:
                          "Sababu ya kutokushiriki jumuiya $_ushiriki ${_jumuiyaUshirikiController.text}",
                      icon: Icons.info_outline,
                      keyboardType: TextInputType.text,
                      // errorText: "Tafadhari weka sababu ya kutokushiriki jumuiya",
                    ),
                  ],
                ),
              ],
            ],
          ),
          isActive: _currentStep >= 4,
        ),
        Step(
          title: Text('Taarifa za Hadhi', style: GoogleFonts.poppins()),
          content: Column(
            children: [
              _buildTextField(_katibuStatusController, 'Hadhi ya Ukatibu',
                  Icons.assignment_ind,
                  readOnly: true),
              _buildTextField(
                  _mzeeStatusController, 'Hadhi ya Uzee', Icons.person_outline,
                  readOnly: true),
              _buildTextField(_usharikaStatusController, 'Hadhi ya Ushirika',
                  Icons.people_outline,
                  readOnly: true),
            ],
          ),
          isActive: _currentStep >= 5,
        ),
      ];

  Widget _buildTextFieldValue({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    VoidCallback? onTap,
    bool readOnly = false,
    String? errorText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onTap: onTap,
            readOnly: readOnly,
            focusNode: readOnly ? AlwaysDisabledFocusNode() : null,
            decoration: InputDecoration(
              labelText: labelText,
              prefixIcon: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MyColors.primaryLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: MyColors.primaryLight, size: 20),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: MyColors.primaryLight, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              labelStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ),
          if (errorText != null && errorText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 16),
              child: Text(
                errorText,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    if (_dataProvince == null) return const SizedBox();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade50,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: MyColors.primaryLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.home_work_outlined,
                    color: MyColors.primaryLight, size: 20),
              ),
              const SizedBox(width: 12),
              const Text("Chagua Jumuiya yako"),
            ],
          ),
          value: _valProvince,
          icon: Icon(Icons.arrow_drop_down, color: MyColors.primaryLight),
          style: TextStyle(color: MyColors.primaryLight, fontSize: 16),
          items: _dataProvince!.map((item) {
            return DropdownMenuItem<String>(
              value: item.id.toString(), // Use jumuiya_id as value
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: MyColors.primaryLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.home_work_outlined,
                        color: MyColors.primaryLight, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item.jumuiyaName,
                    style: TextStyle(
                      color: MyColors.primaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) async {
            setState(() {
              _valProvince = value;
              idYaJumuiya = value ?? '';
              _idYaJumuiyaController.text = value ?? '';
              // // Find jumuiya name for selected id
              final selectedJumuiya =
                  // ignore: unrelated_type_equality_checks
                  _dataProvince!.firstWhere((j) => j.id == value,
                      orElse: () => _dataProvince!.first);

              _katibuJumuiyaController.text =
                  selectedJumuiya.katibuId.toString();
              _jinaLaJumuiyaController.text = selectedJumuiya.jumuiyaName;
            });
          },
        ),
      ),
    );
  }

  Widget _buildChildSection(
    String label,
    TextEditingController nameController,
    TextEditingController dateController,
    TextEditingController relationController, {
    bool isDateEnabled = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: MyColors.primaryLight,
          ),
        ),
        const SizedBox(height: 8),
        _buildTextField(nameController, 'Jina', Icons.child_care),
        _buildTextField(
          dateController,
          'Tarehe',
          Icons.date_range,
          isDate: isDateEnabled,
        ),
        _buildTextField(relationController, 'Uhusiano', Icons.family_restroom),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _updateMsharika() async {
    if (!_formKey.currentState!.validate()) return;

    if (_jinaController.text == "" ||
        _nambaSimuController.text == "" ||
        _ahadiController.text == "" ||
        _jengoController.text == "" ||
        _jinsiaController.text == "" ||
        _umriController.text == "") {
      Alerts.show(context, "Kuna shida",
          "Tafadhali jaza taarifa muhimu(Jina,namba ya simu,ahadi na jengo,jinsia,kanisa code,umri)");
    } else if (_nambaSimuController.text.length != 10 ||
        (!_nambaSimuController.text.startsWith("06") &&
            !_nambaSimuController.text.startsWith("07"))) {
      Alerts.show(context, "Kuna shida",
          "Tafadhali weka namba ya simu sahihi. Namba ya simu lazima ianze na 06 au 07 na lazima ziwe tarakimu kumi(10).");
    } else if (_jinaLaJumuiyaController.text != '' &&
        _jumuiyaUshirikiController.text == 'Ndio' &&
        (_jinaLaJumuiyaController.text.isEmpty ||
            _katibuJumuiyaController.text.isEmpty)) {
      Alerts.show(
        context,
        "Kuna shida",
        "Umechagua unashiriki jumuiya lakin kuna taarifa ujaziweka kama (jina la jumiya na jina la katibu wa jumiya) $_jumuiyaUshirikiController",
      );
    } else if ((_haliNdoa != '' && _haliNdoa == 'Nimeoa') &&
        (_jinaLaMwenziController.text.isEmpty)) {
      Alerts.show(
        context,
        "Kuna shida",
        "Umechagua nimeo tafadhari weka jina la mwenzi wako",
      );
    } else if (_jinaController.text.length < 3) {
      Alerts.show(
        context,
        "Kuna shida",
        "Tafadhali Hakikisha umeweka majina matatu",
      );
    } else if ((_ushiriki != '' && _ushiriki == 'ndio') &&
        (_jinaLaJumuiyaController.text.isEmpty)) {
      Alerts.show(context, "Kuna shida",
          "Tafadhali jaza taarifa muhimu(Jina la jumuiya)");
    } else {
      setState(() => _isLoading = true);

      try {
        final response = await http.post(
          Uri.parse(
              "${ApiUrl.BASEURL}api2/usajili_msharika/update_usajili_msharika.php"),
          headers: {'Accept': 'application/json'},
          body: jsonEncode({
            'id': widget.msharika.id,
            'jina_la_msharika': _jinaController.text,
            'jinsia': _jinsiaController.text,
            'umri': _umriController.text,
            'hali_ya_ndoa': _haliYaNdoaController.text,
            'jina_la_mwenzi_wako': _jinaLaMwenziController.text,
            'namba_ya_ahadi': _nambaYaAhadiController.text,
            'aina_ya_ndoa': _ainaNdoaController.text,
            'jina_mtoto1': _jinaMtoto1Controller.text,
            'tarehe_mtoto1': _tareheMtoto1Controller.text,
            'uhusiano_mtoto1': _uhusianoMtoto1Controller.text,
            'jina_mtoto2': _jinaMtoto2Controller.text,
            'tarehe_mtoto2': _tareheMtoto2Controller.text,
            'uhusiano_mtoto2': _uhusianoMtoto2Controller.text,
            'jina_mtoto3': _jinaMtoto3Controller.text,
            'tarehe_mtoto3': _tareheMtoto3Controller.text,
            'uhusiano_mtoto3': _uhusianoMtoto3Controller.text,
            'namba_ya_simu': _nambaSimuController.text,
            'jengo': _jengoController.text,
            'ahadi': _ahadiController.text,
            'kazi': _kaziController.text,
            'elimu': _elimuController.text,
            'ujuzi': _ujuziController.text,
            'mahali_pakazi': _mahaliPakaziController.text,
            'jumuiya_ushiriki': _jumuiyaUshirikiController.text,
            'jina_la_jumuiya': _jinaLaJumuiyaController.text,
            'id_ya_jumuiya': _idYaJumuiyaController.text,
            'katibu_jumuiya': _katibuJumuiyaController.text,
            'kama_ushiriki': _kamaUshirikiController.text,
            'katibu_status': _katibuStatusController.text,
            'mzee_status': _mzeeStatusController.text,
            'usharika_status': _usharikaStatusController.text,
            'reg_year_id': _regYearIdController.text,
            'tarehe': _tareheController.text,
            'kanisa_id': _kanisaIdController.text,
          }),
        );

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);

          if (jsonResponse['status'] == 200) {
            widget.onUpdateSuccess();
            Navigator.pop(context);
            _showSuccessMessage(
                'Taarifa za msharika zimesasishwa kwa mafanikio');
          } else {
            _showErrorMessage('Imeshindikana kusahihisha taarifa za msharika');
          }
        } else {
          _showErrorMessage('Imeshindikana kusahihisha taarifa za msharika');
        }
      } catch (e) {
        _showErrorMessage(
            'Kuna tatizo limetokea kwenye kusahihisha taarifa za msharika $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primaryLight,
        title: Text('Sahihisha Msharika',
            style: GoogleFonts.poppins(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepTapped: (step) => setState(() => _currentStep = step),
          onStepContinue: () {
            final isLastStep = _currentStep == formSteps.length - 1;
            if (isLastStep) {
              _updateMsharika();
            } else {
              setState(() => _currentStep += 1);
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep -= 1);
            } else {
              Navigator.pop(context);
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primaryLight,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        _currentStep == formSteps.length - 1 ? 'Save' : 'Next',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        _currentStep == 0 ? 'Cancel' : 'Back',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          steps: formSteps,
        ),
      ),
    );
  }

  Widget _buildRadioGroup({
    required String title,
    required List<String> options,
    required String groupValue,
    required Function(String) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...options.map((option) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => onChanged(option),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: groupValue == option
                          ? MyColors.primaryLight.withOpacity(0.1)
                          : Colors.transparent,
                      border: Border.all(
                        color: groupValue == option
                            ? MyColors.primaryLight
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: option,
                          groupValue: groupValue,
                          onChanged: (value) => onChanged(value!),
                          activeColor: MyColors.primaryLight,
                        ),
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 15,
                              color: groupValue == option
                                  ? MyColors.primaryLight
                                  : Colors.black87,
                              fontWeight: groupValue == option
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    _jinaController.dispose();
    _jinsiaController.dispose();
    _umriController.dispose();
    _haliYaNdoaController.dispose();
    _jinaLaMwenziController.dispose();
    _nambaYaAhadiController.dispose();
    _ainaNdoaController.dispose();
    _jinaMtoto1Controller.dispose();
    _tareheMtoto1Controller.dispose();
    _uhusianoMtoto1Controller.dispose();
    _jinaMtoto2Controller.dispose();
    _tareheMtoto2Controller.dispose();
    _uhusianoMtoto2Controller.dispose();
    _jinaMtoto3Controller.dispose();
    _tareheMtoto3Controller.dispose();
    _uhusianoMtoto3Controller.dispose();
    _nambaSimuController.dispose();
    _jengoController.dispose();
    _ahadiController.dispose();
    _kaziController.dispose();
    _elimuController.dispose();
    _ujuziController.dispose();
    _mahaliPakaziController.dispose();
    _jumuiyaUshirikiController.dispose();
    _jinaLaJumuiyaController.dispose();
    _idYaJumuiyaController.dispose();
    _katibuJumuiyaController.dispose();
    _kamaUshirikiController.dispose();
    _katibuStatusController.dispose();
    _mzeeStatusController.dispose();
    _usharikaStatusController.dispose();
    _regYearIdController.dispose();
    _tareheController.dispose();
    _kanisaIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
