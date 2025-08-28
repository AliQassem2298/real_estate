import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate/blocs/auth/signup/signup_state.dart';
import 'package:real_estate/constans/links_api.dart';
import '../../../crud.dart';
class SignupCubit extends Cubit<SignupState> {
  final Crud crud;

  SignupCubit(this.crud) : super(SignupInitial());

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phoneNumber,
  }) async {
    emit(SignupLoading());
    try {
      final response = await crud.postRequest(AppLink.signup, {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "phone_number": phoneNumber,
      });

      print("📨 Signup response: $response");

      if (response != null &&
          (response['status'] == "success" ||
              response['message']?.toString().contains("User registered") == true)) {
        emit(SignupSuccess(email));
      } else {
        String errorMessage = " حدث خطأ أثناء التسجيل.";
        if (response != null) {
          if (response.containsKey('message')) {
            errorMessage = response['message'];
          } else if (response.containsKey('error')) {
            errorMessage = response['error'];
          }
        }
        emit(SignupFailure(errorMessage));
      }
    } catch (e) {
      print(" Exception during signup: $e");
      emit(SignupFailure("خطأ غير متوقع: ${e.toString()}"));
    }
  }
}
