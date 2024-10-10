// To parse this JSON data, do
//
//     final barazaLaWazeeData = barazaLaWazeeDataFromJson(jsonString);

import 'dart:convert';

List<BarazaLaWazeeData> barazaLaWazeeDataFromJson(String str) => List<BarazaLaWazeeData>.from(json.decode(str).map((x) => BarazaLaWazeeData.fromJson(x)));

String barazaLaWazeeDataToJson(List<BarazaLaWazeeData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BarazaLaWazeeData {
  BarazaLaWazeeData({
    this.id,
    this.fname,
    this.nambaYaSimu,
    this.wadhifa,
    this.status,
    this.tarehe,
  });

  dynamic id;
  String? fname;
  String? nambaYaSimu;
  String? wadhifa;
  String? status;
  DateTime? tarehe;

  factory BarazaLaWazeeData.fromJson(Map<String, dynamic> json) => BarazaLaWazeeData(
        id: json["id"],
        fname: json["fname"],
        nambaYaSimu: json["namba_ya_simu"],
        wadhifa: json["wadhifa"],
        status: json["status"],
        tarehe: DateTime.parse(json["tarehe"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fname": fname,
        "namba_ya_simu": nambaYaSimu,
        "wadhifa": wadhifa,
        "status": status,
        "tarehe": "${tarehe!.year.toString().padLeft(4, '0')}-${tarehe!.month.toString().padLeft(2, '0')}-${tarehe!.day.toString().padLeft(2, '0')}",
      };
}
