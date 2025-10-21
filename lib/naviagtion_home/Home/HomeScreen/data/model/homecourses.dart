class Course {
  final String id;
  final String title;
  final int hoursPerWeek;
  final int maxStudents;
  final int durationWeeks;
  final double price;
  final String imageUrl;
  final double? discountPercent;
  final double? discountPrice;
  final DateTime? discountExpiry;

  const Course({
    required this.id,
    required this.title,
    required this.hoursPerWeek,
    required this.maxStudents,
    required this.durationWeeks,
    required this.price,
    required this.imageUrl,
    this.discountExpiry,
    this.discountPrice,
    this.discountPercent,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      hoursPerWeek: json['hours_per_week'] as int? ?? 0,
      maxStudents: json['max_students'] as int? ?? 0,
      durationWeeks: json['duration_weeks'] as int? ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String? ?? '',
      discountExpiry:
          json['discount_expiry'] != null
              ? DateTime.tryParse(json['discount_expiry'] as String)
              : null,
      discountPrice: (json['discounted_price'] as num?)?.toDouble(),
      discountPercent: (json['discount_percent'] as num?)?.toDouble(),
    );
  }
}
