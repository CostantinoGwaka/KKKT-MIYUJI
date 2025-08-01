// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kanisaapp/models/Jumuiya.dart';
import 'package:kanisaapp/models/jumuiya_model.dart';
import 'package:kanisaapp/models/kanisa_model.dart';
import 'package:kanisaapp/models/makatibu.dart';
import 'package:kanisaapp/models/mwaka_wa_kanisa.dart';
import 'package:kanisaapp/utils/Alerts.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/TextStyles.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/home/screens/index.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  static const routeName = "/registrationscreen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Kanisa? kanisaData;
  InactiveYear? inactiveYearData;

  String _halindoa = '';
  String _jinsiaYako = '';
  String _ndoa = '';
  String _ushiriki = '';
  String idYaJumuiya = '';
  String msgErrorPhoneNumber = '';
  String msgErrorPhoneNumber2 = '';
  String msgErrorPhoneNumber3 = '';

  // Text controllers
  TextEditingController jinaLaMsharika = TextEditingController();
  TextEditingController jinsia = TextEditingController();
  TextEditingController haliYaNdoa = TextEditingController();
  TextEditingController jinaLaMwenziWako = TextEditingController();
  TextEditingController nambaYaAhadi = TextEditingController();
  TextEditingController ainaYaNdoa = TextEditingController();
  TextEditingController jinaMtoto_1 = TextEditingController();
  TextEditingController tareheMtoto_1 = TextEditingController();
  TextEditingController uhusianoMtoto_1 = TextEditingController();
  TextEditingController jinaMtoto_2 = TextEditingController();
  TextEditingController tareheMtoto_2 = TextEditingController();
  TextEditingController uhusianoMtoto_2 = TextEditingController();
  TextEditingController jinaMtoto_3 = TextEditingController();
  TextEditingController tareheMtoto_3 = TextEditingController();
  TextEditingController uhusianoMtoto_3 = TextEditingController();
  TextEditingController nambaYaSimu = TextEditingController();
  TextEditingController jengo = TextEditingController();
  TextEditingController ahadi = TextEditingController();
  TextEditingController kazi = TextEditingController();
  TextEditingController elimu = TextEditingController();
  TextEditingController ujuzi = TextEditingController();
  TextEditingController mahaliPakazi = TextEditingController();
  TextEditingController jumuiyaUshiriki = TextEditingController();
  TextEditingController jinaLaJumuiya = TextEditingController();
  TextEditingController katibuJumuiya = TextEditingController();
  TextEditingController kamaUshiriki = TextEditingController();
  TextEditingController kanisaCode = TextEditingController();
  TextEditingController umri = TextEditingController();

  DateTime? tareheMtotoOne, tareheMtotoTwo, tareheMtotoThree;

  var jumuiyaList = <JumuiyaData>[];
  JumuiyaData? dropdownValue;
  String? _valProvince;
  List<Jumuiya>? _dataProvince;
  dynamic usajiliId;
  String krid = "";
  List<Katibu> katibuWaJumuiya = [];
  int pagecontrolnumber = 0;
  String selectedJumuiyaId = "";
  String selectedKatibuId = "";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    nambaYaSimu.addListener(productCountListener);
    kamaUshiriki.addListener(productCountListener2);
    jinaLaMsharika.addListener(productCountListenerJina);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
    var jumuiya;

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        // jumuiya = (json as List).map((item) => Jumuiya.fromJson(item)).toList();
        if (json is Map && json.containsKey('data') && json['data'] != null && json['data'] is List) {
          jumuiya = (json['data'] as List).map((item) => Jumuiya.fromJson(item)).toList();
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
    var katibus;
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        if (json is Map && json.containsKey('data') && json['data'] != null && json['data'] is List) {
          katibus = (json['data'] as List).map((item) => Katibu.fromJson(item)).toList();
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

  Future<InactiveYear?> getActiveKanisaYearDetails() async {
    String myApi = "${ApiUrl.BASEURL}get_kanisa_year.php";
    final response = await http.post(
      Uri.parse(myApi),
      headers: {'Accept': 'application/json'},
    );

    var mwaka;

    var jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        mwaka = json;
      }
    }

    if (mwaka != null) {
      if (mwaka is Map && mwaka.containsKey('data')) {
        // Handle single object response
        setState(() {
          inactiveYearData = InactiveYear.fromJson(mwaka['data']);
          krid = inactiveYearData!.yearId;
        });
      }
    }

    return inactiveYearData; // Return a list with the kanisa data or an empty list
  }

  Future<Kanisa?> getKanisaDetails() async {
    String myApi = "${ApiUrl.BASEURL}get_kanisa_details.php";
    final response = await http.post(
      Uri.parse(myApi),
      headers: {'Accept': 'application/json'},
      body: jsonEncode({
        "kanisacode": kanisaCode.text.trim(),
      }),
    );

    var kanisa;

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
      }
    }

    return kanisaData; // Return a list with the kanisa data or an empty list
  }

  Future<bool> validateKanisaCode(String kanisaCode) async {
    try {
      Kanisa? kanisaObj = await getKanisaDetails();

      await getActiveKanisaYearDetails();

      // Check if the entered kanisa code exists
      bool kanisaExists = kanisaObj != null && kanisaObj.kanisacode.toLowerCase() == kanisaCode.toLowerCase();

      return kanisaExists;
    } catch (e) {
      if (kDebugMode) {
        print("Error validating kanisa code: $e");
      }
      return false;
    }
  }

  // Validation listeners
  productCountListener() {
    if (kDebugMode) {
      print(
          "value# ${nambaYaSimu.value.text.length} ${nambaYaSimu.value.text.startsWith("06") || nambaYaSimu.value.text.startsWith("07")}");
    }
    if (nambaYaSimu.value.text.length != 10 ||
        (!nambaYaSimu.value.text.startsWith("06") && !nambaYaSimu.value.text.startsWith("07"))) {
      setState(() {
        msgErrorPhoneNumber =
            "Tafadhali weka namba ya simu sahihi. Namba ya simu lazima ianze na 06 au 07 na lazima ziwe tarakimu kumi(10).";
      });
    } else {
      setState(() {
        msgErrorPhoneNumber = '';
      });
    }
  }

  productCountListenerJina() {
    final String s = jinaLaMsharika.value.text;
    final List l = s.split(' ');
    if (l.length < 3) {
      setState(() {
        msgErrorPhoneNumber3 = "Tafadhali weka jina ya sahihi jina linatakiwa kuwa matatu";
      });
    } else {
      setState(() {
        msgErrorPhoneNumber3 = '';
      });
    }
  }

  productCountListener2() {
    if (kamaUshiriki.value.text.length != 10 || !kamaUshiriki.value.text.startsWith("0")) {
      setState(() {
        msgErrorPhoneNumber2 =
            "Tafadhali weka namba ya simu sahihi namba ya simu lazima ianze na sifuri(0) na lazima ziwe tarakimu kumi(10).";
      });
    } else {
      setState(() {
        msgErrorPhoneNumber2 = '';
      });
    }
  }

  // Date picker methods
  _tareheMtotoOne(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: tareheMtotoOne ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2040),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors.primaryLight,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (newSelectedDate != null) {
      tareheMtotoOne = newSelectedDate;
      tareheMtoto_1.text = DateFormat.yMMMd().format(tareheMtotoOne!);
    }
  }

  _tareheMtotoTwo(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: tareheMtotoTwo ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2040),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors.primaryLight,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (newSelectedDate != null) {
      tareheMtotoTwo = newSelectedDate;
      tareheMtoto_2.text = DateFormat.yMMMd().format(tareheMtotoTwo!);
    }
  }

  _tareheMtotoThree(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: tareheMtotoThree ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2040),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors.primaryLight,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (newSelectedDate != null) {
      tareheMtotoThree = newSelectedDate;
      tareheMtoto_3.text = DateFormat.yMMMd().format(tareheMtotoThree!);
    }
  }

  // Your existing validation and registration methods remain the same
  verifyFormAndSubmit() {
    String jinaLaMsharikaa = jinaLaMsharika.text;
    String haliYaNdoaa = haliYaNdoa.text;
    String jinsiaa = jinsia.text;
    String jinaLaMwenziWakoa = jinaLaMwenziWako.text;
    String nambaYaAhadia = nambaYaAhadi.text;
    String ainaYaNdoaa = ainaYaNdoa.text;
    String haliYaaNdoaa = haliYaNdoa.text;

    String jinaMtoto_1a = jinaMtoto_1.text;
    String tareheMtoto_1a = tareheMtoto_1.text;
    String uhusianoMtoto_1a = uhusianoMtoto_1.text;

    String jinaMtoto_2a = jinaMtoto_2.text;
    String tareheMtoto_2a = tareheMtoto_2.text;
    String uhusianoMtoto_2a = uhusianoMtoto_2.text;

    String jinaMtoto_3a = jinaMtoto_3.text;
    String tareheMtoto_3a = tareheMtoto_3.text;
    String uhusianoMtoto_3a = uhusianoMtoto_3.text;

    String nambaYaSimua = nambaYaSimu.text;
    String jengoa = jengo.text;
    String ahadia = ahadi.text;
    String kazia = kazi.text;
    String elimua = elimu.text;
    String ujuzia = ujuzi.text;
    String mahaliPakazia = mahaliPakazi.text;

    String jumuiyaUshirikia = jumuiyaUshiriki.text;
    String jinaLaJumuiyaa = jinaLaJumuiya.text;
    String idYaJumuiyaa = idYaJumuiya;
    String katibuJumuiyaa = katibuJumuiya.text;
    String kamaUshirikia = kamaUshiriki.text;
    String kanisaCodea = kanisaCode.text;
    String umria = umri.text;
    String krida = krid;

    final String s = jinaLaMsharika.value.text;
    final List l = s.split(' ');

    if (jinaLaMsharikaa == "" ||
        nambaYaSimua == "" ||
        ahadia == "" ||
        jengoa == "" ||
        krida == "" ||
        jinsiaa == "" ||
        kanisaCodea == "" ||
        umria == "") {
      Alerts.show(context, "Kuna shida",
          "Tafadhali jaza taarifa muhimu(Jina,namba ya simu,ahadi na jengo,jinsia,kanisa code,umri)");
    } else if (nambaYaSimua.length != 10 || (!nambaYaSimua.startsWith("06") && !nambaYaSimua.startsWith("07"))) {
      Alerts.show(context, "Kuna shida",
          "Tafadhali weka namba ya simu sahihi. Namba ya simu lazima ianze na 06 au 07 na lazima ziwe tarakimu kumi(10).");
    } else if (jumuiyaUshirikia != '' &&
        jumuiyaUshirikia == 'ndio' &&
        (jinaLaJumuiyaa.isEmpty || katibuJumuiyaa.isEmpty)) {
      Alerts.show(
        context,
        "Kuna shida",
        "Umechagua unashiriki jumuiya lakin kuna taarifa ujaziweka kama (jina la jumiya na jina la katibu wa jumiya) $jumuiyaUshirikia",
      );
    } else if ((_halindoa != '' && _halindoa == 'Nimeoa') && (jinaLaMwenziWako.text.isEmpty)) {
      Alerts.show(
        context,
        "Kuna shida",
        "Umechagua nimeo tafadhari weka jina la mwenzi wako",
      );
    } else if (l.length < 3) {
      Alerts.show(
        context,
        "Kuna shida",
        "Tafadhali Hakikisha umeweka majina matatu",
      );
    } else if ((_ushiriki != '' && _ushiriki == 'ndio') && (jinaLaJumuiya.text.isEmpty)) {
      Alerts.show(context, "Kuna shida", "Tafadhali jaza taarifa muhimu(Jina la jumuiya)");
    } else {
      registerUser(
        jinaLaMsharikaa,
        jinsiaa,
        haliYaNdoaa,
        jinaLaMwenziWakoa,
        nambaYaAhadia,
        ainaYaNdoaa,
        haliYaaNdoaa,
        jinaMtoto_1a,
        tareheMtoto_1a,
        uhusianoMtoto_1a,
        jinaMtoto_2a,
        tareheMtoto_2a,
        uhusianoMtoto_2a,
        jinaMtoto_3a,
        tareheMtoto_3a,
        uhusianoMtoto_3a,
        nambaYaSimua,
        jengoa,
        ahadia,
        kazia,
        elimua,
        ujuzia,
        mahaliPakazia,
        jumuiyaUshirikia,
        jinaLaJumuiyaa,
        idYaJumuiyaa,
        katibuJumuiyaa,
        kamaUshirikia,
        kanisaCodea,
        umria,
        krida,
      );
    }
  }

  Future<void> registerUser(
    jinaLaMsharika,
    jinsia,
    haliYaNdoa,
    jinaLaMwenziWako,
    nambaYaAhadi,
    ainaYaNdoa,
    haliYaaNdoa,
    jinaMtoto_1,
    tareheMtoto_1,
    uhusianoMtoto_1,
    jinaMtoto_2,
    tareheMtoto_2,
    uhusianoMtoto_2,
    jinaMtoto_3,
    tareheMtoto_3,
    uhusianoMtoto_3,
    nambaYaSimu,
    jengo,
    ahadi,
    kazi,
    elimu,
    ujuzi,
    mahaliPakazi,
    jumuiyaUshiriki,
    jinaLaJumuiya,
    idYaJumuiya,
    katibuJumuiya,
    kamaUshiriki,
    kanisaCode,
    umri,
    krid,
  ) async {
    try {
      Alerts.showProgressDialog(context, "Tafadhari subiri");
      String myApi = "${ApiUrl.BASEURL}jisajili.php/";

      var now = DateTime.now();

      final response = await http.post(Uri.parse(myApi), headers: {
        'Accept': 'application/json'
      }, body: {
        "jina_la_msharika": "$jinaLaMsharika",
        "jinsia": "$jinsia",
        "hali_ya_ndoa": "$haliYaNdoa",
        "jina_la_mwenzi_wako": "$jinaLaMwenziWako",
        "namba_ya_ahadi": "$nambaYaAhadi",
        "aina_ya_ndoa": "$ainaYaNdoa",
        "jina_mtoto_1": "$jinaMtoto_1",
        "tarehe_mtoto_1": "$tareheMtoto_1",
        "uhusiano_mtoto_1": "$uhusianoMtoto_1",
        "jina_mtoto_2": "$jinaMtoto_2",
        "tarehe_mtoto_2": "$tareheMtoto_2",
        "uhusiano_mtoto_2": "$uhusianoMtoto_2",
        "jina_mtoto_3": "$jinaMtoto_3",
        "tarehe_mtoto_3": "$tareheMtoto_3",
        "uhusiano_mtoto_3": "$uhusianoMtoto_3",
        "namba_ya_simu": "$nambaYaSimu",
        "jengo": "$jengo",
        "ahadi": "$ahadi",
        "kazi": "$kazi",
        "elimu": "$elimu",
        "ujuzi": "$ujuzi",
        "mahali_pakazi": "$mahaliPakazi",
        "jumuiya_ushiriki": "$jumuiyaUshiriki",
        "jina_la_jumuiya": "$jinaLaJumuiya",
        "id_ya_jumuiya": "$idYaJumuiya",
        "katibu_jumuiya": "$katibuJumuiya",
        "kama_ushiriki": "$kamaUshiriki",
        "kanisacode": "$kanisaCode",
        "umri": "$umri",
        "reg_year_id": "$krid",
        "tarehe": "$now"
      });

      print({
        "jina_la_msharika": "$jinaLaMsharika",
        "jinsia": "$jinsia",
        "hali_ya_ndoa": "$haliYaNdoa",
        "jina_la_mwenzi_wako": "$jinaLaMwenziWako",
        "namba_ya_ahadi": "$nambaYaAhadi",
        "aina_ya_ndoa": "$ainaYaNdoa",
        "jina_mtoto_1": "$jinaMtoto_1",
        "tarehe_mtoto_1": "$tareheMtoto_1",
        "uhusiano_mtoto_1": "$uhusianoMtoto_1",
        "jina_mtoto_2": "$jinaMtoto_2",
        "tarehe_mtoto_2": "$tareheMtoto_2",
        "uhusiano_mtoto_2": "$uhusianoMtoto_2",
        "jina_mtoto_3": "$jinaMtoto_3",
        "tarehe_mtoto_3": "$tareheMtoto_3",
        "uhusiano_mtoto_3": "$uhusianoMtoto_3",
        "namba_ya_simu": "$nambaYaSimu",
        "jengo": "$jengo",
        "ahadi": "$ahadi",
        "kazi": "$kazi",
        "elimu": "$elimu",
        "ujuzi": "$ujuzi",
        "mahali_pakazi": "$mahaliPakazi",
        "jumuiya_ushiriki": "$jumuiyaUshiriki",
        "jina_la_jumuiya": "$jinaLaJumuiya",
        "id_ya_jumuiya": "$idYaJumuiya",
        "katibu_jumuiya": "$katibuJumuiya",
        "kama_ushiriki": "$kamaUshiriki",
        "kanisacode": "$kanisaCode",
        "umri": "$umri",
        "reg_year_id": "$krid",
        "tarehe": "$now"
      });

      var jsonResponse = json.decode(response.body);

      if (response.statusCode == 200 && jsonResponse['status'] == '200') {
        Navigator.pop(context);

        if (jsonResponse != null && jsonResponse != 404 && jsonResponse != 500) {
          setState(() {
            // Clear all controllers
            _clearAllControllers();
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
          Fluttertoast.showToast(
            msg: "Umefanikiwa kujisajili kikamilifu",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: MyColors.primaryLight,
            textColor: Colors.white,
          );
        } else if (jsonResponse == 404) {
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: "Server Error",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: MyColors.primaryLight,
            textColor: Colors.white,
          );
        } else if (jsonResponse == 201) {
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: "Ahsante ushajisajili kwa mwaka huu.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: MyColors.primaryLight,
            textColor: Colors.white,
          );
        } else if (jsonResponse == 500) {
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: jsonResponse['message'] ?? "Server Error Please Try Again Later",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: MyColors.primaryLight,
            textColor: Colors.white,
          );
        }
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsonResponse['message'] ?? "Server Error Please Try Again Later",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: MyColors.primaryLight,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "An error occurred: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: MyColors.primaryLight,
        textColor: Colors.white,
      );
    }
  }

  void _clearAllControllers() {
    jinaLaMsharika.clear();
    haliYaNdoa.clear();
    jinaLaMwenziWako.clear();
    nambaYaAhadi.clear();
    ainaYaNdoa.clear();
    jinaMtoto_1.clear();
    tareheMtoto_1.clear();
    uhusianoMtoto_1.clear();
    jinaMtoto_2.clear();
    tareheMtoto_2.clear();
    uhusianoMtoto_2.clear();
    jinaMtoto_3.clear();
    tareheMtoto_3.clear();
    uhusianoMtoto_3.clear();
    nambaYaSimu.clear();
    jengo.clear();
    ahadi.clear();
    kazi.clear();
    elimu.clear();
    ujuzi.clear();
    mahaliPakazi.clear();
    jumuiyaUshiriki.clear();
    jinaLaJumuiya.clear();
    katibuJumuiya.clear();
    kamaUshiriki.clear();
    kanisaCode.clear();
    umri.clear();
  }

  aboutToSendData(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.check_circle_outline, color: MyColors.primaryLight),
              const SizedBox(width: 8),
              const Text("Thibitisha"),
            ],
          ),
          content: const Text(
              "Unakaribia kutuma taarifa zako kwenda usharikani,kagua kisha tuma taarifa zako kwenda usharikani"),
          actions: <Widget>[
            TextButton(
              child: const Text("Funga"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryLight,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Tuma", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                verifyFormAndSubmit();
              },
            )
          ],
        );
      },
    );
  }

  // UI Builder Methods
  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(5, (index) {
              bool isCompleted = pagecontrolnumber >= index;
              bool isCurrent = pagecontrolnumber == index;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index < 4 ? 8 : 0),
                  height: 6,
                  decoration: BoxDecoration(
                    color: isCompleted ? MyColors.primaryLight : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: MyColors.primaryLight.withOpacity(0.4),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hatua ${pagecontrolnumber + 1} ya 5",
                style: TextStyle(
                  color: MyColors.primaryLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                "${((pagecontrolnumber + 1) / 5 * 100).round()}%",
                style: TextStyle(
                  color: MyColors.primaryLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [MyColors.primaryLight, MyColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: MyColors.primaryLight.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
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
                  // ignore: deprecated_member_use
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
            // ignore: deprecated_member_use
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
          ...options
              .map((option) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () => onChanged(option),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: groupValue == option ? MyColors.primaryLight.withOpacity(0.1) : Colors.transparent,
                          border: Border.all(
                            color: groupValue == option ? MyColors.primaryLight : Colors.transparent,
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
                                  color: groupValue == option ? MyColors.primaryLight : Colors.black87,
                                  fontWeight: groupValue == option ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildDependentCard({
    required String title,
    required TextEditingController nameController,
    required TextEditingController dateController,
    required TextEditingController relationController,
    required VoidCallback onDateTap,
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
          Row(
            children: [
              Icon(Icons.person_outline, color: MyColors.primaryLight),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: MyColors.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: nameController,
            labelText: "Jina la $title",
            icon: Icons.person_outline,
            keyboardType: TextInputType.text,
          ),
          _buildTextField(
            controller: dateController,
            labelText: "Tarehe ya kuzaliwa",
            icon: Icons.calendar_today,
            onTap: onDateTap,
            readOnly: true,
          ),
          _buildTextField(
            controller: relationController,
            labelText: "Uhusiano",
            icon: Icons.family_restroom,
            keyboardType: TextInputType.text,
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
                  // ignore: deprecated_member_use
                  color: MyColors.primaryLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.home_work_outlined, color: MyColors.primaryLight, size: 20),
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
                      // ignore: deprecated_member_use
                      color: MyColors.primaryLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.home_work_outlined, color: MyColors.primaryLight, size: 18),
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
              // print("Selected Jumuiya ID: $value");
              idYaJumuiya = value ?? '';
              // // Find jumuiya name for selected id
              final selectedJumuiya =
                  // ignore: unrelated_type_equality_checks
                  _dataProvince!.firstWhere((j) => j.id == value, orElse: () => _dataProvince!.first);

              katibuJumuiya.text = selectedJumuiya.katibuId.toString();
              jinaLaJumuiya.text = selectedJumuiya.jumuiyaName;
            });
          },
        ),
      ),
    );
  }

  // Section Forms
  Widget sectionFormA() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionHeader("A. Taarifa binafsi", Icons.person),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '1. Jina la msharika',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: jinaLaMsharika,
                  labelText: "Jina la msharika (Majina matatu)",
                  icon: Icons.person,
                  keyboardType: TextInputType.text,
                  errorText: msgErrorPhoneNumber3,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '2. Kanisa Code',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: kanisaCode,
                  labelText: "Kanisa Code",
                  icon: Icons.church,
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '3. Umri',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: umri,
                  labelText: "Umri (miaka)",
                  icon: Icons.cake,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            _buildRadioGroup(
              title: '4. Hali ya ndoa',
              options: ['Nimeoa', 'Sijaoa', 'mgane', 'talakiwa'],
              groupValue: _halindoa,
              onChanged: (value) {
                setState(() {
                  _halindoa = value;
                  haliYaNdoa.text = value;
                });
              },
            ),
            _buildRadioGroup(
              title: 'Jinsia yako',
              options: ['Me', 'Ke'],
              groupValue: _jinsiaYako,
              onChanged: (value) {
                setState(() {
                  _jinsiaYako = value;
                  jinsia.text = value;
                });
              },
            ),
            if (_halindoa == 'Nimeoa')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '5. Jina la mwenzi wako',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: jinaLaMwenziWako,
                    labelText: "Jina la mwenzi wako",
                    icon: Icons.favorite,
                    keyboardType: TextInputType.text,
                  ),
                ],
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '6. Namba ya Ahadi',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: nambaYaAhadi,
                  labelText: "Namba ya Ahadi",
                  icon: Icons.event_available,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            if (_halindoa == 'Nimeoa')
              _buildRadioGroup(
                title: '7. Aina ya ndoa',
                options: ['Ndoa ya Kikristo', 'Ndoa isiyo ya Kikristo'],
                groupValue: _ndoa,
                onChanged: (value) {
                  setState(() {
                    _ndoa = value;
                    ainaYaNdoa.text = value;
                  });
                },
              ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '8. Watoto/Waumini wanakutegemea wapya',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Text(
                    '(mfano wasio na bahasha lakini wako kwa uangalizi wako)',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDependentCard(
                    title: 'Mtegemezi wa kwanza',
                    nameController: jinaMtoto_1,
                    dateController: tareheMtoto_1,
                    relationController: uhusianoMtoto_1,
                    onDateTap: () => _tareheMtotoOne(context),
                  ),
                  _buildDependentCard(
                    title: 'Mtegemezi wa pili',
                    nameController: jinaMtoto_2,
                    dateController: tareheMtoto_2,
                    relationController: uhusianoMtoto_2,
                    onDateTap: () => _tareheMtotoTwo(context),
                  ),
                  _buildDependentCard(
                    title: 'Mtegemezi wa tatu',
                    nameController: jinaMtoto_3,
                    dateController: tareheMtoto_3,
                    relationController: uhusianoMtoto_3,
                    onDateTap: () => _tareheMtotoThree(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionFormB() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionHeader("B. Mawasiliano na makazi", Icons.contact_phone),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Namba ya simu',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: nambaYaSimu,
                  labelText: "Namba ya simu (eg. 0659515042 au 0712345678)",
                  icon: Icons.call,
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  errorText: msgErrorPhoneNumber,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionFormC() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionHeader("C. Ahadi yako kwa Bwana", Icons.volunteer_activism),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '1. Jengo Kiasi',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: jengo,
                  labelText: "Jengo kiasi (Tanzanian Shillings)",
                  icon: Icons.home_work,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '2. Ahadi Kiasi',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: ahadi,
                  labelText: "Ahadi kiasi (Tanzanian Shillings)",
                  icon: Icons.monetization_on,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionFormD() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionHeader("D. Services", Icons.work),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '1. Kazi/Shughuli yako (occupation)',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: kazi,
                  labelText: "Kazi yako",
                  icon: Icons.badge,
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '2. Elimu',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: elimu,
                  labelText: "Elimu yako",
                  icon: Icons.school,
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '3. Ujuzi (Profession)',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: ujuzi,
                  labelText: "Ujuzi",
                  icon: Icons.psychology,
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '4. Mahala Pakazi',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: mahaliPakazi,
                  labelText: "Mahala pakazi",
                  icon: Icons.location_city,
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionFormE() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionHeader("E. Ushiriki wa huduma za kanisa na vikundi", Icons.group),
            _buildRadioGroup(
              title: '1. Unashiriki ibada za nyumba kwa nyumba',
              options: ['ndio', 'hapana'],
              groupValue: _ushiriki,
              onChanged: (value) {
                setState(() {
                  _ushiriki = value;
                  jumuiyaUshiriki.text = value;
                });
              },
            ),
            if (_ushiriki == 'ndio') ...[
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
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     const Text(
              //       '3. Katibu wa jumuiya',
              //       style: TextStyle(
              //         fontSize: 16.0,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.black87,
              //       ),
              //     ),
              //     const SizedBox(height: 8),
              //     _buildTextField(
              //       controller: katibuJumuiya,
              //       labelText: "Katibu wa jumuiya",
              //       icon: Icons.person_pin,
              //       readOnly: true,
              //     ),
              //   ],
              // ),
            ] else if (_ushiriki == 'hapana') ...[
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
                  _buildTextField(
                    controller: kamaUshiriki,
                    labelText: "Sababu ya kutokushiriki jumuiya $_ushiriki ${jumuiyaUshiriki.text}",
                    icon: Icons.info_outline,
                    keyboardType: TextInputType.text,
                    // errorText: "Tafadhari weka sababu ya kutokushiriki jumuiya",
                  ),
                ],
              ),
            ],
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [MyColors.primaryLight, MyColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: MyColors.primaryLight.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => aboutToSendData(context),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Tuma taarifa",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: MyColors.primaryLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Fomu ya usajili msharika",
          style: TextStyles.headline(context).copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MyColors.primaryLight,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: <Widget>[
                sectionFormA(),
                sectionFormB(),
                sectionFormC(),
                sectionFormD(),
                sectionFormE(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            pagecontrolnumber == 0
                ? const SizedBox(width: 120)
                : SizedBox(
                    width: 120,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: previousPage,
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      label: const Text(
                        'Nyuma',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
            pagecontrolnumber == 4
                ? const SizedBox(width: 120)
                : SizedBox(
                    width: 120,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: nextPage,
                      icon: const Icon(Icons.arrow_forward, color: Colors.white),
                      label: const Text(
                        'Mbele',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primaryLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void nextPage() async {
    // Validate required fields for step 1 before proceeding
    if (pagecontrolnumber == 0) {
      String jinaLaMsharikaa = jinaLaMsharika.text.trim();
      String kanisaCodea = kanisaCode.text.trim();
      String umria = umri.text.trim();
      String jinsiaa = jinsia.text.trim();
      String nambaYaAhadia = nambaYaAhadi.text.trim();

      final String s = jinaLaMsharika.value.text;
      final List l = s.split(' ');

      if (jinaLaMsharikaa.isEmpty) {
        Alerts.show(context, "Kuna shida", "Tafadhali jaza jina la msharika");
        return;
      } else if (l.length < 3) {
        Alerts.show(context, "Kuna shida", "Tafadhali Hakikisha umeweka majina matatu");
        return;
      } else if (kanisaCodea.isEmpty) {
        Alerts.show(context, "Kuna shida", "Tafadhali jaza kanisa code");
        return;
      } else if (umria.isEmpty) {
        Alerts.show(context, "Kuna shida", "Tafadhali jaza umri wako");
        return;
      } else if (jinsiaa.isEmpty) {
        Alerts.show(context, "Kuna shida", "Tafadhali chagua jinsia yako");
        return;
      } else if (nambaYaAhadia.isEmpty) {
        Alerts.show(context, "Kuna shida", "Tafadhali jaza namba ya ahadi");
        return;
      } else {
        // Validate kanisa code before moving to step 2
        Alerts.showProgressDialog(context, "Tafadhari subiri, tunakagua kanisa code...");

        bool kanisaExists = await validateKanisaCode(kanisaCodea);
        Navigator.pop(context); // Close progress dialog

        if (!kanisaExists) {
          Alerts.show(context, "Kuna shida",
              "Kanisa code '$kanisaCodea' haikupatikana. Tafadhali hakikisha umeweka kanisa code sahihi.");
          return;
        }
      }
    }

    // Validate phone number for step 2 before proceeding
    if (pagecontrolnumber == 1) {
      String nambaYaSimua = nambaYaSimu.text.trim();

      if (nambaYaSimua.isEmpty) {
        Alerts.show(context, "Kuna shida", "Tafadhali jaza namba ya simu");
        return;
      } else if (nambaYaSimua.length != 10) {
        Alerts.show(context, "Kuna shida", "Namba ya simu lazima ziwe tarakimu kumi (10)");
        return;
      } else if (!nambaYaSimua.startsWith("06") && !nambaYaSimua.startsWith("07")) {
        Alerts.show(context, "Kuna shida", "Namba ya simu lazima ianze na 06 au 07");
        return;
      }
    }

    // Validate jengo kiasi and ahadi kiasi for step 3 before proceeding
    if (pagecontrolnumber == 2) {
      String jengoa = jengo.text.trim();
      String ahadia = ahadi.text.trim();

      if (jengoa.isEmpty) {
        Alerts.show(context, "Kuna shida", "Tafadhali jaza jengo kiasi");
        return;
      } else if (ahadia.isEmpty) {
        Alerts.show(context, "Kuna shida", "Tafadhali jaza ahadi kiasi");
        return;
      }
    }

    // Validate work information for step 4 before proceeding
    if (pagecontrolnumber == 3) {
      String kazia = kazi.text.trim();
      String elimua = elimu.text.trim();
      String ujuzia = ujuzi.text.trim();
      String mahaliPakazia = mahaliPakazi.text.trim();

      if (kazia.isEmpty) {
        Alerts.show(context, "Kuna shida", "Tafadhali jaza kazi yako");
        return;
      } else if (elimua.isEmpty) {
        Alerts.show(context, "Kuna shida", "Tafadhali jaza elimu yako");
        return;
      } else if (ujuzia.isEmpty) {
        Alerts.show(context, "Kuna shida", "Tafadhali jaza ujuzi wako");
        return;
      } else if (mahaliPakazia.isEmpty) {
        Alerts.show(context, "Kuna shida", "Tafadhali jaza mahali pa kazi");
        return;
      }
    }

    _pageController.animateToPage(_pageController.page!.toInt() + 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    if (kanisaData != null) {
      getJumuiyaApi();
      getKatibu();
    }
    setState(() {
      pagecontrolnumber = (pagecontrolnumber + 1);
    });
    _animationController.reset();
    _animationController.forward();
  }

  void previousPage() {
    if (kDebugMode) {
      print("${_pageController.page!.toInt()} page id");
    }
    _pageController.animateToPage(_pageController.page!.toInt() - 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    setState(() {
      pagecontrolnumber = pagecontrolnumber - 1;
    });
    _animationController.reset();
    _animationController.forward();
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
