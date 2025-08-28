import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate/blocs/auth/verify/verify_state.dart';
import 'package:real_estate/constans/links_api.dart';
import '../../../crud.dart';

class VerifyCubit extends Cubit<VerifyState> {
  final Crud _crud;

  VerifyCubit(this._crud) : super(VerifyInitial());

  Future<void> verifyCode(String email, String otp) async {
    emit(VerifyLoading());

    try {
      print("Verification data: {email: $email, otp: $otp}");

      final response = await _crud.postRequest(
        AppLink.verify, // Replace with your actual endpoint
        {
          'email': email,
          'otp': otp,
        },
      );

      if (response == null) {
        emit(VerifyFailure('Failed to connect to server'));
        return;
      }

      if (response['message'] == 'verified successfully') {
        emit(VerifySuccess());
      } else {
        final error = response['message'] ?? 'Verification failed';
        emit(VerifyFailure(error));
      }
    } catch (e) {
      emit(VerifyFailure('An unexpected error occurred'));
    }
  }
}