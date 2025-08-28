import 'package:flutter/material.dart';
import 'package:real_estate/constans/color.dart';

class BottumGo extends StatelessWidget {
  final String questionText; // مثل: "ليس لديك حساب؟"
  final String actionText; // مثل: "إنشاء حساب"
  final void Function() onPressed;

  const BottumGo({
    super.key,
    required this.questionText,
    required this.actionText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            questionText,
            style: const TextStyle(fontSize: 20, color: AppColor.grey2),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              actionText,
              style: const TextStyle(
                fontSize: 20,
                color: AppColor.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
