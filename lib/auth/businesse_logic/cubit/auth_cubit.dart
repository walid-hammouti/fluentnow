import 'package:bloc/bloc.dart';
import 'package:fluentnow/auth/data/repository/auth_repo.dart';
import 'package:fluentnow/auth/data/webservices/auth_webservices.dart';
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_state.dart';

abstract class BaseAuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;

  BaseAuthCubit(this.authRepo) : super(AuthCubitInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    try {
      final user = await authRepo.getCurrentUser();
      emit(user != null ? Authenticated(user) : UnAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

class SignInCubit extends BaseAuthCubit {
  SignInCubit(super.authRepo);

  Future<void> signIn(String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.signIn(email, password);
      emit(Authenticated(user!));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

class SignUpCubit extends BaseAuthCubit {
  SignUpCubit(super.authRepo);

  Future<void> signUp(
    String email,
    String password,
    String username, // Make username  if needed
    String phoneNumber,
    String birthday,
    String sex, // 'male', 'female', 'other', etc.
  ) async {
    emit(AuthLoading());
    try {
      final user = await authRepo.signUp(
        email,
        password,
        username,
        phoneNumber,
        birthday,
        sex,
      );
      emit(Authenticated(user!));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

class SignOutCubit extends BaseAuthCubit {
  SignOutCubit(super.authRepo);

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await authRepo.signOut();
      emit(UnAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
// email_validation_cubit.dart

class EmailValidationCubit extends Cubit<EmailValidationState> {
  AuthRepo authRepo = AuthRepo(AuthWebservices());

  EmailValidationCubit() : super(EmailValidationInitial());

  Future<void> checkEmailExist(String email) async {
    if (email.isEmpty) {
      emit(EmailValidationSuccess(false));
      return;
    }

    emit(EmailValidationLoading());

    try {
      final response = await authRepo.checkEmailExist(email);
      emit(EmailValidationSuccess(response));
    } catch (e) {
      emit(EmailValidationError('Failed to check email'));
    }
  }
}

class SignInWithGoogleCubit extends BaseAuthCubit {
  SignInWithGoogleCubit(super.authRepo);

  Future<void> googleSignIn() async {
    emit(AuthLoading());
    try {
      final response = await authRepo.googleSignIn();
      final user = response.user;

      if (user != null) {
        final hasAllMetaData = authRepo.hasRequiredMetaData(user);

        if (hasAllMetaData) {
          emit(Authenticated(user));
        } else {
          emit(MissingUserMetaData(user));
        }
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

class UpdateUserCubit extends Cubit<UpdateUserState> {
  AuthRepo authRepo = AuthRepo(AuthWebservices());

  UpdateUserCubit() : super(UpdateUserInitial());

  Future<void> updateUser(
    String sex,
    String phone,
    String birthday,
    String username,
  ) async {
    emit(UpdateUserLoading());
    try {
      await authRepo.updateUser(sex, phone, birthday, username);
      emit(UpdateUserSuccess());
    } catch (e) {
      emit(UpdateUserError('Failed to update user: ${e.toString()}'));
    }
  }
}

class UsernameValidationCubit extends Cubit<UsernameValidationState> {
  AuthRepo authRepo = AuthRepo(AuthWebservices());
  UsernameValidationCubit() : super(UsernameValidationInitial());

  Future<void> checkUsernameExist(String username) async {
    if (username.isEmpty) {
      emit(UsernameValidationSuccess(false));
      return;
    }

    emit(UsernameValidationLoading());

    try {
      final response = await authRepo.checkUsernameExist(username);

      emit(UsernameValidationSuccess(response));
    } catch (e) {
      emit(UsernameValidationError('Failed to check username'));
    }
  }
}
