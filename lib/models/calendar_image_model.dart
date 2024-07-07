class CalendarImage {
  final String date;
  final String thumbNailUrl;
  final String defaultUrl;

  CalendarImage({
    required this.date,
    required this.thumbNailUrl,
    required this.defaultUrl,
  });

  factory CalendarImage.fromJson(Map<String, dynamic> json) {
    return CalendarImage(
      date: json['date'].toString(), // Ensure date is a string
      thumbNailUrl: json['thumbNailUrl'],
      defaultUrl: json['defaultUrl'],
    );
  }
}