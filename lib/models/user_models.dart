// Base user model
// ignore_for_file: use_super_parameters

abstract class BaseUser {
  final String memberNo;
  final String kanisaId;
  final String kanisaName;
  final String userType;

  BaseUser({
    required this.memberNo,
    required this.kanisaId,
    required this.kanisaName,
    required this.userType,
  });

  Map<String, dynamic> toJson();
}

// Admin model
class AdminUser extends BaseUser {
  final int id;
  final String phonenumber;
  final String email;
  final String password;
  final String level;
  final int status;
  final String fullName;

  AdminUser({
    required this.id,
    required this.phonenumber,
    required this.email,
    required this.password,
    required this.level,
    required this.status,
    required this.fullName,
    required String memberNo,
    required String kanisaId,
    required String kanisaName,
  }) : super(
          memberNo: memberNo,
          kanisaId: kanisaId,
          kanisaName: kanisaName,
          userType: 'ADMIN',
        );

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'],
      phonenumber: json['phonenumber'],
      email: json['email'],
      password: json['password'],
      level: json['level'],
      status: json['status'],
      fullName: json['full_name'],
      memberNo: json['member_no'],
      kanisaId: json['kanisa_id'],
      kanisaName: json['kanisa_name'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phonenumber': phonenumber,
      'email': email,
      'password': password,
      'level': level,
      'status': status,
      'full_name': fullName,
      'member_no': memberNo,
      'kanisa_id': kanisaId,
      'kanisa_name': kanisaName,
      'user_type': userType,
    };
  }
}

// Mzee model
class MzeeUser extends BaseUser {
  final int id;
  final String jina;
  final String nambaYaSimu;
  final String password;
  final String eneo;
  final String jumuiya;
  final String jumuiyaId;
  final String mwaka;
  final String status;
  final String tarehe;

  MzeeUser({
    required this.id,
    required this.jina,
    required this.nambaYaSimu,
    required this.password,
    required this.eneo,
    required this.jumuiya,
    required this.jumuiyaId,
    required this.mwaka,
    required this.status,
    required this.tarehe,
    required String memberNo,
    required String kanisaId,
    required String kanisaName,
  }) : super(
          memberNo: memberNo,
          kanisaId: kanisaId,
          kanisaName: kanisaName,
          userType: 'MZEE',
        );

  factory MzeeUser.fromJson(Map<String, dynamic> json) {
    return MzeeUser(
      id: json['id'],
      jina: json['jina'],
      nambaYaSimu: json['namba_ya_simu'],
      password: json['password'],
      eneo: json['eneo'],
      jumuiya: json['jumuiya'],
      jumuiyaId: json['jumuiya_id'],
      mwaka: json['mwaka'],
      status: json['status'],
      tarehe: json['tarehe'],
      memberNo: json['member_no'],
      kanisaId: json['kanisa_id'],
      kanisaName: json['kanisa_name'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jina': jina,
      'namba_ya_simu': nambaYaSimu,
      'password': password,
      'eneo': eneo,
      'jumuiya': jumuiya,
      'jumuiya_id': jumuiyaId,
      'mwaka': mwaka,
      'status': status,
      'tarehe': tarehe,
      'member_no': memberNo,
      'kanisa_id': kanisaId,
      'kanisa_name': kanisaName,
      'user_type': userType,
    };
  }
}

// Katibu model
class KatibuUser extends BaseUser {
  final int id;
  final String jina;
  final String nambaYaSimu;
  final String password;
  final String jumuiya;
  final String jumuiyaId;
  final String mwaka;
  final String status;
  final String tarehe;

  KatibuUser({
    required this.id,
    required this.jina,
    required this.nambaYaSimu,
    required this.password,
    required this.jumuiya,
    required this.jumuiyaId,
    required this.mwaka,
    required this.status,
    required this.tarehe,
    required String memberNo,
    required String kanisaId,
    required String kanisaName,
  }) : super(
          memberNo: memberNo,
          kanisaId: kanisaId,
          kanisaName: kanisaName,
          userType: 'KATIBU',
        );

