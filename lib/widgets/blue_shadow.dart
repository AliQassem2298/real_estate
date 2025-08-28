import 'package:flutter/material.dart';
import 'package:real_estate/constans/color.dart';

class BlueShadow extends StatelessWidget {
  const BlueShadow({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: AppColor.shdow.withOpacity(0.3),
      ),
    );
  }
}
