import 'package:flutter/material.dart';
import 'package:real_estate/constans/image_url.dart';
import 'package:real_estate/helper/api.dart';
import 'package:real_estate/models/List_Favorites_model.dart';
import 'package:real_estate/screens/property_detail_screen.dart';
import 'package:real_estate/services/List_Favorites_service.dart';
import 'package:real_estate/services/delete_favorite_service.dart';
import 'package:real_estate/main.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final ListFavoritesService _listService = ListFavoritesService();
  final DeleteFavoriteService _deleteService = DeleteFavoriteService();

  late Future<ListFavoritesModel> _futureFavorites;

  @override
  void initState() {
    super.initState();
    _futureFavorites = _fetchFavorites();
  }

  Future<ListFavoritesModel> _fetchFavorites() async {
    return await _listService.listFavorites();
  }

  Future<void> _removeFromFavorites(int favoriteItemId, int propertyId) async {
    try {
      await _deleteService.deleteFavorite(id: favoriteItemId);

      if (mounted) {
        setState(() {
          _futureFavorites = _fetchFavorites();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم إزالة العقار من المفضلة")),
        );

        // ✅ تحديث قائمة المفضلة المحلية في sharedPreferences
        final currentIds =
            sharedPreferences!.getStringList('favorite_ids') ?? [];
        currentIds.remove(propertyId.toString());
        await sharedPreferences!.setStringList('favorite_ids', currentIds);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("خطأ: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("المفضلة"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); // ✅ إرسال إشارة عند العودة
          },
        ),
      ),
      body: FutureBuilder<ListFavoritesModel>(
        future: _futureFavorites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("خطأ: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return const Center(child: Text("لا توجد عقارات محفوظة"));
          }

          final items = snapshot.data!.data;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.78,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final property = item.property;

              final String? imageUrl = property.images.isNotEmpty
                  ? '$baseUrlImage${property.images[0].imagePath}'
                  : null;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PropertyDetailScreen(propertyId: property.id),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15)),
                            child: imageUrl != null
                                ? Image.network(
                                    '$baseUrlImage$imageUrl',
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        AppImageAsset.onboarding1,
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    AppImageAsset.onboarding1,
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  property.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${property.price} ريال",
                                  style: const TextStyle(
                                      color: Colors.blue, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            property.status == 'sale' ? 'للبيع' : 'إيجار',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: IconButton(
                          icon: const Icon(Icons.favorite,
                              color: Colors.red, size: 20),
                          onPressed: () => _removeFromFavorites(
                              item.propertyId, property.id),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
