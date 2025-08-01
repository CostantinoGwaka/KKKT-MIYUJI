class InactiveYearResponse {
  final int status;
  final String message;
  final InactiveYear data;

  InactiveYearResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory InactiveYearResponse.fromJson(Map<String, dynamic> json) {
    return InactiveYearResponse(
      status: json['status'],
      message: json['message'],
      data: InactiveYear.fromJson(json['data']),
    );
  }
}

class InactiveYear {
  final int id;
  final String yearId;
  final String isActive;
  final String tarehe;

  InactiveYear({
    required this.id,
    required this.yearId,
    required this.isActive,
    required this.tarehe,
  });

  factory InactiveYear.fromJson(Map<String, dynamic> json) {
    return InactiveYear(
      id: json['id'],
      yearId: json['year_id'],
      isActive: json['isActive'],
      tarehe: json['tarehe'],
    );
  }
}
