import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_estate/services/Upload_Document_service.dart';

class DocumentUploadScreen extends StatefulWidget {
  final int reservationId;

  const DocumentUploadScreen({super.key, required this.reservationId});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final OwnershipDocumentService _service = OwnershipDocumentService();
  bool _uploading = false;

  Future<void> _pickAndUploadDocument() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      _uploading = true;
    });

    try {
      final document = await _service.uploadDocument(
        reservationId: widget.reservationId,
        filePath: pickedFile.path,
        fileName: 'document_${DateTime.now().millisecondsSinceEpoch}.pdf',
        documentType: 'عقد ملكية',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تم رفع الوثيقة: ${document.id}")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("خطأ: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _uploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("رفع وثيقة")),
      body: Center(
        child: _uploading
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                onPressed: _pickAndUploadDocument,
                icon: const Icon(Icons.upload),
                label: const Text("اختر وارفع وثيقة"),
              ),
      ),
    );
  }
}
