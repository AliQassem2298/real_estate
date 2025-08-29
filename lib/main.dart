import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:real_estate/constans/routes.dart';
import 'package:real_estate/screens/auth/login.dart';
import 'package:real_estate/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:real_estate/screens/profile.dart';

SharedPreferences? sharedPreferences;

Future<void> clearUserSession() async {
  await sharedPreferences?.clear();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool hasToken = sharedPreferences?.getString('token') != null;
    return MaterialApp(
      title: 'تطبيق العقارات',
      debugShowCheckedModeBanner: false,
      // locale: const Locale('ar'),
      // supportedLocales: const [
      //   Locale('ar'),
      // ],
      localizationsDelegates: const [
        // GlobalMaterialLocalizations.delegate,
        // GlobalWidgetsLocalizations.delegate,
        // GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: hasToken ? const Home() : const Login(),
      routes: routes,
    );
  }
}
