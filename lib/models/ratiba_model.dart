class RatibaResponse {
  final String status;
  final String message;
  final List<Ratiba> data;

  RatibaResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RatibaResponse.fromJson(Map<String, dynamic> json) {
    return RatibaResponse(
      status: json['status'],
      message: json['message'],
      data: List<Ratiba>.from(json['data'].map((item) => Ratiba.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}


class Ratiba {
  final int id;
  final String jina;
  final String muda;
  final String tarehe;
  final String kanisaId;

  Ratiba({
    required this.id,
    required this.jina,
    required this.muda,
    required this.tarehe,
    required this.kanisaId,
  });

  factory Ratiba.fromJson(Map<String, dynamic> json) {
    return Ratiba(
      id: json['id'],
      jina: json['jina'],
      muda: json['muda'],
      tarehe: json['tarehe'],
      kanisaId: json['kanisa_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jina': jina,
      'muda': muda,
      'tarehe': tarehe,
      'kanisa_id': kanisaId,
    };
  }
}

