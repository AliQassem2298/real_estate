// import 'package:flutter/material.dart';

// class NotificationsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("الإشعارات")),
//       body: Center(child: Text("محتوى صفحة الإشعارات")),
//     );
//   }
// }

import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // بيانات تجريبية
  List<Map<String, dynamic>> notifications = [
    {"section": "اليوم", "content": "محتوى الإشعار"},
    {"section": "اليوم", "content": "محتوى الإشعار"},
    {"section": "اليوم", "content": "محتوى الإشعار"},
    {"section": "منذ مدة", "content": "محتوى الإشعار"},
    {"section": "منذ مدة", "content": "محتوى الإشعار"},
    {"section": "منذ مدة", "content": "محتوى الإشعار"},
  ];

  @override
  Widget build(BuildContext context) {
    // تقسيم الإشعارات حسب القسم
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var item in notifications) {
      grouped.putIfAbsent(item["section"], () => []);
      grouped[item["section"]]!.add(item);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F0F0),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF1F0F0),
        centerTitle: true,
        title: const Text(
          "الإشعارات",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.black54),
            onPressed: () {
              setState(() {
                notifications.clear();
              });
            },
          ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : _buildNotificationsList(grouped),
    );
  }

  /// واجهة في حال لا يوجد إشعارات
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            padding: const EdgeInsets.all(24),
            child: const Icon(Icons.info, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 20),
          const Text(
            "لا يوجد إشعارات",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  /// واجهة عرض الإشعارات
  Widget _buildNotificationsList(
      Map<String, List<Map<String, dynamic>>> grouped) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.key,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: entry.value.map((notif) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications,
                          color: Colors.blue, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          notif["content"],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }
}
