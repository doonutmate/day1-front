class TokenInformation{
  String accessToken;
  String oauthType;

  TokenInformation({required this.accessToken, required this.oauthType});

  TokenInformation.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        oauthType = json['oauthType'];

  Map<String, dynamic> toJson() =>
      {
        'accessToken': accessToken,
        'oauthType': oauthType,
      };

}