  factory KatibuUser.fromJson(Map<String, dynamic> json) {
    return KatibuUser(
      id: json['id'],
      jina: json['jina'],
      nambaYaSimu: json['namba_ya_simu'],
      password: json['password'],
      jumuiya: json['jumuiya'],
      jumuiyaId: json['jumuiya_id'],
      mwaka: json['mwaka'],
      status: json['status'],
      tarehe: json['tarehe'],
      memberNo: json['member_no'],
      kanisaId: json['kanisa_id'],
      kanisaName: json['kanisa_name'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jina': jina,
      'namba_ya_simu': nambaYaSimu,
      'password': password,
      'jumuiya': jumuiya,
      'jumuiya_id': jumuiyaId,
      'mwaka': mwaka,
      'status': status,
      'tarehe': tarehe,
      'member_no': memberNo,
      'kanisa_id': kanisaId,
      'kanisa_name': kanisaName,
      'user_type': userType,
    };
  }
}

// Msharika model
class MsharikaUser extends BaseUser {
  final int id;
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
  final String? katibuStatus;
  final String? mzeeStatus;
  final String ussharikaStatus;
  final String regYearId;
  final String tarehe;
  final String password;

  MsharikaUser({
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
    this.katibuStatus,
    this.mzeeStatus,
    required this.ussharikaStatus,
    required this.regYearId,
    required this.tarehe,
    required this.password,
    required String memberNo,
    required String kanisaId,
    required String kanisaName,
  }) : super(
          memberNo: memberNo,
          kanisaId: kanisaId,
          kanisaName: kanisaName,
          userType: 'MSHARIKA',
        );

  factory MsharikaUser.fromJson(Map<String, dynamic> json) {
    return MsharikaUser(
      id: json['id'],
      jinaLaMsharika: json['jina_la_msharika'],
      jinsia: json['jinsia'],
      umri: json['umri'],
      haliYaNdoa: json['hali_ya_ndoa'],
      jinaLaMwenziWako: json['jina_la_mwenzi_wako'],
      nambaYaAhadi: json['namba_ya_ahadi'],
      ainaYaNdoa: json['aina_ya_ndoa'],
      jinaMtoto1: json['jina_mtoto_1'],
      tareheMtoto1: json['tarehe_mtoto_1'],
      uhusianoMtoto1: json['uhusiano_mtoto_1'],
      jinaMtoto2: json['jina_mtoto_2'],
      tareheMtoto2: json['tarehe_mtoto_2'],
      uhusianoMtoto2: json['uhusiano_mtoto_2'],
      jinaMtoto3: json['jina_mtoto_3'],
      tareheMtoto3: json['tarehe_mtoto_3'],
      uhusianoMtoto3: json['uhusiano_mtoto_3'],
      nambaYaSimu: json['namba_ya_simu'],
      jengo: json['jengo'],
      ahadi: json['ahadi'],
      kazi: json['kazi'],
      elimu: json['elimu'],
      ujuzi: json['ujuzi'],
      mahaliPakazi: json['mahali_pakazi'],
      jumuiyaUshiriki: json['jumuiya_ushiriki'],
      jinaLaJumuiya: json['jina_la_jumuiya'],
      idYaJumuiya: json['id_ya_jumuiya'],
      katibuJumuiya: json['katibu_jumuiya'],
      kamaUshiriki: json['kama_ushiriki'],
      katibuStatus: json['katibu_status'],
      mzeeStatus: json['mzee_status'],
      ussharikaStatus: json['usharika_status'],
      regYearId: json['reg_year_id'],
      tarehe: json['tarehe'],
      password: json['password'],
      memberNo: json['member_no'] ?? json['namba_ya_ahadi'], // fallback to namba_ya_ahadi if member_no is not present
      kanisaId: json['kanisa_id'],
      kanisaName: json['kanisa_name'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
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
      'usharika_status': ussharikaStatus,
      'reg_year_id': regYearId,
      'tarehe': tarehe,
      'password': password,
      'member_no': memberNo,
      'kanisa_id': kanisaId,
      'kanisa_name': kanisaName,
      'user_type': userType,
    };
  }
}

// Login response model
class LoginResponse {
  final int status;
  final String message;
  final BaseUser? user;

  LoginResponse({
    required this.status,
    required this.message,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    BaseUser? user;

    if (json['data'] != null) {
      final userData = json['data'];
      final userType = userData['user_type'];

      switch (userType) {
        case 'ADMIN':
          user = AdminUser.fromJson(userData);
          break;
        case 'MZEE':
          user = MzeeUser.fromJson(userData);
          break;
        case 'KATIBU':
          user = KatibuUser.fromJson(userData);
          break;
        case 'MSHARIKA':
          user = MsharikaUser.fromJson(userData);
          break;
      }
    }

    return LoginResponse(
      status: json['status'],
      message: json['message'],
      user: user,
    );
  }
}
