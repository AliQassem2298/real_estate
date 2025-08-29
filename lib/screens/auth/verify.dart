import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate/screens/auth/login.dart';
import '../../blocs/auth/verify/otp_cubit.dart';
import '../../blocs/auth/verify/verify_cubit.dart';
import '../../blocs/auth/verify/verify_state.dart';
import '../../constans/image_url.dart';
import '../../crud.dart';
import '../../widgets/auth/bouttom_auth.dart';
import '../../widgets/auth/otpfeild.dart';

class Verification extends StatelessWidget {
  final String email;

  const Verification({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OtpCubit()),
        BlocProvider(create: (_) => VerifyCubit(Crud())),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocConsumer<VerifyCubit, VerifyState>(
            listener: (context, state) {
              if (state is VerifySuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // 1. أظهر رسالة نجاح
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "تم التحقق بنجاح! جاري توجيهك إلى تسجيل الدخول..."),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // 2. مسح OTP
                  context.read<OtpCubit>().clear();

                  // 3. التوجيه بعد 1.5 ثانية (لإعطاء فرصة لرؤية الرسالة)
                  Future.delayed(const Duration(milliseconds: 1500), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  });
                });
              } else if (state is VerifyFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return _buildVerificationUI(context, state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationUI(BuildContext context, VerifyState state) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Image.asset(AppImageAsset.verify, height: 200),
                  const SizedBox(height: 30),
                  const Text(
                    'يرجى إدخال الرمز المرسل إلى البريد الالكتروني التالي',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const OtpFields(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: state is VerifyLoading
              ? const CircularProgressIndicator()
              : BottumAuth(
                  title: "إرسال",
                  onPressed: () {
                    final code = context.read<OtpCubit>().fullCode;
                    print('Attempting verification with code: $code');
                    if (code.length == 4) {
                      context.read<VerifyCubit>().verifyCode(email, code);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("يجب إدخال الكود المكون من 4 أرقام"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
        ),
      ],
    );
  }
}
