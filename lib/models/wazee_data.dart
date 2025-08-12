class WazeeData {
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
  final String memberNo;
  final String kanisaId;

  WazeeData({
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
    required this.memberNo,
    required this.kanisaId,
  });

  factory WazeeData.fromJson(Map<String, dynamic> json) {
    return WazeeData(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] ?? 0,
      jina: json['jina'] ?? '',
      nambaYaSimu: json['namba_ya_simu'] ?? '',
      password: json['password'] ?? '',
      eneo: json['eneo'] ?? '',
      jumuiya: json['jumuiya'] ?? '',
      jumuiyaId: json['jumuiya_id'].toString(),
      mwaka: json['mwaka'] ?? '',
      status: json['status'] ?? '',
      tarehe: json['tarehe'] ?? '',
      memberNo: json['member_no']?.toString() ?? '',
      kanisaId: json['kanisa_id'].toString(),
    );
  }
}
