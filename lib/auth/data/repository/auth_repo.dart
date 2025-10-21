import 'package:fluentnow/auth/data/webservices/auth_webservices.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepo {
  late AuthWebservices authWebservices;
  AuthRepo(this.authWebservices);

  Future<bool> checkEmailExist(String email) async {
    return await authWebservices.checkEmailExist(email);
  }

  Future<bool> checkUsernameExist(String username) async {
    return await authWebservices.checkUsernameExist(username);
  }

  Future<User?> signUp(
    String email,
    String password,
    String username, // Make username  if needed
    String phoneNumber,
    String birthday,
    String sex, // 'male', 'female', 'other', etc.
  ) async {
    return authWebservices.signUp(
      email,
      password,
      username,
      phoneNumber,
      birthday,
      sex,
    );
  }

  Future<User?> signIn(String email, String password) async {
    return await authWebservices.signIn(email, password);
  }

  Future<AuthResponse> googleSignIn() async {
    return await authWebservices.googleSignIn();
  }

  bool hasRequiredMetaData(User user) {
    return authWebservices.hasRequiredMetaData(user);
  }

  Future<void> updateUser(
    String sex,
    String phone,
    String birthday,
    String username,
  ) async {
    return authWebservices.updateUser(sex, phone, birthday, username);
  }

  Future<User?> getCurrentUser() async {
    return await authWebservices.getCurrentUser();
  }

  Future<void> signOut() async {
    return await authWebservices.signOut();
  }
}
