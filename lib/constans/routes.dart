import 'package:flutter/cupertino.dart';
import '../screens/auth/login.dart';
import '../screens/auth/signup.dart';
import '../screens/auth/verify.dart';
import '../screens/home.dart';
import '../screens/onboarding/splash.dart';

class AppRoute{

  static const String splash = "/splash";
  static const String login = "/login";
  static const String signUp = "/signup";
  static const String verify = "/verify";
  static const String home = "/home";

}


Map<String, Widget Function(BuildContext)>routes={

  AppRoute.splash : (context) => const SplashOrOnboarding(),

  AppRoute.login : (context) => const Login(),
  AppRoute.signUp : (context) => const Signup(),
  AppRoute.verify : (context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;
    return Verification(email: email);
  },
  AppRoute.home : (context) =>  const Home(),



};