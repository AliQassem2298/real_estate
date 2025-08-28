class Validators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال الاسم';
    }
    if (value.trim().length < 2) {
      return 'يجب أن يكون الاسم حرفين على الأقل';
    }
    return null;
  }

  static String? validateOTP(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال رقم كود صحيح';
    }
    final otpRegex = RegExp(r'^\d{4}$');

    if (!otpRegex.hasMatch(value.trim())) {
      return 'يجب أن يتكون الكود من 4 أرقام فقط';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال رقم الهاتف';
    }
    final phoneRegex = RegExp(r'^\+?\d{10,15}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'يرجى إدخال رقم هاتف صحيح';
    }
    return null;
  }

  static String? validatePasswordConfirmation(
      String? confirmation, String? original) {
    if (confirmation == null || confirmation.isEmpty) {
      return 'يرجى تأكيد كلمة المرور';
    }
    if (confirmation != original) {
      return 'كلمة المرور غير متطابقة';
    }
    return null;
  }
}
