import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate/constans/links_api.dart';
import 'package:real_estate/main.dart';
import '../../../crud.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final Crud crud;

  LoginCubit(this.crud) : super(LoginInitial());

  // تسجيل الدخول
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      final response = await crud.postRequest(
        AppLink.login,
        {
          "identifier": email,
          "password": password,
        },
      );

      print("Login response: $response");

      if (response != null &&
          (response['status'] == "success" ||
              (response['message']?.toString().contains("success") ?? false))) {
        if (response['token'] != null) {
          sharedPreferences!.setString("token", response['token']);
          print("Token saved: ${response['token']}");
        }
        emit(LoginSuccess());
      } else {
        String errorMessage = "حدث خطأ أثناء تسجيل الدخول";
        if (response != null) {
          errorMessage =
              response['message'] ?? response['error'] ?? errorMessage;
        }
        emit(LoginFailure(error: errorMessage));
      }
    } catch (e) {
      print("Login error: $e");
      emit(LoginFailure(error: "فشل الاتصال بالخادم"));
    }
  }

  // نسيان كلمة المرور
  Future<Map<String, dynamic>> forgetPassword({required String email}) async {
    emit(LoginLoading());
    try {
      final response = await crud.postRequest(
        AppLink.forgetPassword,
        {"email": email},
      );

      print("Forget Password response: $response");

      // تحقق من النجاح من خلال الرسالة أو الكود
      if (response != null && response['message'] != null) {
        final String message = response['message'].toString();

        // اعتبار النجاح إذا كانت الرسالة تحتوي على كلمات دالة
        if (message.contains("verify") ||
            message.contains("تم") ||
            message.contains("sent")) {
          emit(LoginInitial()); // عد للحالة العادية بعد النجاح
          return {
            'success': true,
            'message': message,
          };
        } else {
          emit(LoginFailure(error: message));
          return {
            'success': false,
            'message': message,
          };
        }
      } else {
        const String errorMsg = "البريد الإلكتروني غير مسجل";
        emit(LoginFailure(error: errorMsg));
        return {
          'success': false,
          'message': errorMsg,
        };
      }
    } catch (e) {
      print("Forget password error: $e");
      const String errorMsg = "تعذر إرسال الرمز. تحقق من الاتصال.";
      emit(LoginFailure(error: errorMsg));
      return {
        'success': false,
        'message': errorMsg,
      };
    }
  }

  // إعادة تعيين كلمة المرور
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(LoginLoading());
    try {
      final response = await crud.postRequest(
        AppLink.resetPassword,
        {
          "email": email,
          "otp": otp,
          "password": password,
          "password_confirmation": passwordConfirmation,
        },
      );

      print("Reset Password response: $response");

      if (response != null) {
        final String? message = response['message']?.toString();

        // تحقق من نجاح العملية
        if (response['success'] == true ||
            message?.contains("reset") == true ||
            message?.contains("تم") == true ||
            message?.contains("successfully") == true) {
          emit(LoginInitial()); // مهم: ما تترك المستخدم في حالة تحميل
          return {
            'success': true,
            'message': message ?? "تم تغيير كلمة المرور بنجاح",
          };
        } else {
          final String errorMsg = response['message'] ??
              response['error'] ??
              "فشل تغيير كلمة المرور";
          emit(LoginFailure(error: errorMsg));
          return {
            'success': false,
            'message': errorMsg,
          };
        }
      } else {
        const String errorMsg = "لا يوجد استجابة من الخادم";
        emit(LoginFailure(error: errorMsg));
        return {
          'success': false,
          'message': errorMsg,
        };
      }
    } catch (e) {
      print("Reset password error: $e");
      const String errorMsg = "فشل في تغيير كلمة المرور. تحقق من الاتصال.";
      emit(LoginFailure(error: errorMsg));
      return {
        'success': false,
        'message': errorMsg,
      };
    }
  }
}
