// import 'package:flutter/material.dart';

// class InvoicesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("فواتيري")),
//       body: Center(child: Text("محتوى صفحة الفواتير")),
//     );
//   }
// }


import 'package:flutter/material.dart';

class InvoicesPage extends StatelessWidget {
  const InvoicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F0EE),
      appBar: AppBar(
        title: const Text("الفواتير"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            InvoiceCard(
              title: "فيلا",
              location: "دمشق، برامكة",
              rating: 4.9,
              price: "15 مليار ل.س",
              imageUrl:
                  "https://images.unsplash.com/photo-1560185008-5bf9f284948f", // صورة عشوائية
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InvoiceDetailsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class InvoiceCard extends StatelessWidget {
  final String title;
  final String location;
  final double rating;
  final String price;
  final String imageUrl;
  final VoidCallback onTap;

  const InvoiceCard({
    super.key,
    required this.title,
    required this.location,
    required this.rating,
    required this.price,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(location,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(rating.toString(),
                          style: const TextStyle(color: Colors.grey)),
                      const Spacer(),
                      Text(price,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
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

class InvoiceDetailsPage extends StatelessWidget {
  const InvoiceDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F0EE),
      appBar: AppBar(
        title: const Text("الفاتورة"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            PdfTile(title: "الدفعة الأولى"),
            SizedBox(height: 12),
            PdfTile(title: "الدفعة النهائية"),
          ],
        ),
      ),
    );
  }
}

class PdfTile extends StatelessWidget {
  final String title;

  const PdfTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: const Icon(Icons.picture_as_pdf, color: Colors.black),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      trailing: const Text("pdf", style: TextStyle(color: Colors.grey)),
      onTap: () {
        // هنا تقدر تفتح ملف PDF فعلي
      },
    );
  }
}
