import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate/constans/routes.dart';
import 'package:real_estate/crud.dart';
import 'package:real_estate/function/validators.dart';
import 'package:real_estate/widgets/auth/bottum_go.dart';
import 'package:real_estate/widgets/auth/bouttom_auth.dart';
import '../../blocs/auth/signup/signup_cubit.dart';
import '../../blocs/auth/signup/signup_state.dart';
import '../../widgets/auth/custom_input_field.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final passwordConfirmation = TextEditingController();
  final phoneNumber = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    passwordConfirmation.dispose();
    phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(Crud()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            print("🔄 BlocListener state: $state");

            if (state is SignupSuccess) {
              print(" Navigating to verification screen with email: ${state.email}");

              Navigator.of(context).pushReplacementNamed(
                AppRoute.verify,
                arguments: state.email,
              );
            } else if (state is SignupFailure) {
              print(" Signup failed: ${state.error}");

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is SignupLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [

                    const SizedBox(height: 30),

                    const Center(
                      child: Text(
                        'إنشاء حساب',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    CustomInputField(
                      controller: name,
                      label: 'اسم المستخدم',
                      hintText: 'ادخل اسمك',
                      icon: Icons.person,
                      validator: Validators.validateName,
                    ),

                    const SizedBox(height: 20),

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

                    const SizedBox(height: 20),

                    CustomInputField(
                      controller: passwordConfirmation,
                      label: 'تأكيد كلمة المرور',
                      hintText: 'اعد إدخال كلمة المرور',
                      icon: Icons.lock,
                      isPassword: true,
                      validator: (value) =>
                          Validators.validatePasswordConfirmation(value, password.text),
                    ),

                    const SizedBox(height: 20),

                    CustomInputField(
                      controller: phoneNumber,
                      label: 'رقم الهاتف',
                      hintText: 'ادخل رقم الهاتف',
                      icon: Icons.phone_android,
                      validator: Validators.validatePhone,
                    ),

                    const SizedBox(height: 30),

                    BottumAuth(
                      title: "انشاء حساب",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<SignupCubit>(context).signUp(
                            name: name.text,
                            email: email.text,
                            password: password.text,
                            passwordConfirmation: passwordConfirmation.text,
                            phoneNumber: phoneNumber.text,
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    BottumGo(
                      questionText: "لديك حساب ؟ ",
                      actionText: "تسجيل الدخول",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Login()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
