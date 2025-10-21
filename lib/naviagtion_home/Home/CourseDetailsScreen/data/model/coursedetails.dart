class Coursedetails {
  final String descrption;
  final String level;
  final String language;
  final DateTime startDate;
  final DateTime endDate;
  final String teacherId;

  Coursedetails({
    required this.descrption,
    required this.level,
    required this.language,
    required this.startDate,
    required this.endDate,
    required this.teacherId,
  });

  factory Coursedetails.fromjson(Map<String, dynamic> json) {
    return Coursedetails(
      descrption: json['description'],
      level: json['level'],
      language: json['language'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      teacherId: json['teacher_id'],
    );
  }
}
