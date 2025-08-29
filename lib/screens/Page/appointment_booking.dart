// screens/appointment_booking_page.dart

import 'package:flutter/material.dart';
import 'package:real_estate/models/List_Mediators_model.dart';
import 'package:real_estate/services/List_Mediators_service.dart';
import 'package:real_estate/services/appointment_service.dart';
import 'package:real_estate/constans/color.dart';
import 'package:intl/intl.dart';

class AppointmentBookingPage extends StatefulWidget {
  final int propertyId;
  final String propertyTitle;

  const AppointmentBookingPage({
    super.key,
    required this.propertyId,
    required this.propertyTitle,
  });

  @override
  State<AppointmentBookingPage> createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
  final ListMediatorsService _mediatorsService = ListMediatorsService();
  final AppointmentService _appointmentService = AppointmentService();
  late Future<List<MediatorModel>> _mediatorsFuture;

  @override
  void initState() {
    super.initState();
    _mediatorsFuture = _mediatorsService.listMediators();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "حجز موعد - ${widget.propertyTitle}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColor.blue,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<MediatorModel>>(
        future: _mediatorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.blue),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    "حدث خطأ في تحميل البيانات",
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${snapshot.error}",
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _mediatorsFuture = _mediatorsService.listMediators();
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("إعادة المحاولة"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("لا توجد مكاتب وسيطة متاحة"));
          }

          final mediators = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _mediatorsFuture = _mediatorsService.listMediators();
              });
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mediators.length,
              itemBuilder: (context, index) {
                final mediator = mediators[index];
                return _buildMediatorCard(mediator);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMediatorCard(MediatorModel mediator) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: AppColor.blue.withOpacity(0.1),
          child: const Icon(Icons.business, color: AppColor.blue),
        ),
        title: Text(
          mediator.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mediator.location,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            Text(
              mediator.contactInfo,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "المواعيد (${mediator.appointments.length})",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showBookAppointmentDialog(mediator),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text("حجز موعد"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (mediator.appointments.isEmpty)
                  _buildEmptyAppointments()
                else
                  ...mediator.appointments
                      .map((appointment) => _buildAppointmentCard(appointment)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAppointments() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule, color: Colors.grey[400], size: 20),
          const SizedBox(width: 8),
          Text(
            "لا توجد مواعيد محجوزة",
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: AppColor.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "التاريخ: ${appointment.date}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 14),
                ),
                Text(
                  "الوقت: ${appointment.time}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(appointment.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getStatusText(appointment.status),
              style: TextStyle(
                fontSize: 12,
                color: _getStatusColor(appointment.status),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColor.blue;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'مؤكد';
      case 'pending':
        return 'في الانتظار';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }

  void _showBookAppointmentDialog(MediatorModel mediator) {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.add_circle, color: AppColor.blue),
              const SizedBox(width: 8),
              Text(
                "حجز موعد مع ${mediator.name}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // اختيار التاريخ
              ListTile(
                leading: const Icon(Icons.calendar_today, color: AppColor.blue),
                title: const Text("التاريخ"),
                subtitle: Text(
                  DateFormat('yyyy-MM-dd').format(selectedDate),
                  style: TextStyle(color: Colors.grey[600]),
                ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null && picked != selectedDate) {
                    setDialogState(() {
                      selectedDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              // اختيار الوقت (بدون AM/PM نهائيًا)
              ListTile(
                leading: const Icon(Icons.access_time, color: AppColor.blue),
                title: const Text("الوقت"),
                subtitle: Text(
                  // ✅ عرض الوقت بتنسيق 24 ساعة: 10:10
                  '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                    builder: (context, child) {
                      // ✅ تفعيل التنسيق 24 ساعة في الـ picker
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setDialogState(() {
                      selectedTime = picked;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      setDialogState(() => isLoading = true);

                      try {
                        // ✅ إرسال الوقت بتنسيق 24 ساعة فقط: مثل 10:10
                        final String formattedTime =
                            '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';

                        await _appointmentService.createAppointment(
                          mediatorId: mediator.id,
                          propertyId: widget.propertyId,
                          date: DateFormat('yyyy-MM-dd').format(selectedDate),
                          time: formattedTime, // ✅ بدون AM/PM
                        );

                        Navigator.pop(context);

                        setState(() {
                          _mediatorsFuture = _mediatorsService.listMediators();
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("تم حجز الموعد بنجاح"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        setDialogState(() => isLoading = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("خطأ: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.blue,
                foregroundColor: Colors.white,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("حجز"),
            ),
          ],
        ),
      ),
    );
  }
}
