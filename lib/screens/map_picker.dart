
import 'package:flutter/material.dart';

class MapPicker extends StatelessWidget {
  const MapPicker({super.key});

  @override
  Widget build(BuildContext context) {
    // استبدل هذا بـ GoogleMap أو FlutterMap لاحقًا
    return Scaffold(
      appBar: AppBar(title: const Text('اختيار الموقع')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map, size: 150, color: Colors.grey),
            const Text('خريطة وهمية هنا'),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('اختر موقعك'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}