class MsharikaData {
  final String id;
  final String jinaLaMsharika;
  final String jinsia;
  final String umri;
  final String haliYaNdoa;
  final String jinaLaMwenziWako;
  final String nambaYaAhadi;
  final String ainaNdoa;
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
  final String usharikaStatus;
  final String regYearId;
  final String tarehe;
  final String kanisaId;
  final String password;

  MsharikaData({
    required this.id,
    required this.jinaLaMsharika,
    required this.jinsia,
    required this.umri,
    required this.haliYaNdoa,
    required this.jinaLaMwenziWako,
    required this.nambaYaAhadi,
    required this.ainaNdoa,
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
    required this.usharikaStatus,
    required this.regYearId,
    required this.tarehe,
    required this.kanisaId,
    required this.password,
  });

  factory MsharikaData.fromJson(Map<String, dynamic> json) {
    return MsharikaData(
      id: json['id']?.toString() ?? '',
      jinaLaMsharika: json['jina_la_msharika']?.toString() ?? '',
      jinsia: json['jinsia']?.toString() ?? '',
      umri: json['umri']?.toString() ?? '',
      haliYaNdoa: json['hali_ya_ndoa']?.toString() ?? '',
      jinaLaMwenziWako: json['jina_la_mwenzi_wako']?.toString() ?? '',
      nambaYaAhadi: json['namba_ya_ahadi']?.toString() ?? '',
      ainaNdoa: json['aina_ya_ndoa']?.toString() ?? '',
      jinaMtoto1: json['jina_mtoto_1']?.toString() ?? '',
      tareheMtoto1: json['tarehe_mtoto_1']?.toString() ?? '',
      uhusianoMtoto1: json['uhusiano_mtoto_1']?.toString() ?? '',
      jinaMtoto2: json['jina_mtoto_2']?.toString() ?? '',
      tareheMtoto2: json['tarehe_mtoto_2']?.toString() ?? '',
      uhusianoMtoto2: json['uhusiano_mtoto_2']?.toString() ?? '',
      jinaMtoto3: json['jina_mtoto_3']?.toString() ?? '',
      tareheMtoto3: json['tarehe_mtoto_3']?.toString() ?? '',
      uhusianoMtoto3: json['uhusiano_mtoto_3']?.toString() ?? '',
      nambaYaSimu: json['namba_ya_simu']?.toString() ?? '',
      jengo: json['jengo']?.toString() ?? '',
      ahadi: json['ahadi']?.toString() ?? '',
      kazi: json['kazi']?.toString() ?? '',
      elimu: json['elimu']?.toString() ?? '',
      ujuzi: json['ujuzi']?.toString() ?? '',
      mahaliPakazi: json['mahali_pakazi']?.toString() ?? '',
      jumuiyaUshiriki: json['jumuiya_ushiriki']?.toString() ?? '',
      jinaLaJumuiya: json['jina_la_jumuiya']?.toString() ?? '',
      idYaJumuiya: json['id_ya_jumuiya']?.toString() ?? '',
      katibuJumuiya: json['katibu_jumuiya']?.toString() ?? '',
      kamaUshiriki: json['kama_ushiriki']?.toString() ?? '',
      katibuStatus: json['katibu_status']?.toString() ?? '',
      mzeeStatus: json['mzee_status']?.toString() ?? '',
      usharikaStatus: json['usharika_status']?.toString() ?? '',
      regYearId: json['reg_year_id']?.toString() ?? '',
      tarehe: json['tarehe']?.toString() ?? '',
      kanisaId: json['kanisa_id']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jina_la_msharika': jinaLaMsharika,
      'jinsia': jinsia,
      'umri': umri,
      'hali_ya_ndoa': haliYaNdoa,
      'jina_la_mwenzi_wako': jinaLaMwenziWako,
      'namba_ya_ahadi': nambaYaAhadi,
      'aina_ya_ndoa': ainaNdoa,
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
}
