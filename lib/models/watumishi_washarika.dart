// To parse this JSON data, do
//
//     final watumishiUsharika = watumishiUsharikaFromJson(jsonString);

import 'dart:convert';

List<WatumishiUsharika> watumishiUsharikaFromJson(String str) => List<WatumishiUsharika>.from(json.decode(str).map((x) => WatumishiUsharika.fromJson(x)));

String watumishiUsharikaToJson(List<WatumishiUsharika> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WatumishiUsharika {
  WatumishiUsharika({
    this.id,
    this.fname,
    this.phoneNo,
    this.wadhifa,
    this.memberNo,
    this.status,
    this.tarehe,
  });

  String? id;
  String? fname;
  String? phoneNo;
  String? wadhifa;
  String? memberNo;
  String? status;
  DateTime? tarehe;

  factory WatumishiUsharika.fromJson(Map<String, dynamic> json) => WatumishiUsharika(
        id: json["id"],
        fname: json["fname"],
        phoneNo: json["phone_no"],
        wadhifa: json["wadhifa"],
        memberNo: json["member_no"],
        status: json["status"],
        tarehe: DateTime.parse(json["tarehe"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fname": fname,
        "phone_no": phoneNo,
        "wadhifa": wadhifa,
        "member_no": memberNo,
        "status": status,
        "tarehe": "${tarehe!.year.toString().padLeft(4, '0')}-${tarehe!.month.toString().padLeft(2, '0')}-${tarehe!.day.toString().padLeft(2, '0')}",
      };
}
