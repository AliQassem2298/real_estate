import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_estate/services/Add_Image_service.dart';
import 'package:real_estate/services/Add_Document_service.dart';
import 'package:real_estate/screens/home.dart';

class PropertyMediaPage extends StatefulWidget {
  final int propertyId;
  const PropertyMediaPage({super.key, required this.propertyId});

  @override
  State<PropertyMediaPage> createState() => _PropertyMediaPageState();
}

class _PropertyMediaPageState extends State<PropertyMediaPage> {
  final AddImageService _imageService = AddImageService();
  final AddDocumentService _documentService = AddDocumentService();

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  File? _pickedDoc;
  final TextEditingController _docTypeController = TextEditingController();

  bool _uploadedImage = false;
  bool _uploadedDoc = false;

  void _maybeFinish() {
    if (_uploadedImage && _uploadedDoc && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const Home()),
        (route) => false,
      );
    }
  }

  Future<void> _pickImage() async {
    final img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() => _pickedImage = img);
    }
  }

  Future<void> _uploadImage() async {
    if (_pickedImage == null) return;
    try {
      await _imageService.addImage(
        propertyId: widget.propertyId,
        filePath: _pickedImage!.path,
        fileName: _pickedImage!.name,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم رفع الصورة')),
      );
      setState(() {
        _pickedImage = null;
        _uploadedImage = true;
      });
      _maybeFinish();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل رفع الصورة: $e')),
      );
    }
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _pickedDoc = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadDocument() async {
    if (_pickedDoc == null || _docTypeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختر ملف وأدخل نوع المستند')),
      );
      return;
    }
    try {
      await _documentService.addDocument(
        propertyId: widget.propertyId,
        filePath: _pickedDoc!.path,
        fileName: _pickedDoc!.path.split('/').last,
        documentType: _docTypeController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم رفع المستند')),
      );
      setState(() {
        _pickedDoc = null;
        _docTypeController.clear();
        _uploadedDoc = true;
      });
      _maybeFinish();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل رفع المستند: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('رفع صور ومستندات')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('صور العقار'),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo),
                  label: const Text('اختيار صورة'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _uploadImage,
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('رفع الصورة'),
                ),
              ],
            ),
            if (_pickedImage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('تم اختيار: ${_pickedImage!.name}'),
              ),
            const Divider(height: 32),
            const Text('مستندات الملكية'),
            const SizedBox(height: 8),
            TextField(
              controller: _docTypeController,
              decoration: const InputDecoration(
                labelText: 'نوع المستند (مثال: هوية، سند ملكية)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickDocument,
                  icon: const Icon(Icons.description),
                  label: const Text('اختيار مستند'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _uploadDocument,
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('رفع المستند'),
                ),
              ],
            ),
            if (_pickedDoc != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('تم اختيار: ${_pickedDoc!.path.split('/').last}'),
              ),
          ],
        ),
      ),
    );
  }
}
