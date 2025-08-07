class AkauntiModel {
  final String id;
  final String jina;
  final String namba;
  final String tarehe;
  final String kanisaId;

  AkauntiModel({
    required this.id,
    required this.jina,
    required this.namba,
    required this.tarehe,
    required this.kanisaId,
  });

  factory AkauntiModel.fromJson(Map<String, dynamic> json) {
    return AkauntiModel(
      id: json['id'].toString(),
      jina: json['jina'].toString(),
      namba: json['namba'].toString(),
      tarehe: json['tarehe'].toString(),
      kanisaId: json['kanisa_id'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jina': jina,
      'namba': namba,
      'tarehe': tarehe,
      'kanisa_id': kanisaId,
    };
  }
}
