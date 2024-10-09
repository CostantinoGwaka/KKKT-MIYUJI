// To parse this JSON data, do
//
//     final viongoziKamati = viongoziKamatiFromJson(jsonString);

import 'dart:convert';

List<ViongoziKamati> viongoziKamatiFromJson(String str) => List<ViongoziKamati>.from(json.decode(str).map((x) => ViongoziKamati.fromJson(x)));

String viongoziKamatiToJson(List<ViongoziKamati> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ViongoziKamati {
  ViongoziKamati({
    this.id,
    this.fname,
    this.phoneNo,
    this.kamatiId,
    this.kamatiName,
    this.wadhifaName,
    this.memberNo,
    this.tarehe,
    this.status,
  });

  String? id;
  String? fname;
  String? phoneNo;
  String? kamatiId;
  String? kamatiName;
  String? wadhifaName;
  String? memberNo;
  String? tarehe;
  String? status;

  factory ViongoziKamati.fromJson(Map<String, dynamic> json) => ViongoziKamati(
        id: json["id"],
        fname: json["fname"],
        phoneNo: json["phone_no"],
        kamatiId: json["kamati_id"],
        kamatiName: json["kamati_name"],
        wadhifaName: json["wadhifa_name"],
        memberNo: json["member_no"],
        tarehe: json["tarehe"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fname": fname,
        "phone_no": phoneNo,
        "kamati_id": kamatiId,
        "kamati_name": kamatiName,
        "wadhifa_name": wadhifaName,
        "member_no": memberNo,
        "tarehe": tarehe,
        "status": status,
      };
}
