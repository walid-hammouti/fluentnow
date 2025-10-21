import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthWebservices {
  Future<bool> checkEmailExist(String email) async {
    try {
      if (email.isEmpty) return false;
      final response =
          await Supabase.instance.client
              .from('users')
              .select('email')
              .eq('email', email)
              .maybeSingle();
      return response != null;
    } catch (_) {
      return false; // or rethrow if you prefer
    }
  }

  Future<bool> checkUsernameExist(String username) async {
    try {
      if (username.isEmpty) return false;

      final response =
          await Supabase.instance.client
              .from('users')
              .select('username')
              .eq('username', username)
              .maybeSingle();

      return response != null;
    } catch (_) {
      return false; // or rethrow if you prefer
    }
  }

  Future<User?> signUp(
    String email,
    String password,
    String username, // Make username  if needed
    String phoneNumber,
    String birthday,
    String sex, // 'male', 'female', 'other', etc.
  ) async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username, // Store username in metadata
          'phone': phoneNumber,
          'birthday': birthday,
          'sex': sex,
          // Add other custom fields as needed
        },
      );
      return response.user;
    } catch (e) {
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final response = Supabase.instance.client.auth.currentSession;
      return response?.user;
    } catch (error) {
      throw Exception('Error getting current user: $error');
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user;
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  Future<AuthResponse> googleSignIn() async {
    const webClientId =
        '369697970112-s4ddv1itjqrhpicohm8h754i5tabop48.apps.googleusercontent.com';
    const iosClientId =
        '369697970112-aospr6r86othscrvmrfpf7c9k5pv49ma.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );

    try {
      // 1. Attempt sign-in (returns null if dialog is closed)
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw 'Sign-in cancelled by user'; // Handle dialog close
      }

      // 2. Get authentication tokens
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        await googleSignIn.signOut(); // Clean up
        throw 'Missing Google auth tokens';
      }

      // 3. Sign in to Supabase
      return await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      await googleSignIn.signOut(); // Clean up on error
      rethrow; // Preserve the original error
    }
  }

  bool hasRequiredMetaData(User user) {
    final metadata = user.userMetadata;

    return metadata != null &&
        metadata['sex'] != null &&
        metadata['phone'] != null &&
        metadata['birthday'] != null;
  }

  Future<void> updateUser(
    String sex,
    String phone,
    String birthday,
    String username,
  ) async {
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          data: {
            'username': username.trim(), // Assuming username is available
            'sex': sex.trim(),
            'phone': phone.trim(),
            'birthday': birthday.trim(),
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to update user: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      await Supabase.instance.client.auth.signOut();

      // Only disconnect Google if they signed in with Google
      if (session?.user.appMetadata['provider'] == 'google') {
        await GoogleSignIn().disconnect();
      }
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }
}
