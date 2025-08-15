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

  String _haliNdoa = '';
  String _ndoa = '';
  String _ushiriki = '';

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _haliNdoa = widget.msharika.haliYaNdoa;
    _ndoa = widget.msharika.ainaNdoa;
    _ushiriki = widget.msharika.jumuiyaUshiriki;
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
    bool isPhoneNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: isDate,
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
              _buildTextField(
                  _jinaLaMwenziController, 'Jina la Mwenzi', Icons.people),
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
              _buildTextField(
                  _jinaLaJumuiyaController, 'Jina la Jumuiya', Icons.groups),
              _buildRadioGroup(
                title: 'Unashiriki ibada za nyumba kwa nyumba',
                options: ['Ndio', 'Hapana'],
                groupValue: _ushiriki,
                onChanged: (value) {
                  setState(() {
                    _ushiriki = value;
                    _jumuiyaUshirikiController.text = value;
                  });
                },
              ),
            ],
          ),
          isActive: _currentStep >= 4,
        ),
        Step(
          title: Text('Taarifa za Hadhi', style: GoogleFonts.poppins()),
          content: Column(
            children: [
              _buildTextField(_katibuStatusController, 'Hadhi ya Ukatibu',
                  Icons.assignment_ind),
              _buildTextField(
                  _mzeeStatusController, 'Hadhi ya Uzee', Icons.person_outline),
              _buildTextField(_usharikaStatusController, 'Hadhi ya Ushirika',
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

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("${ApiUrl.BASEURL}jisajili.php"),
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
