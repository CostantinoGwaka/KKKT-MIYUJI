class MsharikaData {
  final String jinaLaMsharika;
  final String jinsia;
  final String umri;
  final String haliYaNdoa;
  final String jinaLaMwenzi;
  final String nambaYaAhadi;
  final String ainaNdoa;
  final String nambaSimu;
  final String jengo;
  final String ahadi;
  final String kazi;
  final String elimu;
  final String ujuzi;
  final String mahaliPakazi;
  final String jinaLaJumuiya;

  MsharikaData({
    required this.jinaLaMsharika,
    required this.jinsia,
    required this.umri,
    required this.haliYaNdoa,
    required this.jinaLaMwenzi,
    required this.nambaYaAhadi,
    required this.ainaNdoa,
    required this.nambaSimu,
    required this.jengo,
    required this.ahadi,
    required this.kazi,
    required this.elimu,
    required this.ujuzi,
    required this.mahaliPakazi,
    required this.jinaLaJumuiya,
  });

  factory MsharikaData.fromJson(Map<String, dynamic> json) {
    return MsharikaData(
      jinaLaMsharika: json['jina_la_msharika'] ?? '',
      jinsia: json['jinsia'] ?? '',
      umri: json['umri'] ?? '',
      haliYaNdoa: json['hali_ya_ndoa'] ?? '',
      jinaLaMwenzi: json['jina_la_mwenzi_wako'] ?? '',
      nambaYaAhadi: json['namba_ya_ahadi'] ?? '',
      ainaNdoa: json['aina_ya_ndoa'] ?? '',
      nambaSimu: json['namba_ya_simu'] ?? '',
      jengo: json['jengo'] ?? '',
      ahadi: json['ahadi'] ?? '',
      kazi: json['kazi'] ?? '',
      elimu: json['elimu'] ?? '',
      ujuzi: json['ujuzi'] ?? '',
      mahaliPakazi: json['mahali_pakazi'] ?? '',
      jinaLaJumuiya: json['jina_la_jumuiya'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jina_la_msharika': jinaLaMsharika,
      'jinsia': jinsia,
      'umri': umri,
      'hali_ya_ndoa': haliYaNdoa,
      'jina_la_mwenzi_wako': jinaLaMwenzi,
      'namba_ya_ahadi': nambaYaAhadi,
      'aina_ya_ndoa': ainaNdoa,
      'namba_ya_simu': nambaSimu,
      'jengo': jengo,
      'ahadi': ahadi,
      'kazi': kazi,
      'elimu': elimu,
      'ujuzi': ujuzi,
      'mahali_pakazi': mahaliPakazi,
      'jina_la_jumuiya': jinaLaJumuiya,
    };
  }
}
