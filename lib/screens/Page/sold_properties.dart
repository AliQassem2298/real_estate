import 'package:flutter/material.dart';

class SoldPropertiesPage extends StatelessWidget {
  const SoldPropertiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("العقارات المباعة")),
      body: const Center(child: Text("محتوى العقارات المباعة")),
    );
  }
}