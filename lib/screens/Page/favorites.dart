// // import 'package:flutter/material.dart';
// // import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// // class FavoritesPage extends StatelessWidget {
// //   const FavoritesPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('المفضلة'),
// //         backgroundColor: Colors.blue,
// //       ),
// //       body: ListView.builder(
// //         itemCount: 5, // عدد العقارات المفضلة (تجريبي)
// //         itemBuilder: (context, index) {
// //           return _buildFavoriteItem(context);
// //         },
// //       ),
// //     );
// //   }

// //   Widget _buildFavoriteItem(BuildContext context) {
// //     return Card(
// //       margin: const EdgeInsets.all(12),
// //       elevation: 3,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.end,
// //         children: [
// //           ClipRRect(
// //             borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
// //             child: Image.asset(
// //               'assets/images/IMG-20230906-WA0032.jpg', // تأكد من وجودها في pubspec.yaml
// //               height: 180,
// //               width: double.infinity,
// //               fit: BoxFit.cover,
// //             ),
// //           ),
// //           const Padding(
// //             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //             child: Text(
// //               'فيلا فاخرة للبيع',
// //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //               textAlign: TextAlign.right,
// //             ),
// //           ),
// //           const Padding(
// //             padding: EdgeInsets.symmetric(horizontal: 12),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Text('دمشق - المزة', style: TextStyle(fontSize: 13)),
// //                 Icon(Icons.location_on, size: 16, color: Colors.grey),
// //               ],
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //             child: RatingBarIndicator(
// //               rating: 4.5,
// //               itemCount: 5,
// //               itemSize: 20,
// //               direction: Axis.horizontal,
// //               itemBuilder: (context, _) =>
// //                   const Icon(Icons.star, color: Colors.amber),
// //             ),
// //           ),
// //           Align(
// //             alignment: Alignment.centerLeft,
// //             child: IconButton(
// //               icon: const Icon(Icons.delete_outline, color: Colors.red),
// //               onPressed: () {
// //                 // حذف من المفضلة - مؤقت (لا يحذف فعليًا)
// //                 ScaffoldMessenger.of(context).showSnackBar(
// //                   const SnackBar(content: Text('تمت الإزالة من المفضلة')),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';

// class FavoritesPage extends StatefulWidget {
//   const FavoritesPage({super.key});

//   @override
//   State<FavoritesPage> createState() => _FavoritesPageState();
// }

// class _FavoritesPageState extends State<FavoritesPage> {
//   // قائمة العقارات المفضلة (تجريبية)
//   List<Map<String, dynamic>> favorites = [
//     {
//       "title": "فيلا",
//       "location": "دمشق، برامكة",
//       "rating": 4.9,
//       "price": "10 مليون ل.س",
//       "image":
//           "https://images.unsplash.com/photo-1560185008-b033106afeb2?auto=format&fit=crop&w=800&q=80",
//       "status": "للبيع"
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F0F0),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: const Color(0xFFF1F0F0),
//         centerTitle: true,
//         title: const Text(
//           "المفضلة",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//       body: favorites.isEmpty ? _buildEmptyState() : _buildFavoritesList(),
//       bottomNavigationBar: _buildBottomNav(),
//     );
//   }

//   /// الحالة عندما لا يوجد عناصر
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.blue,
//             ),
//             padding: const EdgeInsets.all(24),
//             child: const Icon(Icons.add, color: Colors.white, size: 40),
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             "المفضلة لديك فارغة",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             "اضغط على الزر لإضافة العقار المفضل لديك",
//             style: TextStyle(fontSize: 14, color: Colors.black54),
//           ),
//         ],
//       ),
//     );
//   }

//   /// قائمة العقارات المفضلة
//   Widget _buildFavoritesList() {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: favorites.length,
//       itemBuilder: (context, index) {
//         final item = favorites[index];
//         return Container(
//           margin: const EdgeInsets.only(bottom: 16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 8,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // صورة العقار
//               ClipRRect(
//                 borderRadius:
//                     const BorderRadius.vertical(top: Radius.circular(16)),
//                 child: Stack(
//                   children: [
//                     Image.network(
//                       item["image"],
//                       height: 160,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                     Positioned(
//                       right: 8,
//                       top: 8,
//                       child: Container(
//                         padding:
//                             const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           item["status"],
//                           style: const TextStyle(color: Colors.white, fontSize: 12),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       left: 8,
//                       bottom: 8,
//                       child: Container(
//                         padding:
//                             const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.8),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           item["price"],
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, color: Colors.black87),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // النصوص + زر الحذف
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // تفاصيل العقار
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(Icons.location_on,
//                                   size: 16, color: Colors.blue),
//                               const SizedBox(width: 4),
//                               Expanded(
//                                 child: Text(
//                                   item["location"],
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 6),
//                           Text(
//                             item["title"],
//                             style: const TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 6),
//                           Row(
//                             children: [
//                               const Icon(Icons.star,
//                                   size: 16, color: Colors.orangeAccent),
//                               const SizedBox(width: 4),
//                               Text(item["rating"].toString(),
//                                   style: const TextStyle(fontSize: 14)),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     // زر الحذف
//                     IconButton(
//                       onPressed: () {
//                         setState(() {
//                           favorites.removeAt(index);
//                         });
//                       },
//                       icon: const Icon(Icons.delete, color: Colors.redAccent),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }

//   /// شريط التنقل السفلي
//   Widget _buildBottomNav() {
//     return BottomNavigationBar(
//       backgroundColor: Colors.white,
//       selectedItemColor: Colors.blue,
//       unselectedItemColor: Colors.black54,
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ""),
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
//       ],
//     );
//   }
// }
