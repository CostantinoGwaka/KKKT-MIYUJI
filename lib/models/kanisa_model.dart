class Kanisa {
  final int id;
  final String jina;
  final String nambasimu;
  final String kanisacode;
  final String tarehe;

  Kanisa({
    required this.id,
    required this.jina,
    required this.nambasimu,
    required this.kanisacode,
    required this.tarehe,
  });

  factory Kanisa.fromJson(Map<String, dynamic> json) {
    return Kanisa(
      id: json['id'],
      jina: json['jina'],
      nambasimu: json['nambasimu'],
      kanisacode: json['kanisacode'],
      tarehe: json['tarehe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jina': jina,
      'nambasimu': nambasimu,
      'kanisacode': kanisacode,
      'tarehe': tarehe,
    };
  }
}

class KanisaResponse {
  final String status;
  final String message;
  final Kanisa? data;

  KanisaResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory KanisaResponse.fromJson(Map<String, dynamic> json) {
    return KanisaResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? Kanisa.fromJson(json['data']) : null,
    );
  }
}
