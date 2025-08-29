import 'package:flutter/material.dart';
import 'package:real_estate/services/List_Ratings_for_Property_service.dart';
import 'package:real_estate/services/Create_Update_Rating_service.dart';
import 'package:real_estate/models/List_Ratings_for_Property_model.dart';

class RatingsPage extends StatefulWidget {
  final int propertyId;
  const RatingsPage({super.key, required this.propertyId});

  @override
  State<RatingsPage> createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage> {
  final ListRatingsForPropertyService _listService =
      ListRatingsForPropertyService();
  final CreateUpdateRatingService _createService = CreateUpdateRatingService();
  late Future<ListRatingsForPropertyModel> _future;

  final TextEditingController _commentController = TextEditingController();
  int _rating = 5;

  @override
  void initState() {
    super.initState();
    _future = _listService.listRatingsForProperty(id: widget.propertyId);
  }

  Future<void> _submit() async {
    try {
      await _createService.createUpdateRating(
        propertyId: widget.propertyId,
        rating: _rating,
        comment: _commentController.text,
      );
      if (!mounted) return;
      setState(() {
        _future = _listService.listRatingsForProperty(id: widget.propertyId);
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('تم إرسال التقييم')));
      _commentController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('خطأ: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التقييمات')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<ListRatingsForPropertyModel>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('خطأ: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                  return const Center(child: Text('لا توجد تقييمات'));
                }
                final ratings = snapshot.data!.data;
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: ratings.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final r = ratings[index];
                    return ListTile(
                      title: Text('${r.user.name} - ${r.rating}/5'),
                      subtitle: Text(r.comment ?? ''),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('أكتب تعليقك:'),
                const SizedBox(height: 8),
                TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('التقييم:'),
                    const SizedBox(width: 12),
                    DropdownButton<int>(
                      value: _rating,
                      items: List.generate(5, (i) => i + 1)
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text('$e')))
                          .toList(),
                      onChanged: (v) => setState(() => _rating = v ?? 5),
                    ),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: _submit, child: const Text('إرسال')),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
