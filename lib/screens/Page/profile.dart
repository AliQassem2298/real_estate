import 'package:flutter/material.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/models/Profile_model.dart';
import 'package:real_estate/screens/auth/login.dart';
import 'package:real_estate/screens/home.dart';
import 'package:real_estate/services/Delete_Account_service.dart';
import 'package:real_estate/services/profile_service.dart';
import 'package:real_estate/widgets/auth/custom_input_field.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<ProfileModel> _profileFuture;
  final ProfileService _profileService = ProfileService();

  void _showDeleteAccountDialog(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "تأكيد حذف الحساب",
            style: TextStyle(color: Colors.red),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("هل أنت متأكد أنك تريد حذف حسابك؟"),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "البريد الإلكتروني",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "كلمة المرور",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // إلغاء
              },
              child: const Text("إلغاء"),
            ),
            TextButton(
              onPressed: () async {
                if (emailController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("يرجى تعبئة جميع الحقول")),
                  );
                  return;
                }

                // إغلاق الـ dialog
                Navigator.pop(dialogContext);

                // إظهار تحميل
                _showLoadingDialog(context);

                try {
                  final service = DeleteAccountService();
                  final result = await service.deleteAccount(
                    email: emailController.text.trim(),
                    password: passwordController.text,
                  );

                  // إغلاق نافذة التحميل
                  Navigator.pop(context); // إغلاق الـ loading dialog

                  // تحقق من أن الرسالة تدل على نجاح الحذف
                  if (result.message.toLowerCase().contains('success') ||
                      result.message.contains('تم') ||
                      result.message.contains('deleted')) {
                    _showSuccessDialog(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("خطأ: ${result.message}")),
                    );
                  }
                } catch (e) {
                  Navigator.pop(context); // إغلاق التحميل
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("فشل الاتصال: $e")),
                  );
                }
              },
              child: const Text("حذف", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("جاري حذف الحساب..."),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("تم الحذف بنجاح"),
          content:
              const Text("تم حذف حسابك بنجاح. سيتم توجيهك إلى شاشة التسجيل."),
          actions: [
            TextButton(
              onPressed: () async {
                // حذف كل البيانات
                await clearUserSession();
                // العودة إلى شاشة التسجيل
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ));
              },
              child: const Text("موافق"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _profileFuture = _profileService.profile(); // بدء جلب البيانات
  }

  // دالة لإعادة المحاولة
  void _retryFetch() {
    setState(() {
      _profileFuture = _profileService.profile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, "favorites");
          } else if (index == 1) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(),
                ));
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // السهم والعنوان
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.arrow_back_ios_new,
                          size: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "الملف الشخصي",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // أيقونة الملف
              const Icon(Icons.account_circle,
                  size: 100, color: Colors.black87),

              const SizedBox(height: 30),

              // عرض البيانات أو التحميل أو الخطأ
              Expanded(
                child: FutureBuilder<ProfileModel>(
                  future: _profileFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            Text("خطأ: ${snapshot.error}"),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _retryFetch,
                              child: const Text("إعادة المحاولة"),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final user = snapshot.data!.data;
                      return ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          CustomInputField(
                            label: "اسم المستخدم",
                            hintText: user.name,
                            icon: Icons.person,
                            controller: TextEditingController(text: user.name),
                            isReadOnly: true,
                          ),
                          const SizedBox(height: 16),
                          CustomInputField(
                            label: "البريد الإلكتروني",
                            hintText: user.email,
                            icon: Icons.email,
                            controller: TextEditingController(text: user.email),
                            isReadOnly: true,
                          ),
                          const SizedBox(height: 16),
                          CustomInputField(
                            label: "رقم الهاتف",
                            hintText: user.phoneNumber.toString(),
                            icon: Icons.phone,
                            controller: TextEditingController(
                                text: user.phoneNumber.toString()),
                            isReadOnly: true,
                          ),
                          const SizedBox(height: 16),
                          CustomInputField(
                            label: "حالة التحقق",
                            hintText:
                                user.isVerified ? "تم التحقق" : "غير محقق",
                            icon: Icons.verified,
                            controller: TextEditingController(
                              text: user.isVerified ? "تم التحقق" : "غير محقق",
                            ),
                            isReadOnly: true,
                          ),
                          const SizedBox(height: 16),
                          CustomInputField(
                            label: "تاريخ الإنشاء",
                            hintText:
                                '${user.createdAt.year}-${user.createdAt.month}-${user.createdAt.day}',
                            icon: Icons.calendar_today,
                            controller: TextEditingController(
                              text:
                                  '${user.createdAt.year}-${user.createdAt.month}-${user.createdAt.day}',
                            ),
                            isReadOnly: true,
                          ),
                          const SizedBox(height: 16),
                          CustomInputField(
                            label: "تفاصيل الموقع",
                            hintText: user.location ?? "غير محدد",
                            icon: Icons.location_on,
                            controller: TextEditingController(
                                text: user.location ?? "غير محدد"),
                            isReadOnly: true,
                          ),
                        ],
                      );
                    }
                    return const Center(child: Text("لا توجد بيانات"));
                  },
                ),
              ),

              const SizedBox(height: 20),
              // زر حفظ (غير مفعل حاليًا)
              // BottumAuth(
              //   title: "حفظ",
              //   onPressed: () {
              //     // يمكن تفعيله لاحقًا للتعديل
              //   },
              // ),

              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  _showDeleteAccountDialog(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "حذف الحساب",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
