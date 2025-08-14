// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanisaapp/models/msharika_model.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeControllers();
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
        TextEditingController(text: widget.msharika.usharikaStatus);
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
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: isDate,
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
        ),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return 'Please enter $label';
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
          title: Text('Personal Information', style: GoogleFonts.poppins()),
          content: Column(
            children: [
              _buildTextField(_jinaController, 'Full Name', Icons.person),
              _buildTextField(
                  _jinsiaController, 'Gender', Icons.person_outline),
              _buildTextField(_umriController, 'Age', Icons.calendar_today),
              _buildTextField(
                  _haliYaNdoaController, 'Marital Status', Icons.favorite),
            ],
          ),
          isActive: _currentStep >= 0,
        ),
        Step(
          title: Text('Family Information', style: GoogleFonts.poppins()),
          content: Column(
            children: [
              _buildTextField(
                  _jinaLaMwenziController, 'Spouse Name', Icons.people),
              _buildTextField(
                  _ainaNdoaController, 'Marriage Type', Icons.family_restroom),
            ],
          ),
          isActive: _currentStep >= 1,
        ),
        Step(
          title: Text('Children Information', style: GoogleFonts.poppins()),
          content: Column(
            children: [
              _buildChildSection(
                'Child 1',
                _jinaMtoto1Controller,
                _tareheMtoto1Controller,
                _uhusianoMtoto1Controller,
                isDateEnabled: true,
              ),
              _buildChildSection(
                'Child 2',
                _jinaMtoto2Controller,
                _tareheMtoto2Controller,
                _uhusianoMtoto2Controller,
                isDateEnabled: true,
              ),
              _buildChildSection(
                'Child 3',
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
          title: Text('Contact & Work', style: GoogleFonts.poppins()),
          content: Column(
            children: [
              _buildTextField(
                  _nambaSimuController, 'Phone Number', Icons.phone),
              _buildTextField(_kaziController, 'Occupation', Icons.work),
              _buildTextField(_elimuController, 'Education', Icons.school),
              _buildTextField(_ujuziController, 'Skills', Icons.psychology),
              _buildTextField(
                  _mahaliPakaziController, 'Work Location', Icons.location_on),
            ],
          ),
          isActive: _currentStep >= 3,
        ),
        Step(
          title: Text('Church Information', style: GoogleFonts.poppins()),
          content: Column(
            children: [
              _buildTextField(_nambaYaAhadiController, 'Promise Number',
                  Icons.confirmation_number),
              _buildTextField(_jengoController, 'Building', Icons.home),
              _buildTextField(_ahadiController, 'Promise', Icons.description),
              _buildTextField(
                  _jinaLaJumuiyaController, 'Community Name', Icons.groups),
              _buildTextField(_jumuiyaUshirikiController,
                  'Community Participation', Icons.group_add),
            ],
          ),
          isActive: _currentStep >= 4,
        ),
        Step(
          title: Text('Status Information', style: GoogleFonts.poppins()),
          content: Column(
            children: [
              _buildTextField(_katibuStatusController, 'Secretary Status',
                  Icons.assignment_ind),
              _buildTextField(
                  _mzeeStatusController, 'Elder Status', Icons.person_outline),
              _buildTextField(_usharikaStatusController, 'Fellowship Status',
                  Icons.people_outline),
            ],
          ),
          isActive: _currentStep >= 5,
        ),
      ];

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
        _buildTextField(nameController, 'Name', Icons.child_care),
        _buildTextField(
          dateController,
          'Date',
          Icons.date_range,
          isDate: isDateEnabled,
        ),
        _buildTextField(relationController, 'Relation', Icons.family_restroom),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _updateMsharika() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("${ApiUrl.BASEURL}update_msharika.php"),
        body: {
          'id': widget.msharika.id,
          'jina_la_msharika': _jinaController.text,
          'jinsia': _jinsiaController.text,
          'umri': _umriController.text,
          'hali_ya_ndoa': _haliYaNdoaController.text,
          'jina_la_mwenzi_wako': _jinaLaMwenziController.text,
          'namba_ya_ahadi': _nambaYaAhadiController.text,
          'aina_ndoa': _ainaNdoaController.text,
          'jina_mtoto1': _jinaMtoto1Controller.text,
          'tarehe_mtoto1': _tareheMtoto1Controller.text,
          'uhusiano_mtoto1': _uhusianoMtoto1Controller.text,
          'jina_mtoto2': _jinaMtoto2Controller.text,
          'tarehe_mtoto2': _tareheMtoto2Controller.text,
          'uhusiano_mtoto2': _uhusianoMtoto2Controller.text,
          'jina_mtoto3': _jinaMtoto3Controller.text,
          'tarehe_mtoto3': _tareheMtoto3Controller.text,
          'uhusiano_mtoto3': _uhusianoMtoto3Controller.text,
          'namba_simuh': _nambaSimuController.text,
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
        },
      );

      if (response.statusCode == 200) {
        widget.onUpdateSuccess();
        Navigator.pop(context);
        _showSuccessMessage('Msharika updated successfully');
      } else {
        _showErrorMessage('Failed to update msharika');
      }
    } catch (e) {
      _showErrorMessage('Error occurred while updating msharika');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: GoogleFonts.poppins())),
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
