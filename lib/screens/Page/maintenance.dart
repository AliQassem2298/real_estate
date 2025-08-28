import 'package:flutter/material.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("مكاتب الصيانة")),
      body: const Center(child: Text("محتوى مكاتب الصيانة")),
    );
  }
}