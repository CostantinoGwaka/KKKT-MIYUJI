class JumuiyaResponse {
  final int status;
  final String message;
  final List<Jumuiya> data;

  JumuiyaResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory JumuiyaResponse.fromJson(Map<String, dynamic> json) {
    return JumuiyaResponse(
      status: json['status'],
      message: json['message'],
      data: List<Jumuiya>.from(json['data'].map((x) => Jumuiya.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class Jumuiya {
  final int id;
  final String jumuiyaName;
  final String tarehe;
  final int kanisaId;
  final String? katibuId;

  Jumuiya({
    required this.id,
    required this.jumuiyaName,
    required this.tarehe,
    required this.kanisaId,
    required this.katibuId,
  });

  factory Jumuiya.fromJson(Map<String, dynamic> json) {
    return Jumuiya(
      id: json['id'],
      jumuiyaName: json['jumuiya_name'],
      tarehe: json['tarehe'],
      kanisaId: int.parse(json['kanisa_id'].toString()),
      katibuId: json['katibu_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jumuiya_name': jumuiyaName,
      'tarehe': tarehe,
      'kanisa_id': kanisaId,
      'katibu_id': katibuId,
    };
  }
}
