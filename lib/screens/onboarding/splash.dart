import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate/screens/onboarding/onboarding.dart';
import '../../blocs/onboarding/onboarding_cubit.dart';

class SplashOrOnboarding extends StatelessWidget {
  const SplashOrOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit()..checkIfSeenBefore(),
      child: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          if (state is OnboardingCheckCompleted || state is OnboardingPageChanged) {
            return const OnboardingScreen();
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
