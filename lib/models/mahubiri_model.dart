class Mahubiri {
  final String id;
  final String mahubiriName;
  final String videoId;
  final String tarehe;
  final String kanisaId;

  Mahubiri({
    required this.id,
    required this.mahubiriName,
    required this.videoId,
    required this.tarehe,
    required this.kanisaId,
  });

  factory Mahubiri.fromJson(Map<String, dynamic> json) {
    return Mahubiri(
      id: json['id'].toString(),
      mahubiriName: json['mahubiri_name'].toString(),
      videoId: json['video_id'].toString(),
      tarehe: json['tarehe'].toString(),
      kanisaId: json['kanisa_id'].toString(),
    );
  }
}
