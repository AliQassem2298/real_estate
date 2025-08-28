import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  int currentPage = 0;
  bool hasSeen = false;

  static const String _seenKey = 'hasSeenOnboarding';

  Future<void> checkIfSeenBefore() async {
    final prefs = await SharedPreferences.getInstance();
    hasSeen = prefs.getBool(_seenKey) ?? false;
    emit(OnboardingCheckCompleted(hasSeen));
    emit(OnboardingPageChanged(currentPage)); // trigger first page
  }

  void nextPage() {
    if (currentPage < 3) {
      currentPage++;
      emit(OnboardingPageChanged(currentPage));
    }
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seenKey, true);
    emit(OnboardingCompleted());
  }

  void goToPage(int page) {
    currentPage = page;
    emit(OnboardingPageChanged(currentPage));
  }
}
