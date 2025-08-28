import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const TextWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            subtitle,
            style: const TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
