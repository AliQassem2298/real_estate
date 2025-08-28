import 'package:flutter/material.dart';
import 'package:real_estate/constans/color.dart';

class BottumAuth extends StatelessWidget {
  final String title;
  final void Function() onPressed;

  const BottumAuth({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.blue,
            foregroundColor: AppColor.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(title, style: const TextStyle(fontSize: 18)),
        ),

    );
  }
}
