class KatibuResponse {
  final String status;
  final List<Katibu> data;

  KatibuResponse({
    required this.status,
    required this.data,
  });

  factory KatibuResponse.fromJson(Map<String, dynamic> json) {
    return KatibuResponse(
      status: json['status'],
      data: (json['data'] as List).map((item) => Katibu.fromJson(item)).toList(),
    );
  }
}

class Katibu {
  final int id;
  final String? jina;
  final String? nambaYaSimu;
  final String? password;
  final String? jumuiya;
  final String? jumuiyaId;
  final String? mwaka;
  final String? status;
  final String? tarehe;
  final String? kanisaId;

  Katibu({
    required this.id,
    required this.jina,
    required this.nambaYaSimu,
    required this.password,
    required this.jumuiya,
    required this.jumuiyaId,
    required this.mwaka,
    required this.status,
    required this.tarehe,
    required this.kanisaId,
  });

  factory Katibu.fromJson(Map<String, dynamic> json) {
    return Katibu(
      id: json['id'],
      jina: json['jina'],
      nambaYaSimu: json['namba_ya_simu'],
      password: json['password'],
      jumuiya: json['jumuiya'],
      jumuiyaId: json['jumuiya_id'],
      mwaka: json['mwaka'],
      status: json['status'],
      tarehe: json['tarehe'],
      kanisaId: json['kanisa_id'],
    );
  }
}
