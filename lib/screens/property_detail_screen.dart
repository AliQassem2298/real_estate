import 'package:flutter/material.dart';
import 'package:real_estate/constans/image_url.dart';
import 'package:real_estate/helper/api.dart';
import 'package:real_estate/models/property_models.dart';
import 'package:real_estate/screens/Page/appointment_booking.dart';
import 'package:real_estate/screens/Page/reservations_and_payments.dart';
import 'package:real_estate/services/Public_Show_Approved_service.dart';
import 'package:real_estate/screens/home.dart';
import 'package:real_estate/screens/Page/ratings.dart';

class PropertyDetailScreen extends StatefulWidget {
  final int propertyId;

  const PropertyDetailScreen({super.key, required this.propertyId});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  Widget _imageWidget(String? url,
      {double? height, double? width, BoxFit? fit}) {
    if (url == null || url.isEmpty) {
      return Image.asset(
        AppImageAsset.onboarding1,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
      );
    }

    if (url.startsWith('assets/') || url.startsWith('file://')) {
      return Image.asset(
        url,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          AppImageAsset.onboarding1,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
        ),
      );
    }

    return Image.network(
      url,
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          AppImageAsset.onboarding1,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
        );
      },
    );
  }

  final PublicShowApprovedService _service = PublicShowApprovedService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PublicShowApprovedModel>(
        future: _service.publicShowApproved(id: widget.propertyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 60),
                  Text("خطأ: ${snapshot.error}", textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text("إعادة المحاولة"),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data?.data == null) {
            return const Center(child: Text("لا توجد بيانات"));
          }

          final property = snapshot.data!.data;

          return _buildPropertyDetailView(property);
        },
      ),
    );
  }

  Widget _buildPropertyDetailView(PropertyModel property) {
    return CustomScrollView(
      slivers: [
        // SliverAppBar مع الصورة
        SliverAppBar(
          automaticallyImplyLeading: false,
          expandedHeight: 300,
          pinned: true,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                _imageWidget(
                  property.images.isNotEmpty
                      ? '$baseUrlImage${property.images[0].imagePath}'
                      : null,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.4),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        if (!mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const Home()),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // محتوى التفاصيل
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // العنوان والسعر
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      property.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "${property.price} ريال",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // الحالة (Chip)
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text(
                    property.status == 'sale'
                        ? 'للبيع'
                        : property.status == 'rent'
                            ? 'للإيجار'
                            : 'محجوز',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: property.status == 'sale'
                      ? Colors.green
                      : property.status == 'rent'
                          ? Colors.orange
                          : Colors.grey,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),

              const SizedBox(height: 16),

              // الوصف
              Text(
                property.description,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.justify,
                softWrap: true,
              ),

              const SizedBox(height: 20),

              // التفاصيل
              _buildDetailsSection(property),

              const SizedBox(height: 20),

              // الميزات (كـ Chips)
              _buildFeaturesChips(property.features),

              const SizedBox(height: 20),

              // الصور
              _buildImagesGrid(property),

              const SizedBox(height: 20),

              // المستندات
              _buildDocumentsList(property),

              const SizedBox(height: 20),

              // أزرار الإجراءات
              _buildActionButtons(property),

              const SizedBox(height: 16),

              // زر التقييمات
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RatingsPage(propertyId: property.id),
                      ),
                    );
                  },
                  icon: const Icon(Icons.rate_review, size: 18),
                  label: const Text("عرض التقييمات"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(PropertyModel property) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _detailRow(Icons.space_bar, 'المساحة', '${property.area} م²'),
            _detailRow(
                Icons.bed, 'الغرف', '${property.roomsCount ?? 'غير محدد'}'),
            _detailRow(Icons.stacked_bar_chart, 'الطابق',
                '${property.floor ?? 'غير محدد'}'),
            _detailRow(Icons.home, 'النوع', property.type.type),
            _detailRow(Icons.category, 'الفرع', property.subtype.subtype),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blue),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesChips(String? features) {
    if (features == null || features.trim().isEmpty)
      return const SizedBox.shrink();

    final List<String> featureList = features
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (featureList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الميزات',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: featureList.map((feature) {
            return Chip(
              label: Text(
                feature,
                style: const TextStyle(fontSize: 13),
              ),
              backgroundColor: Colors.blue.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.blue, width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildImagesGrid(PropertyModel property) {
    if (property.images.length < 2) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الصور الإضافية',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 4 / 3,
          ),
          itemCount: property.images.length - 1,
          itemBuilder: (context, index) {
            final image = property.images[index + 1];
            return GestureDetector(
              onTap: () {
                _showFullScreenImage('$baseUrlImage${image.imagePath}');
              },
              child: Hero(
                tag: 'image_$index',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _imageWidget(
                    '$baseUrlImage${image.imagePath}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showFullScreenImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: InteractiveViewer(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (_, __, ___) => const Padding(
              padding: EdgeInsets.all(16),
              child: Text("لا يمكن تحميل الصورة"),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentsList(PropertyModel property) {
    if (property.documents.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المستندات',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: property.documents.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final doc = property.documents[index];
            final docUrl = '$baseUrlImage${doc.filePath}';
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(docUrl),
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.insert_drive_file, color: Colors.white),
              ),
              title: Text(doc.documentType),
              subtitle: Text(doc.filePath.split('/').last),
              trailing: const Icon(Icons.open_in_new, size: 18),
              onTap: () => _showFullScreenImage(docUrl),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons(PropertyModel property) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          // حجز موعد
          _buildActionButton(
            icon: Icons.schedule,
            text: "حجز موعد مع مكتب وسيط",
            color: Colors.green,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AppointmentBookingPage(
                    propertyId: property.id,
                    propertyTitle: property.title,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          // الحجوزات والدفعات
          _buildActionButton(
            icon: Icons.payment,
            text: "حجوزات ودفعات العقار",
            color: Colors.orange,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReservationsAndPaymentsPage(
                    propertyId: property.id,
                    propertyTitle: property.title,
                    propertyPrice: property.price.toString(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(text, style: const TextStyle(fontSize: 14)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
          animationDuration: const Duration(milliseconds: 200),
        ),
      ),
    );
  }
}
