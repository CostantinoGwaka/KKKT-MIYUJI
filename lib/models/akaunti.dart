// To parse this JSON data, do
//
//     final akauntiUsharikaPodo = akauntiUsharikaPodoFromJson(jsonString);

import 'dart:convert';

List<AkauntiUsharikaPodo> akauntiUsharikaPodoFromJson(String str) => List<AkauntiUsharikaPodo>.from(json.decode(str).map((x) => AkauntiUsharikaPodo.fromJson(x)));

String akauntiUsharikaPodoToJson(List<AkauntiUsharikaPodo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AkauntiUsharikaPodo {
    AkauntiUsharikaPodo({
        this.id,
        this.jina,
        this.namba,
        this.tarehe,
    });

    String id;
    String jina;
    String namba;
    String tarehe;

    factory AkauntiUsharikaPodo.fromJson(Map<String, dynamic> json) => AkauntiUsharikaPodo(
        id: json["id"],
        jina: json["jina"],
        namba: json["namba"],
        tarehe: json["tarehe"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "jina": jina,
        "namba": namba,
        "tarehe": tarehe.toString(),
    };
}
