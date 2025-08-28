abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final String email;
  SignupSuccess(this.email);
}

class SignupFailure extends SignupState {
  final String error;
  SignupFailure(this.error);
}
