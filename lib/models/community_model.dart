class Community {
  final String userId;
  final String userName;
  final String userProfileUrl;
  final String registrationPeriod;
  final int registrationCount;
  final String title;

  Community({
    required this.userId,
    required this.userName,
    required this.userProfileUrl,
    required this.registrationPeriod,
    required this.registrationCount,
    required this.title,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      userId: json['userId'],
      userName: json['userName'],
      userProfileUrl: json['userProfileUrl'],
      registrationPeriod: json['registrationPeriod'],
      registrationCount: json['registrationCount'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() { // 앱이 서버에 데이터를 전송할 때 데이터를 JSON 포맷으로 인코딩
    return {
      'userId': userId,
      'userName': userName,
      'userProfileUrl': userProfileUrl,
      'registrationPeriod': registrationPeriod,
      'registrationCount': registrationCount,
      'title': title,
    };
  }
}
