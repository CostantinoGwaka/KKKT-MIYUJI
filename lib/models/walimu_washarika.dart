// To parse this JSON data, do
//
//     final walimuUsharika = walimuUsharikaFromJson(jsonString);

import 'dart:convert';

List<WalimuUsharika> walimuUsharikaFromJson(String str) => List<WalimuUsharika>.from(json.decode(str).map((x) => WalimuUsharika.fromJson(x)));

String walimuUsharikaToJson(List<WalimuUsharika> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WalimuUsharika {
  WalimuUsharika({
    this.id,
    this.fname,
    this.phoneNo,
    this.wadhifa,
    this.status,
    this.tarehe,
  });

  dynamic id;
  String? fname;
  String? phoneNo;
  String? wadhifa;
  String? status;
  DateTime? tarehe;

  factory WalimuUsharika.fromJson(Map<String, dynamic> json) => WalimuUsharika(
        id: json["id"],
        fname: json["fname"],
        phoneNo: json["phone_no"],
        wadhifa: json["wadhifa"],
        status: json["status"],
        tarehe: DateTime.parse(json["tarehe"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fname": fname,
        "phone_no": phoneNo,
        "wadhifa": wadhifa,
        "status": status,
        "tarehe": "${tarehe!.year.toString().padLeft(4, '0')}-${tarehe!.month.toString().padLeft(2, '0')}-${tarehe!.day.toString().padLeft(2, '0')}",
      };
}
