import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate/screens/auth/login.dart';
import 'package:real_estate/widgets/auth/bouttom_auth.dart';
import 'package:real_estate/widgets/onboarding/image_widget.dart';
import 'package:real_estate/widgets/onboarding/text_widget.dart';
import 'package:real_estate/constans/color.dart';
import 'package:real_estate/constans/image_url.dart';
import '../../blocs/onboarding/onboarding_cubit.dart';
import '../../widgets/blue_shadow.dart';

class OnboardingScreen extends StatelessWidget {

  const OnboardingScreen({super.key});

  static final List<Map<String, String>> onboardingData = [
    {
      'title': 'عقاري',
      'subtitle': '',
      'image': AppImageAsset.onboarding1,
    },
    {
      'title': 'مرحبا بك',
      'subtitle': 'اكتشف أفضل العقارات للشراء أو الإيجار بكل سهولة وفي مكان واحد',
      'image': AppImageAsset.onboarding2,
    },
    {
      'title': 'ابحث عن بيت أحلامك!',
      'subtitle': 'استخدم الفلاتر الذكية للعثور على العقار المناسب حسب الموقع،السعر والمساحة',
      'image': AppImageAsset.onboarding3,
    },
    {
      'title': 'هل لديك عقار للبيع أو للإيجار؟',
      'subtitle': 'اعرضه خلال دقائق وابدأ في تلقي الطلبات من المهتمين',
      'image': AppImageAsset.onboarding4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Login()),
          );
        }
      },
      child: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          final cubit = context.read<OnboardingCubit>();
          final index = (state is OnboardingPageChanged) ? state.pageIndex : cubit.currentPage;
          final data = onboardingData[index];
          final showOnlyFirstPage = cubit.hasSeen;

          return Scaffold(
            backgroundColor: index == 0 ? Colors.transparent : AppColor.white,
            body: Stack(
              children: [
                if (index == 0)
                  Positioned.fill(
                    child: Image.asset(
                      data['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (index == 0) const BlueShadow(),
                SafeArea(
                  child: Column(
                    children: [
                      if (index != 0)
                        ImageWidget(url: data['image']!),
                      if (index != 0)
                        Expanded(
                          child: Center(
                            child: TextWidget(
                              title: data['title']!,
                              subtitle: data['subtitle']!,
                            ),
                          ),
                        ),
                      if (index == 0)
                        Expanded(
                          child: Center(
                            child: Text(
                              data['title']!,
                              style: const TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                                color: AppColor.white,
                              ),
                            ),
                          ),
                        ),
                      BottumAuth(
                        title: 'التالي',
                        onPressed: () {
                          if (showOnlyFirstPage || index == onboardingData.length - 1) {
                            cubit.completeOnboarding();
                          } else {
                            cubit.nextPage();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
