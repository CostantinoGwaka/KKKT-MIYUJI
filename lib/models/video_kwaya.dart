// To parse this JSON data, do
//
//     final videoKwaya = videoKwayaFromJson(jsonString);

import 'dart:convert';

List<VideoKwaya> videoKwayaFromJson(String str) => List<VideoKwaya>.from(json.decode(str).map((x) => VideoKwaya.fromJson(x)));

String videoKwayaToJson(List<VideoKwaya> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoKwaya {
  VideoKwaya({
    this.id,
    this.kwaya,
    this.videoId,
    this.tarehe,
  });

  String? id;
  String? kwaya;
  String? videoId;
  DateTime? tarehe;

  factory VideoKwaya.fromJson(Map<String, dynamic> json) => VideoKwaya(
        id: json["id"],
        kwaya: json["kwaya"],
        videoId: json["video_id"],
        tarehe: DateTime.parse(json["tarehe"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kwaya": kwaya,
        "video_id": videoId,
        "tarehe": "${tarehe!.year.toString().padLeft(4, '0')}-${tarehe!.month.toString().padLeft(2, '0')}-${tarehe!.day.toString().padLeft(2, '0')}",
      };
}
