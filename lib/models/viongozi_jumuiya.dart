// To parse this JSON data, do
//
//     final viongoziJumuiyaPodo = viongoziJumuiyaPodoFromJson(jsonString);

import 'dart:convert';

List<ViongoziJumuiyaPodo> viongoziJumuiyaPodoFromJson(String str) => List<ViongoziJumuiyaPodo>.from(json.decode(str).map((x) => ViongoziJumuiyaPodo.fromJson(x)));

String viongoziJumuiyaPodoToJson(List<ViongoziJumuiyaPodo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ViongoziJumuiyaPodo {
  ViongoziJumuiyaPodo({
    this.id,
    this.fname,
    this.phoneNo,
    this.wadhifa,
    this.jumuiya,
    this.jumuiyaId,
    this.status,
    this.tarehe,
  });

  dynamic id;
  String? fname;
  String? phoneNo;
  String? wadhifa;
  String? jumuiya;
  String? jumuiyaId;
  String? status;
  String? tarehe;

  factory ViongoziJumuiyaPodo.fromJson(Map<String, dynamic> json) => ViongoziJumuiyaPodo(
      id: json["id"],
      fname: json["fname"],
      phoneNo: json["phone_no"],
      wadhifa: json["wadhifa"],
      jumuiya: json["jumuiya"],
      jumuiyaId: json["jumuiya_id"],
      status: json["status"],
      tarehe: json["tarehe"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "fname": fname,
        "phone_no": phoneNo,
        "wadhifa": wadhifa,
        "jumuiya": jumuiya,
        "jumuiya_id": jumuiyaId,
        "status": status,
        "tarehe": tarehe,
      };
}
