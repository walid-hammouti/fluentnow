class User {
  late String id;
  late String username;
  late String avatarUrl;

  User({required this.id, required this.username, required this.avatarUrl});

  // Factory constructor to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'],
    );
  }
}
