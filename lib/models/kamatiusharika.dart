// To parse this JSON data, do
//
//     final kamatiUsharika = kamatiUsharikaFromJson(jsonString);

import 'dart:convert';

List<KamatiUsharika> kamatiUsharikaFromJson(String str) =>
    List<KamatiUsharika>.from(json.decode(str).map((x) => KamatiUsharika.fromJson(x)));

String kamatiUsharikaToJson(List<KamatiUsharika> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KamatiUsharika {
  KamatiUsharika({
    this.id,
    this.jinaKamati,
    this.tarehe,
  });

  String id;
  String jinaKamati;
  String tarehe;

  factory KamatiUsharika.fromJson(Map<String, dynamic> json) => KamatiUsharika(
        id: json["id"],
        jinaKamati: json["jina_kamati"],
        tarehe: json["tarehe"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "jina_kamati": jinaKamati,
        "tarehe": tarehe,
      };
}
