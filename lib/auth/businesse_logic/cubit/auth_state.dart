part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthCubitInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);
}

class MissingUserMetaData extends AuthState {
  final User user;

  MissingUserMetaData(this.user);
}

class UnAuthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

sealed class UpdateUserState {}

class UpdateUserInitial extends UpdateUserState {}

class UpdateUserLoading extends UpdateUserState {}

class UpdateUserSuccess extends UpdateUserState {}

class UpdateUserError extends UpdateUserState {
  final String message;
  UpdateUserError(this.message);
}

sealed class EmailValidationState {}

class EmailValidationInitial extends EmailValidationState {}

class EmailValidationLoading extends EmailValidationState {}

class EmailValidationSuccess extends EmailValidationState {
  final bool emailExists;
  EmailValidationSuccess(this.emailExists);
}

class EmailValidationError extends EmailValidationState {
  final String message;
  EmailValidationError(this.message);
}
// username_validation_state.dart

sealed class UsernameValidationState {}

class UsernameValidationInitial extends UsernameValidationState {}

class UsernameValidationLoading extends UsernameValidationState {}

class UsernameValidationSuccess extends UsernameValidationState {
  final bool usernameExists;
  UsernameValidationSuccess(this.usernameExists);
}

class UsernameValidationError extends UsernameValidationState {
  final String message;
  UsernameValidationError(this.message);
}
