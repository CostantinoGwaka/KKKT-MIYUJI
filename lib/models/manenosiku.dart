// To parse this JSON data, do
//
//     final manenosiku = manenosikuFromJson(jsonString);

import 'dart:convert';

List<Manenosiku> manenosikuFromJson(String str) =>
    List<Manenosiku>.from(json.decode(str).map((x) => Manenosiku.fromJson(x)));

String manenosikuToJson(List<Manenosiku> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Manenosiku {
  Manenosiku({
    this.id,
    this.neno,
    this.tarehe,
  });

  String id;
  String neno;
  String tarehe;

  factory Manenosiku.fromJson(Map<String, dynamic> json) =>
      Manenosiku(id: json["id"], neno: json["neno"], tarehe: json["tarehe"],);

  Map<String, dynamic> toJson() => {
        "id": id,
        "neno": neno,
        "tarehe": tarehe,
      };
}
