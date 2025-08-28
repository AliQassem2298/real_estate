import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpCubit extends Cubit<List<String>> {
  static const int codeLength = 4;

  OtpCubit() : super(List.filled(codeLength, ""));

  void updateDigit(int index, String value) {
    //  التحقق من صحة المؤشر
    if (index < 0 || index >= state.length) {
      throw ArgumentError('Index out of bounds');
    }

    //  التحقق من صحة القيمة المدخلة
    if (value.isNotEmpty) {
      if (value.length > 1 || !RegExp(r'^[0-9]$').hasMatch(value)) {
        return;
      }
    }

    //  تحديث القيمة
    final updated = List<String>.from(state);
    updated[index] = value;
    emit(updated);
  }

  // الحصول على الكود كاملاً
  String get fullCode => state.join();

  // التحقق من اكتمال جميع الحقول
  bool get isComplete => state.every((digit) => digit.isNotEmpty);

  // مسح جميع الحقول
  void clear() => emit(List.filled(codeLength, ""));

  // تنقل تلقائي بين الحقول
  void handleAutoFocus(BuildContext context, int currentIndex, String value) {
    if (value.isNotEmpty && currentIndex < codeLength - 1) {
      FocusScope.of(context).nextFocus();
    } else if (value.isEmpty && currentIndex > 0) {
      FocusScope.of(context).previousFocus();
    }
  }
}