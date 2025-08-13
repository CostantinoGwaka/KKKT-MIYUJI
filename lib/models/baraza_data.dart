class BarazaData {
  final int id;
  final String fname;
  final String nambaYaSimu;
  final String wadhifa;
  final String status;
  final String tarehe;
  final String kanisaId;

  BarazaData({
    required this.id,
    required this.fname,
    required this.nambaYaSimu,
    required this.wadhifa,
    required this.status,
    required this.tarehe,
    required this.kanisaId,
  });

  factory BarazaData.fromJson(Map<String, dynamic> json) {
    return BarazaData(
      id: int.parse(json['id'].toString()),
      fname: json['fname'] ?? '',
      nambaYaSimu: json['namba_ya_simu'] ?? '',
      wadhifa: json['wadhifa'] ?? '',
      status: json['status'] ?? '',
      tarehe: json['tarehe'] ?? '',
      kanisaId: json['kanisa_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'fname': fname,
      'namba_ya_simu': nambaYaSimu,
      'wadhifa': wadhifa,
      'status': status,
      'tarehe': tarehe,
      'kanisa_id': kanisaId,
    };
  }
}
