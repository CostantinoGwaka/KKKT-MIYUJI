class KamatiData {
  int? id;
  String? jinaKamati;
  String? tarehe;
  String? kanisaId;

  KamatiData({
    this.id,
    this.jinaKamati,
    this.tarehe,
    this.kanisaId,
  });

  KamatiData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jinaKamati = json['jina_kamati'];
    tarehe = json['tarehe'];
    kanisaId = json['kanisa_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['jina_kamati'] = jinaKamati;
    data['tarehe'] = tarehe;
    data['kanisa_id'] = kanisaId;
    return data;
  }
}
