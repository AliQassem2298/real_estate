import 'package:flutter/material.dart';
import 'package:real_estate/models/Filter_Properties.dart' as FP;
import 'package:real_estate/services/FilterPropertyService.dart';
import 'package:real_estate/constans/image_url.dart';
import 'package:real_estate/helper/api.dart';

class FilterPropertiesPage extends StatefulWidget {
  const FilterPropertiesPage({super.key});

  @override
  State<FilterPropertiesPage> createState() => _FilterPropertiesPageState();
}

class _FilterPropertiesPageState extends State<FilterPropertiesPage> {
  final FilterPropertyService _service = FilterPropertyService();
  final TextEditingController _title = TextEditingController();
  String? _status; // 'sale' or 'rent'
  Future<FP.FilterPropertyResponse>? _future;

  void _run() {
    setState(() {
      _future = _service.filterProperties(
        title: _title.text.isNotEmpty ? _title.text : null,
        status: _status,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('بحث متقدم')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _title,
                  decoration: const InputDecoration(
                    labelText: 'العنوان',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('الحالة:'),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: _status,
                      items: const [
                        DropdownMenuItem(value: 'sale', child: Text('للبيع')),
                        DropdownMenuItem(value: 'rent', child: Text('إيجار')),
                      ],
                      hint: const Text('اختر'),
                      onChanged: (v) => setState(() => _status = v),
                    ),
                    const Spacer(),
                    ElevatedButton(onPressed: _run, child: const Text('بحث')),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _future == null
                ? const Center(child: Text('استخدم الحقول أعلاه لبدء البحث'))
                : FutureBuilder<FP.FilterPropertyResponse>(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('خطأ: ${snapshot.error}'));
                      } else if (!snapshot.hasData ||
                          snapshot.data!.data.isEmpty) {
                        return const Center(child: Text('لا توجد نتائج'));
                      }
                      final items = snapshot.data!.data;
                      return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final p = items[index];
                          final imageUrl = p.images.isNotEmpty
                              ? '$baseUrlImage${p.images.first.imagePath}'
                              : null;
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: imageUrl != null
                                  ? Image.network(imageUrl,
                                      width: 56, height: 56, fit: BoxFit.cover)
                                  : Image.asset(AppImageAsset.onboarding1,
                                      width: 56, height: 56, fit: BoxFit.cover),
                            ),
                            title: Text(p.title),
                            subtitle:
                                Text(p.status == 'sale' ? 'للبيع' : 'إيجار'),
                          );
                        },
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
