import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate/constans/image_url.dart';
import 'package:real_estate/crud.dart';
import 'package:real_estate/function/validators.dart';
import 'package:real_estate/screens/auth/forget_password/resetpassword.dart';
import 'package:real_estate/screens/auth/signup.dart';
import 'package:real_estate/widgets/auth/bottum_go.dart';
import 'package:real_estate/widgets/auth/bouttom_auth.dart';
import '../../blocs/auth/login/login_cubit.dart';
import '../../blocs/auth/login/login_state.dart';
import '../../constans/color.dart';
import '../../constans/routes.dart';
import '../../widgets/auth/custom_input_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(Crud()),
      child: Scaffold(
        // appBar: AppBar(
        //   actions: [
        //     IconButton(
        //         onPressed: () async {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(builder: (context) => const Home()),
        //           );
        //           print("${sharedPreferences!.getString("token")}");
        //         },
        //         icon: const Icon(Icons.abc))
        //   ],
        // ),
        backgroundColor: Colors.white,
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRoute.home, (route) => false);
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is LoginLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Image.asset(AppImageAsset.login),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  // <-- أضف Form هنا
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomInputField(
                        controller: email,
                        label: 'البريد الإلكتروني',
                        hintText: 'ادخل بريدك الإلكتروني',
                        icon: Icons.email,
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 20),
                      CustomInputField(
                        controller: password,
                        label: 'كلمة المرور',
                        hintText: 'ادخل كلمة المرور',
                        icon: Icons.lock,
                        isPassword: true,
                        validator: Validators.validatePassword,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const Resetpassword()),
                      );
                    },
                    child: const Text(
                      'هل نسيت كلمة المرور؟',
                      style: TextStyle(
                        color: AppColor.grey2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                BottumAuth(
                  title: "تسجيل الدخول",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      BlocProvider.of<LoginCubit>(context).login(
                        email: email.text,
                        password: password.text,
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                BottumGo(
                  questionText: "ليس لديك حساب؟ ",
                  actionText: "إنشاء حساب",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Signup()),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
