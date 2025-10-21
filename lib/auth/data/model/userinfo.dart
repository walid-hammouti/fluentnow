class Userinfo {
  String? username;
  String? phoneNumber;
  String? dateOfBirth;
  String? sex;

  Userinfo({this.username, this.phoneNumber, this.dateOfBirth, this.sex});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'phone_number': phoneNumber,
      'date_of_birth': dateOfBirth,
      'sex': sex,
    };
  }
}
