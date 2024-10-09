// To parse this JSON data, do
//
//     final ibadaRatiba = ibadaRatibaFromJson(jsonString);

import 'dart:convert';

List<IbadaRatiba> ibadaRatibaFromJson(String str) => List<IbadaRatiba>.from(json.decode(str).map((x) => IbadaRatiba.fromJson(x)));

String ibadaRatibaToJson(List<IbadaRatiba> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IbadaRatiba {
  IbadaRatiba({
    this.id,
    this.jina,
    this.muda,
    this.tarehe,
  });

  String? id;
  String? jina;
  String? muda;
  DateTime? tarehe;

  factory IbadaRatiba.fromJson(Map<String, dynamic> json) => IbadaRatiba(
        id: json["id"],
        jina: json["jina"],
        muda: json["muda"],
        tarehe: DateTime.parse(json["tarehe"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "jina": jina,
        "muda": muda,
        "tarehe": "${tarehe!.year.toString().padLeft(4, '0')}-${tarehe!.month.toString().padLeft(2, '0')}-${tarehe!.day.toString().padLeft(2, '0')}",
      };
}
