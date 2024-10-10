// To parse this JSON data, do
//
//     final nenoLaSikuData = nenoLaSikuDataFromJson(jsonString);

import 'dart:convert';

List<NenoLaSikuData> nenoLaSikuDataFromJson(String str) => List<NenoLaSikuData>.from(json.decode(str).map((x) => NenoLaSikuData.fromJson(x)));

String nenoLaSikuDataToJson(List<NenoLaSikuData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NenoLaSikuData {
  NenoLaSikuData({
    this.id,
    this.neno,
    this.tarehe,
  });

  int? id;
  String? neno;
  String? tarehe;

  factory NenoLaSikuData.fromJson(Map<String, dynamic> json) => NenoLaSikuData(id: json["id"], neno: json["neno"], tarehe: json["tarehe"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "neno": neno,
        "tarehe": tarehe,
      };
}
