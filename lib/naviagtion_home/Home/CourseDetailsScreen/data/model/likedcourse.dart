class Likedcourse {
  final String courseId;
  final String userId;

  Likedcourse({required this.courseId, required this.userId});

  Map<String, dynamic> toJson() {
    return {'course_id': courseId, 'user_id': userId};
  }
}
