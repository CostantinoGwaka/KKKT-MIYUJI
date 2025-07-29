import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kanisaapp/models/Jumuiya.dart';
import 'package:kanisaapp/utils/Alerts.dart';
import 'package:kanisaapp/utils/ApiUrl.dart';
import 'package:kanisaapp/utils/TextStyles.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:kanisaapp/utils/spacer.dart';
import 'package:kanisaapp/home/screens/index.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  static const routeName = "/registrationscreen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final PageController _pageController = PageController();
  String _halindoa = '';
  String _jinsiaYako = '';
  String _ndoa = '';
  String _ushiriki = '';
  String idYaJumuiya = '';
  String? msgErrorPhoneNumber;
  String? msgErrorPhoneNumber2;
  String? msgErrorPhoneNumber3;

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

  DateTime? tareheMtotoOne, tareheMtotoTwo, tareheMtotoThree;

  var jumuiyaList = <JumuiyaData>[];
  JumuiyaData? dropdownValue;
  String? _valProvince;
  List<dynamic>? _dataProvince;
  dynamic usajiliId;
  String krid = "";
  List? katibuWaJumuiya;
  int? pagecontrolnumber;

  void getUsajiliId() async {
    String myApi = "${ApiUrl.BASEURL}getusajiliid.php";
    final response = await http.post(
      Uri.parse(myApi),
      headers: {
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        usajiliId = json;

        setState(() {
          krid = usajiliId[0]['year_id'];
        });
      }
    }
  }

  productCountListener() {
    if (kDebugMode) {
      print("value# ${nambaYaSimu.value.text.length} ${nambaYaSimu.value.text.startsWith("0")}");
    }

    //maximum sell
    if (nambaYaSimu.value.text.length != 10 || !nambaYaSimu.value.text.startsWith("0")) {
      setState(() {
        msgErrorPhoneNumber =
            "Tafadhali weka namba ya simu sahihi namba ya simu lazima ianze na sifuri(0) na lazima ziwe tarakimu kumi(10).";
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

    //maximum sell
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
    print("value# ${nambaYaSimu.value.text.length} ${nambaYaSimu.value.text.startsWith("0")}");

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

  void getJumuiyaApi() async {
    String myApi = "${ApiUrl.BASEURL}getjumuiya.php";
    final response = await http.post(
      Uri.parse(myApi),
      headers: {
        'Accept': 'application/json',
      },
    );

    var jumuiya;

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        jumuiya = json;
      }
    }
    setState(() {
      _dataProvince = jumuiya;
    });

    print("dataa# $_dataProvince");
  }

  void getKatibu() async {
    String myApi = "${ApiUrl.BASEURL}getkatibu.php";
    final response = await http.post(
      Uri.parse(myApi),
      headers: {
        'Accept': 'application/json',
      },
    );

    var katibus;

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse != null && jsonResponse != 404) {
        var json = jsonDecode(response.body);
        katibus = json;
      }
    }
    setState(() {
      katibuWaJumuiya = katibus;
    });

    print("dataa# $katibuWaJumuiya");
  }

  //date mtoto one
  _tareheMtotoOne(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: tareheMtotoOne ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2040),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.blueGrey,
              onSurface: Colors.yellow,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.blue[500]),
          ),
          child: child ?? const SizedBox.shrink(), // Handle null child case
        );
      },
    );

    tareheMtotoOne = newSelectedDate;
    tareheMtoto_1
      ..text = DateFormat.yMMMd().format(tareheMtotoOne!)
      ..selection = TextSelection.fromPosition(
        TextPosition(
          offset: tareheMtoto_1.text.length,
          affinity: TextAffinity.upstream,
        ),
      );
  }
  //MTOTO ONE END HERE

  //date mtoto one
  _tareheMtotoTwo(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: tareheMtotoOne ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2040),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.blueGrey,
              onSurface: Colors.yellow,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.blue[500]),
          ),
          child: child ?? const SizedBox.shrink(), // Handle null child case
        );
      },
    );

    tareheMtotoTwo = newSelectedDate;
    tareheMtoto_2
      ..text = DateFormat.yMMMd().format(tareheMtotoTwo!)
      ..selection = TextSelection.fromPosition(
        TextPosition(
          offset: tareheMtoto_2.text.length,
          affinity: TextAffinity.upstream,
        ),
      );
  }
  //MTOTO PILI

  //date mtoto one
  _tareheMtotoThree(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: tareheMtotoThree ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2040),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.blueGrey,
              onSurface: Colors.yellow,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.blue[500]),
          ),
          child: child!,
        );
      },
    );
    tareheMtotoThree = newSelectedDate;
    tareheMtoto_3
      ..text = DateFormat.yMMMd().format(tareheMtotoThree!)
      ..selection = TextSelection.fromPosition(
        TextPosition(
          offset: tareheMtoto_3.text.length,
          affinity: TextAffinity.upstream,
        ),
      );
  }
  //MTOTO TATU

  @override
  void initState() {
    //GET JUMUIYA FOR REGISTRATION
    getJumuiyaApi();
    getUsajiliId();
    getKatibu();
    nambaYaSimu.addListener(productCountListener);
    kamaUshiriki.addListener(productCountListener2);
    jinaLaMsharika.addListener(productCountListenerJina);
    pagecontrolnumber = 0;

    // if (_dataProvince.isEmpty) {

    // } else {
    //   _dataProvince.clear();
    //   getJumuiyaApi();
    // }

    super.initState();
  }

  @override
  void dispose() {
    print("widget is disposed");
    // _dataProvince.clear();
    super.dispose();
  }

  @override
  @protected
  @mustCallSuper
  void deactivate() {
    // _dataProvince.clear();
    super.deactivate();
  }

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
    String krida = krid;

    final String s = jinaLaMsharika.value.text;
    final List l = s.split(' ');

    if (jinaLaMsharikaa == "" ||
        nambaYaSimua == "" ||
        // _jumuiyaUshiriki == "" ||
        ahadia == "" ||
        jengoa == "" ||
        krida == "" ||
        jinsiaa == "") {
      Alerts.show(context, "Kuna shida", "Tafadhali jaza taarifa muhimu(Jina,namba ya simu,ahadi na jengo,jinsia)");
    } else if (nambaYaSimua.length != 10 || !nambaYaSimua.startsWith("0")) {
      Alerts.show(context, "Kuna shida",
          "Tafadhali weka namba ya simu sahihi namba ya simu lazima ianze na sifuri(0) na lazima ziwe tarakimu kumi(10).");
    } else if (((jumuiyaUshirikia != '' && jumuiyaUshirikia == 'ndio') && (jinaLaJumuiya.text.isEmpty)) ||
        katibuJumuiya.text.isEmpty) {
      Alerts.show(
        context,
        "Kuna shida",
        "Umechagua unashiriki jumuiya lakin kuna taarifa ujaziweka kama (jina la jumiya na jina la katibu wa jumiya)",
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
    krid,
  ) async {
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
      "reg_year_id": "$krid",
      "tarehe": "$now"
    });
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      if (jsonResponse != null && jsonResponse != 404 && jsonResponse != 500) {
        // var json = jsonDecode(response.body);
        setState(() {
          //clear controller
          jinaLaMsharika.clear();
          haliYaNdoa.clear();
          jinaLaMwenziWako.clear();
          nambaYaAhadi.clear();
          ainaYaNdoa.clear();
          haliYaNdoa.clear();
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
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        // Alerts.show(context, "Umefanikiwa kujisajili kikamilifu", "Taarifa zimefanikiwa.");
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
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: "Ahsante ushajisajili kwa mwaka huu.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: MyColors.primaryLight,
          textColor: Colors.white,
        );
      } else if (jsonResponse == 500) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: "Server Error Please Try Again Later",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: MyColors.primaryLight,
          textColor: Colors.white,
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Server Error Please Try Again Later",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: MyColors.primaryLight,
        textColor: Colors.white,
      );
    }
    // try {
    //   final response = await http.post(
    //     "${ApiUrl.BASEURL}jisajili.php/",
    //     // headers: {
    //     //   "Content-Type": "application/json",
    //     // },
    //     body: {
    //       "jina_la_msharika": _jinaLaMsharika,
    //       "jinsia": _jinsia,
    //       "hali_ya_ndoa": _haliYaNdoa,
    //       "jina_la_mwenzi_wako": _jinaLaMwenziWako,
    //       "namba_ya_ahadi": _nambaYaAhadi,
    //       "aina_ya_ndoa": _ainaYaNdoa,
    //       "jina_mtoto_1": _jinaMtoto_1,
    //       "tarehe_mtoto_1": _tareheMtoto_1,
    //       "uhusiano_mtoto_1": _uhusianoMtoto_1,
    //       "jina_mtoto_2": _jinaMtoto_2,
    //       "tarehe_mtoto_2": _tareheMtoto_2,
    //       "uhusiano_mtoto_2": _uhusianoMtoto_2,
    //       "jina_mtoto_3": _jinaMtoto_3,
    //       "tarehe_mtoto_3": _tareheMtoto_3,
    //       "uhusiano_mtoto_3": _uhusianoMtoto_3,
    //       "namba_ya_simu": _nambaYaSimu,
    //       "jengo": _jengo,
    //       "ahadi": _ahadi,
    //       "kazi": _kazi,
    //       "elimu": _elimu,
    //       "ujuzi": _ujuzi,
    //       "mahali_pakazi": _mahaliPakazi,
    //       "jumuiya_ushiriki": _jumuiyaUshiriki,
    //       "jina_la_jumuiya": _jinaLaJumuiya,
    //       "id_ya_jumuiya": _idYaJumuiya,
    //       "katibu_jumuiya": _katibuJumuiya,
    //       "kama_ushiriki": _kamaUshiriki,
    //       "reg_year_id": _krid,
    //       "tarehe": "2021-02-20"
    //     },
    //   );
    //   // Map<String, dynamic> res = json.decode(response.body);

    // //   if (response.statusCode == 200) {
    // //     Navigator.of(context).pop();
    // //     print(response.body);
    // //     Map<String, dynamic> res = json.decode(response.body);
    // //     if (res["status"] == "error") {
    // //       Alerts.show(context, "Kuna shida", res["message"]);
    // //     } else {
    //       Alerts.show(context, "Umefanikiwa kujisajili kikamilifu", res["message"]);
    //       //clear controller
    //       jinaLaMsharika.clear();
    //       haliYaNdoa.clear();
    //       jinaLaMwenziWako.clear();
    //       nambaYaAhadi.clear();
    //       ainaYaNdoa.clear();
    //       haliYaNdoa.clear();
    //       jinaMtoto_1.clear();
    //       tareheMtoto_1.clear();
    //       uhusianoMtoto_1.clear();
    //       jinaMtoto_2.clear();
    //       tareheMtoto_2.clear();
    //       uhusianoMtoto_2.clear();
    //       jinaMtoto_3.clear();
    //       tareheMtoto_3.clear();
    //       uhusianoMtoto_3.clear();
    //       nambaYaSimu.clear();
    //       jengo.clear();
    //       ahadi.clear();
    //       kazi.clear();
    //       elimu.clear();
    //       ujuzi.clear();
    //       mahaliPakazi.clear();
    //       jumuiyaUshiriki.clear();
    //       jinaLaJumuiya.clear();
    //       katibuJumuiya.clear();
    //       kamaUshiriki.clear();
    // //     }
    // //     print(res);
    // //   } else {
    // //     print("here reach1 ${response.body}");
    // //   }
    // // } catch (exception) {
    // //   print("here reach 2");
    // //   // Navigator.pop(context);
    // //   // I get no exception here
    // //   print(exception);
    // // }
  }

  aboutToSendData(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Thibitisha"),
          content: const Text(
              "Unakaribia kutuma taarifa zako kwenda usharikani,kagua kisha tuma taarifa zako kwenda usharikani"),
          actions: <Widget>[
            TextButton(
              child: const Text("Funga"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Tuma"),
              onPressed: () {
                Navigator.of(context).pop();
                verifyFormAndSubmit();

                // Navigator.pushNamed(context, LoginScreen.routeName);
              },
            )
          ],
        );
      },
    );
  }

  Widget sectionFormA() {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: const BoxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    height: 20,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: MyColors.primaryLight,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 4.0),
                      child: Text(
                        "A. Taarifa binafsi",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      // key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            '1. Jina la msharika',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: "Jina la msharika",
                            ),
                            keyboardType: TextInputType.text,
                            controller: jinaLaMsharika,
                          ),
                          () {
                            return Text(
                              msgErrorPhoneNumber3!,
                              style: const TextStyle(color: Colors.redAccent),
                            );
                          }(),
                          const SizedBox(
                            height: 2,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                '2. Hali ya ndoa',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              ListTile(
                                title: const Text('Nimeoa'),
                                leading: Radio(
                                  value: "Nimeoa",
                                  groupValue: _halindoa,
                                  onChanged: (value) {
                                    setState(() {
                                      _halindoa = value!;
                                      haliYaNdoa.text = value;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text('Sijaoa'),
                                leading: Radio(
                                  value: "Sijaoa",
                                  groupValue: _halindoa,
                                  onChanged: (value) {
                                    setState(() {
                                      _halindoa = value!;
                                      haliYaNdoa.text = value;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text('Mgane'),
                                leading: Radio(
                                  value: "mgane",
                                  groupValue: _halindoa,
                                  onChanged: (value) {
                                    setState(() {
                                      _halindoa = value!;
                                      haliYaNdoa.text = value;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text('Talakiwa'),
                                leading: Radio(
                                  value: "talakiwa",
                                  groupValue: _halindoa,
                                  onChanged: (value) {
                                    setState(() {
                                      _halindoa = value!;
                                      haliYaNdoa.text = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Jinsia yako',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                ListTile(
                                  title: const Text('Me'),
                                  leading: Radio(
                                    value: "Me",
                                    groupValue: _jinsiaYako,
                                    onChanged: (value) {
                                      setState(() {
                                        _jinsiaYako = value!;
                                        jinsia.text = value;
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: const Text('Ke'),
                                  leading: Radio(
                                    value: "Ke",
                                    groupValue: _jinsiaYako,
                                    onChanged: (value) {
                                      setState(() {
                                        _jinsiaYako = value!;
                                        jinsia.text = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          (_halindoa != '' && _halindoa == 'Nimeoa')
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                      const Text(
                                        '3.Jina la mwenzi wako',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          prefixIcon: Icon(Icons.person),
                                          labelText: "Jina la mwenzi wako",
                                        ),
                                        keyboardType: TextInputType.text,
                                        controller: jinaLaMwenziWako,
                                      ),
                                    ])
                              : const SizedBox.shrink(),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            '4.Namba ya Ahadi',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.event_available),
                              labelText: "Namba ya Ahadi",
                            ),
                            keyboardType: TextInputType.number,
                            controller: nambaYaAhadi,
                          ),
                          (_halindoa != '' && _halindoa == 'Nimeoa')
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      '5. Aina ya ndoa',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text('Ndoa ya Kikristo'),
                                      leading: Radio(
                                        value: "Ndoa ya Kikristo",
                                        groupValue: _ndoa,
                                        onChanged: (value) {
                                          setState(() {
                                            _ndoa = value!;
                                            ainaYaNdoa.text = value;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text('Ndoa isiyo ya Kikristo'),
                                      leading: Radio(
                                        value: "Ndoa isiyo ya Kikristo",
                                        groupValue: _ndoa,
                                        onChanged: (value) {
                                          setState(() {
                                            _ndoa = value!;
                                            ainaYaNdoa.text = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            '6. Watoto/Waumini wanakutegemea wapya(mfano wasio na bahasha lakini wako kwa uangalizi wako)',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Column(
                            children: [
                              Card(
                                elevation: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Mtegemezi wa kwanza',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        labelText: "Jina la Mtegemezi wa kwanza",
                                      ),
                                      keyboardType: TextInputType.text,
                                      controller: jinaMtoto_1,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.date_range),
                                        labelText: "Tarehe ya kuzaliwa Mtegemezi wa kwanza",
                                      ),
                                      focusNode: AlwaysDisabledFocusNode(),
                                      keyboardType: TextInputType.datetime,
                                      controller: tareheMtoto_1,
                                      onTap: () {
                                        _tareheMtotoOne(context);
                                      },
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.connect_without_contact),
                                        labelText: "Uhusiano Mtegemezi wa kwanza",
                                      ),
                                      keyboardType: TextInputType.text,
                                      controller: uhusianoMtoto_1,
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                elevation: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Mtegemezi wa pili',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        labelText: "Jina la Mtegemezi wa pili",
                                      ),
                                      keyboardType: TextInputType.text,
                                      controller: jinaMtoto_2,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.date_range),
                                        labelText: "Tarehe ya kuzaliwa Mtegemezi wa pili",
                                      ),
                                      keyboardType: TextInputType.datetime,
                                      controller: tareheMtoto_2,
                                      onTap: () {
                                        _tareheMtotoTwo(context);
                                      },
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.connect_without_contact),
                                        labelText: "Uhusiano Mtegemezi wa pili",
                                      ),
                                      keyboardType: TextInputType.text,
                                      controller: uhusianoMtoto_2,
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                elevation: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Mtegemezi wa tatu',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        labelText: "Jina la Mtegemezi wa tatu",
                                      ),
                                      keyboardType: TextInputType.text,
                                      controller: jinaMtoto_3,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.date_range),
                                        labelText: "Tarehe ya kuzaliwa Mtegemezi wa tatu",
                                      ),
                                      keyboardType: TextInputType.datetime,
                                      controller: tareheMtoto_3,
                                      onTap: () {
                                        _tareheMtotoThree(context);
                                      },
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.connect_without_contact),
                                        labelText: "Uhusiano Mtegemezi wa tatu",
                                      ),
                                      keyboardType: TextInputType.text,
                                      controller: uhusianoMtoto_3,
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
    );
  }

  Widget sectionFormB() {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: const BoxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    height: 20,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: MyColors.primaryLight,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 4.0),
                      child: Text(
                        "B. Mawasiliano na makazi",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      // key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            'Namba ya simu',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.call),
                              labelText: "Namba ya simu (eg. 0659515042)",
                            ),
                            keyboardType: TextInputType.number,
                            controller: nambaYaSimu,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                            ],
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          () {
                            return Text(
                              msgErrorPhoneNumber!,
                              style: const TextStyle(color: Colors.redAccent),
                            );
                          }(),
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
    );
  }

  Widget sectionFormC() {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: const BoxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    height: 20,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: MyColors.primaryLight,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 4.0),
                      child: Text(
                        "C. Ahadi yako kwa Bwana",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      // key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            '1. Jengo Kiasi',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.money),
                              labelText: "Jengo kiasi",
                            ),
                            keyboardType: TextInputType.number,
                            controller: jengo,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            '2. Ahadi Kiasi',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.money),
                              labelText: "Ahadi kiasi",
                            ),
                            keyboardType: TextInputType.number,
                            controller: ahadi,
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
    );
  }

  Widget sectionFormD() {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: const BoxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    height: 20,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: MyColors.primaryLight,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 4.0),
                      child: Text(
                        "D. Services",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      // key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            '1. Kazi/Shughuli yako(occupation)',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.badge),
                              labelText: "Kazi yako",
                            ),
                            keyboardType: TextInputType.text,
                            controller: kazi,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            '2. Elimu',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.history_edu),
                              labelText: "Elimu yako",
                            ),
                            keyboardType: TextInputType.text,
                            controller: elimu,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            '3. Ujuzi(Profession)',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.work),
                              labelText: "ujuzi",
                            ),
                            keyboardType: TextInputType.text,
                            controller: ujuzi,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            '4. Mahala Pakazi',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.location_city_sharp),
                              labelText: "mahala pakazi",
                            ),
                            keyboardType: TextInputType.text,
                            controller: mahaliPakazi,
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
    );
  }

  Widget sectionFormE() {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: const BoxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    height: 20,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: MyColors.primaryLight,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 4.0),
                      child: Text(
                        "E. Ushiriki wa huduma za kanisa na vikundi",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      // key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            '1. Unashiriki ibada za nyumba kwa nyumba',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          ListTile(
                            title: const Text('Ndio'),
                            leading: Radio(
                              value: "ndio",
                              groupValue: _ushiriki,
                              onChanged: (value) {
                                setState(() {
                                  _ushiriki = value!;
                                  jumuiyaUshiriki.text = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Hapana'),
                            leading: Radio(
                              value: "hapana",
                              groupValue: _ushiriki,
                              onChanged: (value) {
                                setState(() {
                                  _ushiriki = value!;
                                  jumuiyaUshiriki.text = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          (_ushiriki != '' && _ushiriki == 'ndio')
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '2. Jina la jumuiya',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    _dataProvince == null
                                        ? const SizedBox()
                                        : Padding(
                                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: DropdownButton(
                                                hint: const Text("Chagua Jumuiya yako"),
                                                value: _valProvince,
                                                items: _dataProvince!.map((item) {
                                                  return DropdownMenuItem(
                                                    value: item['jumuiya_name'],
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.home_work_outlined,
                                                          color: MyColors.primaryLight,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          item['jumuiya_name'],
                                                          style: TextStyle(
                                                            color: MyColors.primaryLight,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ), //{"id": item['id'].toString(), "jina": item['jumuiya_name'].toString()},
                                                  );
                                                }).toList(),
                                                onChanged: (value) async {
                                                  setState(() {
                                                    // idYaJumuiya = item['jumuiya_name'];
                                                    for (var items in katibuWaJumuiya!) {
                                                      if (items['jumuiya'] == value) {
                                                        katibuJumuiya.text = items['jina'];
                                                      }
                                                    }

                                                    _valProvince = value.toString();
                                                    jinaLaJumuiya.text = value.toString();
                                                    idYaJumuiya = value.toString();
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      '3. Katibu wa jumuiya',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        labelText: "katibu wa jumiya",
                                      ),
                                      keyboardType: TextInputType.text,
                                      controller: katibuJumuiya,
                                      enableInteractiveSelection: false, // will disable paste operation
                                      focusNode: AlwaysDisabledFocusNode(),
                                    ),
                                  ],
                                )
                              : (_ushiriki != '' && _ushiriki == 'hapana')
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Text(
                                          '4. Kama Haushiriki weka sababu ya kutokushiriki',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            prefixIcon: Icon(Icons.info),
                                            labelText: "sababu ya kutokushiriki jumuiya",
                                          ),
                                          keyboardType: TextInputType.text,
                                          controller: kamaUshiriki,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(10),
                                          ],
                                        ),
                                        () {
                                          return Text(
                                            msgErrorPhoneNumber2!,
                                            style: const TextStyle(color: Colors.redAccent),
                                          );
                                        }(),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: MyColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        aboutToSendData(context);
                      },
                      child: const Text(
                        "Tuma taarifa",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        middle: Text(
          "Fomu ya usajili msharika",
          style: TextStyles.headline(context).copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MyColors.primaryLight,
          ),
        ),
      ),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: deviceHeight(context) * .10),
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              pagecontrolnumber == 0
                  ? const SizedBox()
                  : ElevatedButton(
                      onPressed: previousPage,
                      // color: MyColors.primaryLight,
                      child: const Text(
                        'nyuma',
                        style: TextStyle(color: Colors.white),
                      ),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(10),
                      // ),
                    ),
              pagecontrolnumber == 4
                  ? const SizedBox()
                  : ElevatedButton(
                      onPressed: nextPage,
                      // color: MyColors.primaryLight,
                      child: const Text(
                        'mbele',
                        style: TextStyle(color: Colors.white),
                      ),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(10),
                      // ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  void nextPage() {
    _pageController.animateToPage(_pageController.page!.toInt() + 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
    setState(() {
      getJumuiyaApi();
      getUsajiliId();
      getKatibu();
      pagecontrolnumber = (pagecontrolnumber! + 1);
    });
  }

  void previousPage() {
    if (kDebugMode) {
      print("${_pageController.page!.toInt()} page id");
    }
    _pageController.animateToPage(_pageController.page!.toInt() - 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
    setState(() {
      pagecontrolnumber = pagecontrolnumber! - 1;
    });
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
