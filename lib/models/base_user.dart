class BaseUser {
  final String id;
  final String kanisaId;
  final String kanisaName;
  final String memberNo;
  final String userType;

  BaseUser({
    required this.id,
    required this.kanisaId,
    required this.kanisaName,
    required this.memberNo,
    required this.userType,
  });

  factory BaseUser.fromJson(Map<String, dynamic> json) {
    return BaseUser(
      id: json['id'] ?? '',
      kanisaId: json['kanisa_id'] ?? '',
      kanisaName: json['kanisa_name'] ?? '',
      memberNo: json['member_no'] ?? '',
      userType: json['user_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kanisa_id': kanisaId,
      'kanisa_name': kanisaName,
      'member_no': memberNo,
      'user_type': userType,
    };
  }
}
