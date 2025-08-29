import 'package:flutter/material.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/screens/Page/MyPropertiesScreen.dart';
import 'package:real_estate/screens/auth/login.dart';
import 'package:real_estate/services/logout_service.dart';
import 'page/offices.dart';
// import 'page/comparison.dart';
import 'package:real_estate/screens/page/maintenance.dart';
import 'page/wallet.dart';
import 'page/banks.dart';

Drawer buildDrawer(BuildContext context) {
  return Drawer(
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('اسم المستخدم'),
            accountEmail: null,
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person, size: 40),
            ),
            decoration: BoxDecoration(color: Colors.blue.shade200),
          ),

          buildDrawerItem(
              Icons.home, 'عقاراتي', context, const MyPropertiesScreen(),
              iconColor: Colors.blue),
          // buildDrawerItem(Icons.notifications, 'الإشعارات', context,
          //     const NotificationsPage(),
          //     iconColor: Colors.blue),
          // buildDrawerItem(
          //     Icons.business, 'المكاتب الوسيطة', context, const OfficesPage(),
          //     iconColor: Colors.blue),
          // buildDrawerItem(
          //   Icons.compare_arrows,
          //   'المقارنة',
          //   context,
          //   ComparisonPage(),
          //   iconColor: Colors.blue
          // ),
          // buildDrawerItem(Icons.chat, 'المراسلة', context, const ChatListPage(),
          //     iconColor: Colors.blue),
          // buildDrawerItem(
          //     Icons.receipt_long, 'فواتيري', context, const InvoicesPage(),
          //     iconColor: Colors.blue),
          // buildDrawerItem(Icons.verified, 'العقارات المباعة', context,
          //     const SoldPropertiesPage(),
          //     iconColor: Colors.blue),
          buildDrawerItem(Icons.home_repair_service, 'ورشات الصيانة', context,
              const MaintenancePage(),
              iconColor: Colors.blue),
          buildDrawerItem(Icons.account_balance_wallet, 'محفظتي', context,
              const WalletPage(),
              iconColor: Colors.blue),
          // buildDrawerItem(
          //     Icons.account_balance, 'البنوك', context, const BanksPage(),
          //     iconColor: Colors.blue),
          // buildDrawerItem(Icons.filter_alt, 'بحث متقدم', context,
          //     const FilterPropertiesPage(),
          // iconColor: Colors.blue),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('تسجيل خروج'),
            onTap: () async {
              Navigator.of(context).pop(); // إغلاق الدرج

              // عرض نافذة تحميل
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => const AlertDialog(
                  content: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text("جاري تسجيل الخروج..."),
                    ],
                  ),
                ),
              );

              try {
                final service = LogoutService();
                await service.logout();

                // إغلاق التحميل
                Navigator.pop(context);

                // رسالة نجاح
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("تم تسجيل الخروج بنجاح ✅"),
                    backgroundColor: Colors.green,
                  ),
                );

                // حذف كل البيانات المحلية
                await clearUserSession();

                // التوجيه إلى الصفحة الرئيسية
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ));
              } catch (e) {
                Navigator.pop(context); // إغلاق التحميل

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("خطأ: $e"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    ),
  );
}

Widget buildDrawerItem(
  IconData icon,
  String title,
  BuildContext context,
  Widget page, {
  required Color
      iconColor, // استخدم Color بدلاً من MaterialColor لتكون أكثر مرونة
}) {
  return ListTile(
    leading: Icon(icon, color: iconColor), // أضف اللون هنا
    title: Text(title),
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
    },
  );
}
