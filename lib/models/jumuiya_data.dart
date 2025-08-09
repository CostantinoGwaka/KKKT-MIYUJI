class JumuiyaData {
  final String id;
  final String jumuiyaName;
  final String tarehe;
  final String? katibuId;
  final String kanisaId;
  final String? katibuJina;
  final String? katibuSimu;

  JumuiyaData({
    required this.id,
    required this.jumuiyaName,
    required this.tarehe,
    this.katibuId,
    required this.kanisaId,
    this.katibuJina,
    this.katibuSimu,
  });

  factory JumuiyaData.fromJson(Map<String, dynamic> json) {
    return JumuiyaData(
      id: json['id']?.toString() ?? '',
      jumuiyaName: json['jumuiya_name']?.toString() ?? '',
      tarehe: json['tarehe']?.toString() ?? '',
      katibuId: json['katibu_id']?.toString(),
      kanisaId: json['kanisa_id']?.toString() ?? '',
      katibuJina: json['katibu_jina']?.toString(),
      katibuSimu: json['katibu_simu']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jumuiya_name': jumuiyaName,
      'tarehe': tarehe,
      'katibu_id': katibuId,
      'kanisa_id': kanisaId,
      'katibu_jina': katibuJina,
      'katibu_simu': katibuSimu,
    };
  }
}
