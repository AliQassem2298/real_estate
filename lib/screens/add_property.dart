import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:real_estate/screens/Submission_Success.dart';
import 'package:real_estate/screens/map_picker.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  _AddPropertyScreenState createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  List<XFile?> images = List.filled(6, null);
  File? ownershipDocument;

  String? selectedType;
  String? selectedOwnership;
  String? selectedStatus;
  String? selectedRooms;
  String? selectedFloors;

  final TextEditingController priceController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController nearbyServicesController =
      TextEditingController();
  final TextEditingController featuresController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة عقار')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildUnifiedField(
                title: 'النوع',
                options: ['شقة', 'فيلا', 'أرض'],
                selectedValue: selectedType,
                onChanged: (val) => setState(() => selectedType = val),
              ),
              buildUnifiedField(
                title: 'الملكية',
                options: ['تمليك', 'إيجار', 'استثمار'],
                selectedValue: selectedOwnership,
                onChanged: (val) => setState(() => selectedOwnership = val),
              ),
              buildUnifiedField(
                title: 'الحالة',
                options: ['جديد', 'مستعمل', 'قيد الإنشاء'],
                selectedValue: selectedStatus,
                onChanged: (val) => setState(() => selectedStatus = val),
              ),
              buildUnifiedField(
                title: 'عدد الغرف',
                options: ['1', '2', '3', '4', '5+'],
                selectedValue: selectedRooms,
                onChanged: (val) => setState(() => selectedRooms = val),
              ),
              buildUnifiedField(
                title: 'الطوابق',
                options: ['أرضي', 'أول', 'ثاني', 'أكثر'],
                selectedValue: selectedFloors,
                onChanged: (val) => setState(() => selectedFloors = val),
              ),
              const SizedBox(height: 12),
              const Text('الموقع',
                  style: TextStyle(fontWeight: FontWeight.bold)),

              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MapPicker()),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.blue.shade300),
                      const SizedBox(width: 10),
                      const Text(
                        'ادخل موقع العقار',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // حقول نصية بنفس التصميم
              buildUnifiedField(title: 'السعر', controller: priceController),
              buildUnifiedField(title: 'المساحة', controller: areaController),
              buildUnifiedField(
                title: 'الخدمات القريبة',
                controller: nearbyServicesController,
              ),
              buildUnifiedField(
                title: 'المميزات',
                controller: featuresController,
              ),
              const SizedBox(height: 16),
              const Text('مستندات الملكية أو صورة عن الهوية'),

              ElevatedButton.icon(
                onPressed: pickDocument,
                icon: Icon(Icons.image,
                    color: Colors.blue.shade300), // أيقونة المعرض
                label: const Text('اضغط لاختيار الملف (صورة أو PDF)'),
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: Colors.blue, // لون الزر (اختياري)
                // ),
              ),

              if (ownershipDocument != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'تم اختيار الملف: ${ownershipDocument!.path.split('/').last}',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),

              const SizedBox(height: 16),
              const Text('أضف ثلاث صور على الأقل'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(6, (index) {
                  return GestureDetector(
                    onTap: () => pickImage(index),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: images[index] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(images[index]!.path),
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.add,
                              color: Colors.blue.shade300,
                            ), // ✅ لون أزرق هنا
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SubmissionSuccess()),
                  );
                },
                child: const Text('تأكيد'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUnifiedField({
    required String title,
    List<String>? options,
    TextEditingController? controller,
    String? selectedValue,
    Function(String?)? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: options != null
          ? ExpansionTile(
              title: Text(
                selectedValue ?? title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              children: options.map((option) {
                return ListTile(
                  title: Text(option),
                  onTap: () => onChanged?.call(option),
                );
              }).toList(),
            )
          : TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: title,
                border: InputBorder.none,
                hintText: 'أدخل $title',
              ),
            ),
    );
  }

  Future<void> pickImage(int index) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => images[index] = picked);
    }
  }

  Future<void> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        ownershipDocument = File(result.files.single.path!);
      });
    }
  }
}
