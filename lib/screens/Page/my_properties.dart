import 'package:flutter/material.dart';

class MyPropertiesPage extends StatelessWidget {
  const MyPropertiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("عقاراتي")),
      body: const Center(child: Text("محتوى صفحة عقاراتي")),
    );
  }
}