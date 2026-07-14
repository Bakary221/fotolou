import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  const OnboardingState({required this.currentIndex});

  const OnboardingState.initial() : currentIndex = 0;

  final int currentIndex;

  OnboardingState copyWith({int? currentIndex}) {
    return OnboardingState(currentIndex: currentIndex ?? this.currentIndex);
  }

  @override
  List<Object?> get props => [currentIndex];
}
