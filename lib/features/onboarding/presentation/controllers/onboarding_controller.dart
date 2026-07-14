import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/features/onboarding/presentation/states/onboarding_state.dart';

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
      return OnboardingController();
    });

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController() : super(const OnboardingState.initial());

  void setPage(int index) {
    if (index == state.currentIndex) {
      return;
    }

    state = state.copyWith(currentIndex: index);
  }
}
