// To parse this JSON data, do
//
//     final viongoziWaKanisaData = viongoziWaKanisaDataFromJson(jsonString);

import 'dart:convert';

List<ViongoziWaKanisaData> viongoziWaKanisaDataFromJson(String str) => List<ViongoziWaKanisaData>.from(json.decode(str).map((x) => ViongoziWaKanisaData.fromJson(x)));

String viongoziWaKanisaDataToJson(List<ViongoziWaKanisaData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ViongoziWaKanisaData {
  ViongoziWaKanisaData({
    this.id,
    this.fname,
    this.wadhifa,
    this.status,
    this.tarehe,
  });

  String? id;
  String? fname;
  String? wadhifa;
  String? status;
  DateTime? tarehe;

  factory ViongoziWaKanisaData.fromJson(Map<String, dynamic> json) => ViongoziWaKanisaData(
        id: json["id"],
        fname: json["fname"],
        wadhifa: json["wadhifa"],
        status: json["status"],
        tarehe: DateTime.parse(json["tarehe"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fname": fname,
        "wadhifa": wadhifa,
        "status": status,
        "tarehe": "${tarehe?.year.toString().padLeft(4, '0')}-${tarehe?.month.toString().padLeft(2, '0')}-${tarehe?.day.toString().padLeft(2, '0')}",
      };
}
