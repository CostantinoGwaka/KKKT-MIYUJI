// To parse this JSON data, do
//
//     final matangazo = matangazoFromJson(jsonString);

import 'dart:convert';

List<Matangazo> matangazoFromJson(String str) => List<Matangazo>.from(json.decode(str).map((x) => Matangazo.fromJson(x)));

String matangazoToJson(List<Matangazo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Matangazo {
    Matangazo({
        this.id,
        this.title,
        this.image,
        this.descp,
        this.tarehe,
    });

    String id;
    String title;
    String image;
    String descp;
    DateTime tarehe;

    factory Matangazo.fromJson(Map<String, dynamic> json) => Matangazo(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        descp: json["descp"],
        tarehe: DateTime.parse(json["tarehe"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "descp": descp,
        "tarehe": "${tarehe.year.toString().padLeft(4, '0')}-${tarehe.month.toString().padLeft(2, '0')}-${tarehe.day.toString().padLeft(2, '0')}",
    };
}
