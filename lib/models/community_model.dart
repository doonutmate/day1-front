class Community {
  int id;
  int memberId;
  int totalCount;
  String memberName;
  String calendarName;
  String firstUploadedAt;
  String lastUploadedAt;
  String updatedAt;
  String profileImage;

  Community({
    required this.id,
    required this.memberId,
    required this.totalCount,
    required this.memberName,
    required this.calendarName,
    required this.firstUploadedAt,
    required this.lastUploadedAt,
    required this.updatedAt,
    required this.profileImage,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'],
      memberId: json['memberId'],
      totalCount: json['totalCount'],
      memberName: json['memberName'],
      calendarName: json['calendarName'],
      firstUploadedAt: json['firstUploadedAt'],
      lastUploadedAt: json['lastUploadedAt'],
      updatedAt: json['updatedAt'],
      profileImage: json['profileImage'] ?? "null",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberId': memberId,
      'totalCount': totalCount,
      'memberName': memberName,
      'calendarName': calendarName,
      'firstUploadedAt': firstUploadedAt,
      'lastUploadedAt': lastUploadedAt,
      'updatedAt': updatedAt,
      'profileImage': profileImage,
    };
  }
}