class CourseRegistration {
  final String userId;
  final String courseId;
  final String? notes;

  const CourseRegistration({
    required this.userId,
    required this.courseId,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'course_id': courseId, 'notes': notes};
  }
}
