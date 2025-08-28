import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate/blocs/auth/login/login_cubit.dart';
import 'package:real_estate/blocs/auth/login/login_state.dart';
import 'package:real_estate/constans/image_url.dart';
import 'package:real_estate/crud.dart';
import 'package:real_estate/function/validators.dart';
import 'package:real_estate/screens/auth/login.dart';
import 'package:real_estate/widgets/auth/bouttom_auth.dart';
import 'package:real_estate/widgets/auth/custom_input_field.dart';

class Resetpassword extends StatefulWidget {
  const Resetpassword({super.key});

  @override
  State<Resetpassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<Resetpassword> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool otpSent = false;

  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(Crud()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("home", (route) => false);
            } else if (state is LoginFailure) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            }
          },
          builder: (context, state) {
            final cubit = context.read<LoginCubit>();

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Image.asset(AppImageAsset.login),
                ),
                const SizedBox(height: 10),
                const Text(
                  'تغيير كلمة المرور',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // --- المرحلة 1: إدخال الإيميل ---
                if (!otpSent)
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomInputField(
                          controller: emailController,
                          label: 'البريد الإلكتروني',
                          hintText: 'أدخل بريدك الإلكتروني',
                          icon: Icons.email,
                          validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: 30),
                        state is LoginLoading
                            ? const Center(child: CircularProgressIndicator())
                            : BottumAuth(
                                title: "إرسال الرمز",
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final result = await cubit.forgetPassword(
                                      email: emailController.text.trim(),
                                    );

                                    if (result['success'] == true) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "تم إرسال رمز التحقق إلى بريدك"),
                                          ),
                                        );
                                        setState(() {
                                          otpSent = true;
                                        });
                                      }
                                    } else {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(result['message'])),
                                        );
                                      }
                                    }
                                  }
                                },
                              ),
                      ],
                    ),
                  ),

                // --- المرحلة 2: إدخال OTP وكلمة السر ---
                if (otpSent)
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          'تم إرسال الرمز إلى: ${emailController.text}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        CustomInputField(
                          controller: otpController,
                          label: 'رمز التحقق (OTP)',
                          hintText: 'أدخل الرمز المكون من 4 أرقام',
                          icon: Icons.numbers,
                          validator: Validators.validateOTP,
                        ),
                        const SizedBox(height: 20),
                        CustomInputField(
                          controller: passwordController,
                          label: 'كلمة المرور الجديدة',
                          hintText: 'أدخل كلمة المرور الجديدة',
                          icon: Icons.lock,
                          isPassword: true,
                          validator: Validators.validatePassword,
                        ),
                        const SizedBox(height: 20),
                        CustomInputField(
                          controller: confirmPasswordController,
                          label: 'تأكيد كلمة المرور',
                          hintText: 'أعد إدخال كلمة المرور',
                          icon: Icons.lock,
                          isPassword: true,
                          validator: (value) =>
                              Validators.validatePasswordConfirmation(
                            value,
                            passwordController.text,
                          ),
                        ),
                        const SizedBox(height: 30),
                        state is LoginLoading
                            ? const Center(child: CircularProgressIndicator())
                            : BottumAuth(
                                title: "تأكيد التغيير",
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final result = await cubit.resetPassword(
                                      email: emailController.text.trim(),
                                      otp: otpController.text.trim(),
                                      password: passwordController.text,
                                      passwordConfirmation:
                                          confirmPasswordController.text,
                                    );

                                    if (result['success'] == true) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "تم تغيير كلمة المرور بنجاح"),
                                          ),
                                        );
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Login()),
                                        );
                                      }
                                    } else {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(result['message'])),
                                        );
                                      }
                                    }
                                  }
                                },
                              ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
