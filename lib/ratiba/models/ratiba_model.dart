class RatibaModel {
  final int id;
  final String jina;
  final String muda;
  final String tarehe;
  final String kanisaId;

  RatibaModel({
    required this.id,
    required this.jina,
    required this.muda,
    required this.tarehe,
    required this.kanisaId,
  });

  factory RatibaModel.fromJson(Map<String, dynamic> json) {
    return RatibaModel(
      id: json['id'] ?? '',
      jina: json['jina'] ?? '',
      muda: json['muda'] ?? '',
      tarehe: json['tarehe'] ?? '',
      kanisaId: json['kanisa_id'] ?? '',
    );
  }
}
