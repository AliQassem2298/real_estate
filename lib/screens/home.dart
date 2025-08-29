import 'package:flutter/material.dart';
import 'package:real_estate/constans/image_url.dart';
import 'package:real_estate/helper/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/Public_List_Approved_model.dart';
import 'package:real_estate/screens/Page/profile.dart';
import 'package:real_estate/screens/add_property.dart';
import 'package:real_estate/screens/drawer.dart';
import 'package:real_estate/screens/favorites_screen.dart';
import 'package:real_estate/screens/property_detail_screen.dart';
import 'package:real_estate/services/Public_List_Approved_service.dart';
import 'package:real_estate/services/add_Favorite_service.dart';
import 'package:real_estate/services/appointment_service.dart';
import 'package:real_estate/services/delete_favorite_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Set<int> _favoriteIds = {};
  final PublicListApprovedService _service = PublicListApprovedService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final pending = sharedPreferences!.getBool('pending_approval') ?? false;
      if (pending && mounted) {
        sharedPreferences!.remove('pending_approval');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('تم إرسال طلبك إلى الأدمن. سيظهر العقار بعد الموافقة.')),
        );
        setState(() {});
      }
    });
  }

  Future<void> _loadFavorites() async {
    final prefs = sharedPreferences!.getStringList('favorite_ids') ?? [];
    if (mounted) {
      setState(() {
        _favoriteIds = prefs.map(int.parse).toSet();
      });
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = _favoriteIds.map((id) => id.toString()).toList();
    await sharedPreferences!.setStringList('favorite_ids', prefs);
  }

  Future<void> _toggleFavorite(int propertyId) async {
    final isFavorite = _favoriteIds.contains(propertyId);

    try {
      if (isFavorite) {
        await DeleteFavoriteService().deleteFavorite(id: propertyId);
        _favoriteIds.remove(propertyId);
      } else {
        await AddFavoriteService().addFavorite(propertyId: propertyId);
        _favoriteIds.add(propertyId);
      }
      await _saveFavorites();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("حدث خطأ: $e")),
        );
      }
    }
  }

  Future<PublicListApprovedModel> _fetchProperties() async {
    return await _service.publicListApproved();
  }

  // ✅ دالة لاستقبال التحديث من المفضلة
  Future<void> _openFavoritesPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FavoritesPage()),
    );
    if (result == true) {
      // ✅ تم تحديث المفضلة، نعيد التحميل
      await _loadFavorites();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      extendBody: true,
      endDrawer: buildDrawer(context),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 70, left: 16, right: 16),
              color: Colors.white,
              child: Row(
                children: [
                  // IconButton(
                  //   onPressed: () async {
                  //     // sharedPreferences!.clear();
                  //     AppointmentService().createAppointment(
                  //         mediatorId: 1,
                  //         date: '2025-02-02',
                  //         time: '10:20',
                  //         propertyId: 1);
                  //     print("${sharedPreferences!.getString("token")}");
                  //   },
                  //   icon: const Icon(Icons.abc),
                  // ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(14),
                    child:
                        const Icon(Icons.person, color: Colors.blue, size: 28),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('مرحبا بك !',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('في عقاري', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            // ✅ زر القائمة
            Positioned(
              top: 40,
              left: 16,
              child: InkWell(
                onTap: () {
                  if (mounted) {
                    _scaffoldKey.currentState?.openEndDrawer();
                  }
                },
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: const Icon(Icons.menu, color: Colors.blue, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 35,
            ),
            // مربع البحث
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(12),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.grey.withOpacity(0.1),
            //           blurRadius: 6,
            //           offset: const Offset(0, 2),
            //         )
            //       ],
            //     ),
            //     child: TextField(
            //       decoration: InputDecoration(
            //         hintText: 'بحث',
            //         hintStyle: TextStyle(color: Colors.grey[400]),
            //         prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
            //         border: InputBorder.none,
            //         contentPadding: const EdgeInsets.symmetric(vertical: 14),
            //       ),
            //     ),
            //   ),
            // ),
            // عنوان عروض اليوم
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.star, color: Colors.blue, size: 20),
                  ),
                  const SizedBox(width: 8),
                  const Text('عروض اليوم',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // عرض العقارات
            SizedBox(
              height: 230,
              child: FutureBuilder<PublicListApprovedModel>(
                future: _fetchProperties(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("خطأ: ${snapshot.error}"));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text("لا توجد بيانات"));
                  }

                  final properties = snapshot.data!.data;

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: properties.length,
                    itemBuilder: (context, index) {
                      final property = properties[index];
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
                        child: _houseCard(property, property.id),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Tabs
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text('الأحدث',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Spacer(),
                  // _filterButton('الكل'),
                  // const SizedBox(width: 8),
                  // _filterButton('بيع'),
                  // const SizedBox(width: 8),
                  // _filterButton('إيجار'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // شبكة العقارات
            FutureBuilder<PublicListApprovedModel>(
              future: _fetchProperties(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("خطأ: ${snapshot.error}"));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text("لا توجد بيانات"));
                }

                final properties = snapshot.data!.data;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: properties.length,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (context, index) {
                    final property = properties[index];
                    return _houseCard(property, property.id);
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Material(
          elevation: 8,
          color: Colors.white,
          child: SizedBox(
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: _openFavoritesPage, // ✅ استخدم الدالة الجديدة
                ),
                const SizedBox(width: 48),
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Profile()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddPropertyScreen()),
            );
          },
          backgroundColor: Colors.blue,
          heroTag: 'home_fab',
          child: const Icon(Icons.add, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _filterButton(String label) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _houseCard(PropertyModel property, int propertyId) {
    final isFavorite = _favoriteIds.contains(propertyId);
    final imageUrl = property.images.isNotEmpty
        ? '$baseUrlImage${property.images.first.imagePath}'
        : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PropertyDetailScreen(propertyId: propertyId),
          ),
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // الصورة
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            AppImageAsset.onboarding1,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          AppImageAsset.onboarding1,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                // حالة العقار: للبيع / إيجار
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      property.status == 'sale'
                          ? 'للبيع'
                          : property.status == 'rent'
                              ? 'إيجار'
                              : 'محجوز',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                // زر المفضلة
                Positioned(
                  top: 8,
                  left: 8,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                      size: 24,
                    ),
                    onPressed: () => _toggleFavorite(propertyId),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان
                  Text(
                    property.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  // المساحة ونوع العقار
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '${property.area} م² - ${property.type.type}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // عدد الغرف والسعر
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${property.roomsCount ?? 0} غرف',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                      Text(
                        '${property.price.toString()} ريال',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
