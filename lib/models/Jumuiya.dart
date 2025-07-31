//
//     final jumuiya = jumuiyaFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

JumuiyaData jumuiyaFromJson(String str) => JumuiyaData.fromJson(json.decode(str));

String jumuiyaToJson(JumuiyaData data) => json.encode(data.toJson());

class JumuiyaData {
  JumuiyaData({
    this.id,
    this.jumuiyaName,
    this.tarehe,
  });

  dynamic id;
  String? jumuiyaName;
  DateTime? tarehe;

  factory JumuiyaData.fromJson(Map<String, dynamic> json) => JumuiyaData(
        id: json["id"],
        jumuiyaName: json["jumuiya_name"],
        tarehe: DateTime.parse(json["tarehe"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "jumuiya_name": jumuiyaName,
        "tarehe":
            "${tarehe?.year.toString().padLeft(4, '0')}-${tarehe?.month.toString().padLeft(2, '0')}-${tarehe?.day.toString().padLeft(2, '0')}",
      };
}
