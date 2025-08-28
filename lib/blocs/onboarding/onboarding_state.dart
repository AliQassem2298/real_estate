part of 'onboarding_cubit.dart';

abstract class OnboardingState {}

class OnboardingInitial extends OnboardingState {}

class OnboardingCheckCompleted extends OnboardingState {
  final bool hasSeen;
  OnboardingCheckCompleted(this.hasSeen);
}

class OnboardingPageChanged extends OnboardingState {
  final int pageIndex;
  OnboardingPageChanged(this.pageIndex);
}

class OnboardingCompleted extends OnboardingState {}
