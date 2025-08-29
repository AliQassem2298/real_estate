import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:real_estate/screens/map_picker.dart';
import 'package:real_estate/services/create_property_service.dart';
import 'package:real_estate/screens/Page/property_media.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  _AddPropertyScreenState createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final CreatePropertyService _createService = CreatePropertyService();

  List<XFile?> images = List.filled(6, null);
  File? ownershipDocument;

  // Backend-driven enums mapped to ids
  // type: ['cmmercial', 'residential', 'industrial', 'agricultural'] → ids 1..4 (example mapping)
  final Map<String, String> _typeLabelToId = const {
    'تجاري': '1',
    'سكني': '2',
    'صناعي': '3',
    'زراعي': '4',
  };
  final List<String> _typeOptions = const ['تجاري', 'سكني', 'صناعي', 'زراعي'];

  // subtype enum mapping
  final Map<String, String> _subtypeLabelToId = const {
    'بيت': '1',
    'شقة': '2',
    'أرض': '3',
    'فيلا': '4',
    'معمل': '5',
    'مكتب': '6',
    'محل': '7',
    'فندق': '8',
    'مطعم': '9',
    'مستودع': '10',
    'مزرعة': '11',
    'بيت زجاجي': '12',
  };
  final List<String> _subtypeOptions = const [
    'بيت',
    'شقة',
    'أرض',
    'فيلا',
    'معمل',
    'مكتب',
    'محل',
    'فندق',
    'مطعم',
    'مستودع',
    'مزرعة',
    'بيت زجاجي'
  ];

  // status: 'rent' or 'sale'
  final Map<String, String> _statusLabelToValue = const {
    'للبيع': 'sale',
    'إيجار': 'rent',
    'محجوز': 'reserved',
  };
  final List<String> _statusOptions = const ['للبيع', 'إيجار', 'محجوز'];

  String? selectedTypeLabel;
  String? selectedSubtypeLabel;
  String? selectedStatusLabel;
  String? selectedRooms;
  String? selectedFloors;

  String? _latitude;
  String? _longitude;

  // boolean features
  bool hasPool = false;
  bool hasGarden = false;
  bool hasElevator = false;
  bool solarEnergy = false;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController nearbyServicesController =
      TextEditingController();
  final TextEditingController featuresController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> _openMapPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MapPicker()),
    );
    if (result is Map && result['lat'] != null && result['lng'] != null) {
      setState(() {
        _latitude = result['lat'].toString();
        _longitude = result['lng'].toString();
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final typeId = _typeLabelToId[selectedTypeLabel];
    final subtypeId = _subtypeLabelToId[selectedSubtypeLabel];
    final status = _statusLabelToValue[selectedStatusLabel];

    if (typeId == null || subtypeId == null || status == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار النوع والفرع والحالة')),
      );
      return;
    }

    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تحديد الموقع من الخريطة')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final created = await _createService.createProperty(
        typeId: typeId,
        subtypeId: subtypeId,
        title: titleController.text.trim(),
        status: status,
        description: descriptionController.text.trim(),
        price: priceController.text.trim(),
        area: areaController.text.trim(),
        floor: selectedFloors,
        roomsCount: selectedRooms,
        latitude: _latitude!,
        longitude: _longitude!,
        hasPool: hasPool,
        hasGarden: hasGarden,
        hasElevator: hasElevator,
        solarEnergy: solarEnergy,
        features: featuresController.text.trim().isEmpty
            ? null
            : featuresController.text.trim(),
        nearbyServices: nearbyServicesController.text.trim().isEmpty
            ? null
            : nearbyServicesController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context); // close loading

      // Show success and route
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('تم إنشاء العقار'),
          content: const Text(
              'تم إرسال طلبك إلى الأدمن. عند الموافقة سيظهر ضمن عقاراتك.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً'),
            )
          ],
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('pending_approval', true);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PropertyMediaPage(propertyId: created.property.id)),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل الإرسال: $e')),
      );
    }
  }

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
                title: 'العنوان',
                controller: titleController,
              ),
              buildUnifiedField(
                title: 'النوع',
                options: _typeOptions,
                selectedValue: selectedTypeLabel,
                onChanged: (val) => setState(() => selectedTypeLabel = val),
              ),
              buildUnifiedField(
                title: 'الفرع',
                options: _subtypeOptions,
                selectedValue: selectedSubtypeLabel,
                onChanged: (val) => setState(() => selectedSubtypeLabel = val),
              ),
              buildUnifiedField(
                title: 'الحالة',
                options: _statusOptions,
                selectedValue: selectedStatusLabel,
                onChanged: (val) => setState(() => selectedStatusLabel = val),
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
                  onTap: _openMapPicker,
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.blue.shade300),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _latitude != null && _longitude != null
                              ? '($_latitude, $_longitude)'
                              : 'ادخل موقع العقار',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
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
                  controller: nearbyServicesController),
              buildUnifiedField(
                  title: 'المميزات', controller: featuresController),
              buildUnifiedField(
                  title: 'الوصف', controller: descriptionController),

              const SizedBox(height: 12),
              // boolean features
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: hasPool,
                      onChanged: (v) => setState(() => hasPool = v ?? false),
                      title: const Text('مسبح'),
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: hasGarden,
                      onChanged: (v) => setState(() => hasGarden = v ?? false),
                      title: const Text('حديقة'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: hasElevator,
                      onChanged: (v) =>
                          setState(() => hasElevator = v ?? false),
                      title: const Text('مصعد'),
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: solarEnergy,
                      onChanged: (v) =>
                          setState(() => solarEnergy = v ?? false),
                      title: const Text('طاقة شمسية'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
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
          ? _DropdownTile(
              title: title,
              options: options,
              selectedValue: selectedValue,
              onChanged: onChanged,
            )
          : TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: title,
                border: InputBorder.none,
                hintText: 'أدخل $title',
              ),
              validator: (v) {
                if (controller == titleController ||
                    controller == priceController ||
                    controller == areaController) {
                  if (v == null || v.trim().isEmpty) {
                    return 'هذا الحقل مطلوب';
                  }
                }
                return null;
              },
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

class _DropdownTile extends StatefulWidget {
  final String title;
  final List<String> options;
  final String? selectedValue;
  final Function(String?)? onChanged;
  const _DropdownTile(
      {required this.title,
      required this.options,
      this.selectedValue,
      this.onChanged});

  @override
  State<_DropdownTile> createState() => _DropdownTileState();
}

class _DropdownTileState extends State<_DropdownTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: _expanded,
      onExpansionChanged: (v) => setState(() => _expanded = v),
      title: Text(
        widget.selectedValue ?? widget.title,
        style:
            const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
      ),
      children: widget.options.map((option) {
        return ListTile(
          title: Text(option),
          onTap: () {
            widget.onChanged?.call(option);
            setState(() => _expanded = false);
          },
        );
      }).toList(),
    );
  }
}
