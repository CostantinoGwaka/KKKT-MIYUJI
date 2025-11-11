class LoginResponse {
  final int status;
  final String message;
  final BaseUser? data;

  LoginResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? BaseUser.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class BaseUser {
  final dynamic id;
  final dynamic jina;
  final dynamic nambaYaSimu;
  final dynamic password;
  final dynamic phonenumber;
  final dynamic email;
  final dynamic level;
  final dynamic fullName;
  final dynamic eneo;
  final dynamic jumuiya;
  final dynamic jumuiyaId;
  final dynamic mwaka;
  final dynamic status;
  final dynamic tarehe;
  final dynamic memberNo;
  final dynamic kanisaId;
  final dynamic kanisaName;
  final List<MsharikaRecord> msharikaRecords;
  final dynamic userType;

  BaseUser({
    required this.id,
    required this.jina,
    required this.nambaYaSimu,
    required this.password,
    required this.jumuiya,
    required this.jumuiyaId,
    this.phonenumber,
    this.email,
    this.level,
    this.fullName,
    this.eneo,
    required this.mwaka,
    required this.status,
    required this.tarehe,
    required this.memberNo,
    required this.kanisaId,
    required this.kanisaName,
    required this.msharikaRecords,
    required this.userType,
  });

  factory BaseUser.fromJson(Map<String, dynamic> json) {
    var list = json['msharika_records'] as List? ?? [];
    List<MsharikaRecord> msharikaList =
        list.map((e) => MsharikaRecord.fromJson(e)).toList();

    return BaseUser(
      id: json['id'] ?? 0,
      jina: json['jina'] ?? '',
      nambaYaSimu: json['namba_ya_simu'] ?? '',
      password: json['password'] ?? '',
      jumuiya: json['jumuiya'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      eneo: json['eneo'] ?? '',
      jumuiyaId: json['jumuiya_id'] ?? 0,
      mwaka: json['mwaka'] ?? '',
      status: json['status'] ?? 0,
      tarehe: json['tarehe'] ?? '',
      memberNo: json['member_no'] ?? 0,
      kanisaId: json['kanisa_id'] ?? 0,
      kanisaName: json['kanisa_name'] ?? '',
      msharikaRecords: msharikaList,
      userType: json['user_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'jina': jina,
        'namba_ya_simu': nambaYaSimu,
        'password': password,
        'jumuiya': jumuiya,
        'jumuiya_id': jumuiyaId,
        'mwaka': mwaka,
        'status': status,
        'tarehe': tarehe,
        'phonenumber': phonenumber,
        'email': email,
        'full_name': fullName,
        'eneo': eneo,
        'member_no': memberNo,
        'kanisa_id': kanisaId,
        'kanisa_name': kanisaName,
        'msharika_records': msharikaRecords.map((e) => e.toJson()).toList(),
        'user_type': userType,
      };
}

class MsharikaRecord {
  final dynamic id;
  final String jinaLaMsharika;
  final String jinsia;
  final String umri;
  final String haliYaNdoa;
  final String jinaLaMwenziWako;
  final String nambaYaAhadi;
  final String ainaYaNdoa;
  final String jinaMtoto1;
  final String tareheMtoto1;
  final String uhusianoMtoto1;
  final String jinaMtoto2;
  final String tareheMtoto2;
  final String uhusianoMtoto2;
  final String jinaMtoto3;
  final String tareheMtoto3;
  final String uhusianoMtoto3;
  final String nambaYaSimu;
  final String jengo;
  final String ahadi;
  final String kazi;
  final String elimu;
  final String ujuzi;
  final String mahaliPakazi;
  final String jumuiyaUshiriki;
  final String jinaLaJumuiya;
  final String idYaJumuiya;
  final String katibuJumuiya;
  final String kamaUshiriki;
  final String katibuStatus;
  final String mzeeStatus;
  final String? usharikaStatus;
  final String regYearId;
  final String tarehe;
  final String kanisaId;
  final String? password;

  MsharikaRecord({
    required this.id,
    required this.jinaLaMsharika,
    required this.jinsia,
    required this.umri,
    required this.haliYaNdoa,
    required this.jinaLaMwenziWako,
    required this.nambaYaAhadi,
    required this.ainaYaNdoa,
    required this.jinaMtoto1,
    required this.tareheMtoto1,
    required this.uhusianoMtoto1,
    required this.jinaMtoto2,
    required this.tareheMtoto2,
    required this.uhusianoMtoto2,
    required this.jinaMtoto3,
    required this.tareheMtoto3,
    required this.uhusianoMtoto3,
    required this.nambaYaSimu,
    required this.jengo,
    required this.ahadi,
    required this.kazi,
    required this.elimu,
    required this.ujuzi,
    required this.mahaliPakazi,
    required this.jumuiyaUshiriki,
    required this.jinaLaJumuiya,
    required this.idYaJumuiya,
    required this.katibuJumuiya,
    required this.kamaUshiriki,
    required this.katibuStatus,
    required this.mzeeStatus,
    this.usharikaStatus,
    required this.regYearId,
    required this.tarehe,
    required this.kanisaId,
    this.password,
  });

  factory MsharikaRecord.fromJson(Map<String, dynamic> json) {
    return MsharikaRecord(
      id: json['id'] ?? 0,
      jinaLaMsharika: json['jina_la_msharika'] ?? '',
      jinsia: json['jinsia'] ?? '',
      umri: json['umri'] ?? '',
      haliYaNdoa: json['hali_ya_ndoa'] ?? '',
      jinaLaMwenziWako: json['jina_la_mwenzi_wako'] ?? '',
      nambaYaAhadi: json['namba_ya_ahadi'] ?? '',
      ainaYaNdoa: json['aina_ya_ndoa'] ?? '',
      jinaMtoto1: json['jina_mtoto_1'] ?? '',
      tareheMtoto1: json['tarehe_mtoto_1'] ?? '',
      uhusianoMtoto1: json['uhusiano_mtoto_1'] ?? '',
      jinaMtoto2: json['jina_mtoto_2'] ?? '',
      tareheMtoto2: json['tarehe_mtoto_2'] ?? '',
      uhusianoMtoto2: json['uhusiano_mtoto_2'] ?? '',
      jinaMtoto3: json['jina_mtoto_3'] ?? '',
      tareheMtoto3: json['tarehe_mtoto_3'] ?? '',
      uhusianoMtoto3: json['uhusiano_mtoto_3'] ?? '',
      nambaYaSimu: json['namba_ya_simu'] ?? '',
      jengo: json['jengo'] ?? '',
      ahadi: json['ahadi'] ?? '',
      kazi: json['kazi'] ?? '',
      elimu: json['elimu'] ?? '',
      ujuzi: json['ujuzi'] ?? '',
      mahaliPakazi: json['mahali_pakazi'] ?? '',
      jumuiyaUshiriki: json['jumuiya_ushiriki'] ?? '',
      jinaLaJumuiya: json['jina_la_jumuiya'] ?? '',
      idYaJumuiya: json['id_ya_jumuiya'] ?? '',
      katibuJumuiya: json['katibu_jumuiya'] ?? '',
      kamaUshiriki: json['kama_ushiriki'] ?? '',
      katibuStatus: json['katibu_status'] ?? '',
      mzeeStatus: json['mzee_status'] ?? '',
      usharikaStatus: json['usharika_status'],
      regYearId: json['reg_year_id'] ?? '',
      tarehe: json['tarehe'] ?? '',
      kanisaId: json['kanisa_id'] ?? '',
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'jina_la_msharika': jinaLaMsharika,
        'jinsia': jinsia,
        'umri': umri,
        'hali_ya_ndoa': haliYaNdoa,
        'jina_la_mwenzi_wako': jinaLaMwenziWako,
        'namba_ya_ahadi': nambaYaAhadi,
        'aina_ya_ndoa': ainaYaNdoa,
        'jina_mtoto_1': jinaMtoto1,
        'tarehe_mtoto_1': tareheMtoto1,
        'uhusiano_mtoto_1': uhusianoMtoto1,
        'jina_mtoto_2': jinaMtoto2,
        'tarehe_mtoto_2': tareheMtoto2,
        'uhusiano_mtoto_2': uhusianoMtoto2,
        'jina_mtoto_3': jinaMtoto3,
        'tarehe_mtoto_3': tareheMtoto3,
        'uhusiano_mtoto_3': uhusianoMtoto3,
        'namba_ya_simu': nambaYaSimu,
        'jengo': jengo,
        'ahadi': ahadi,
        'kazi': kazi,
        'elimu': elimu,
        'ujuzi': ujuzi,
        'mahali_pakazi': mahaliPakazi,
        'jumuiya_ushiriki': jumuiyaUshiriki,
        'jina_la_jumuiya': jinaLaJumuiya,
        'id_ya_jumuiya': idYaJumuiya,
        'katibu_jumuiya': katibuJumuiya,
        'kama_ushiriki': kamaUshiriki,
        'katibu_status': katibuStatus,
        'mzee_status': mzeeStatus,
        'usharika_status': usharikaStatus,
        'reg_year_id': regYearId,
        'tarehe': tarehe,
        'kanisa_id': kanisaId,
        'password': password,
      };
}
