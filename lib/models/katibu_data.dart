class KatibuData {
  final int id;
  final String jina;
  final String nambaYaSimu;
  final String jumuiya;
  final String jumuiyaId;
  final String mwaka;
  final String status;
  final String tarehe;
  final String memberNo;
  final String kanisaId;

  KatibuData({
    required this.id,
    required this.jina,
    required this.nambaYaSimu,
    required this.jumuiya,
    required this.jumuiyaId,
    required this.mwaka,
    required this.status,
    required this.tarehe,
    required this.memberNo,
    required this.kanisaId,
  });

  factory KatibuData.fromJson(Map<String, dynamic> json) {
    return KatibuData(
      id: json['id'] ?? 0,
      jina: json['jina'] ?? '',
      nambaYaSimu: json['namba_ya_simu'] ?? '',
      jumuiya: json['jumuiya'] ?? '',
      jumuiyaId: json['jumuiya_id'] ?? '',
      mwaka: json['mwaka'] ?? '',
      status: json['status'] ?? '',
      tarehe: json['tarehe'] ?? '',
      memberNo: json['member_no'] ?? '',
      kanisaId: json['kanisa_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jina': jina,
      'namba_ya_simu': nambaYaSimu,
      'jumuiya': jumuiya,
      'jumuiya_id': jumuiyaId,
      'mwaka': mwaka,
      'status': status,
      'tarehe': tarehe,
      'member_no': memberNo,
      'kanisa_id': kanisaId,
    };
  }
}
