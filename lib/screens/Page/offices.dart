import 'package:flutter/material.dart';

class OfficesPage extends StatelessWidget {
  const OfficesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("المكاتب الوسيطة")),
      body: const Center(child: Text("محتوى صفحة المكاتب")),
    );
  }
}