part of 'onboarding_cubit.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();
}

class OnboardingInitial extends OnboardingState {
  final OnboardingPages onboardingPages;

  const OnboardingInitial({required this.onboardingPages});

  @override
  List<Object> get props => [onboardingPages];
}

///------------------------------------------------------------

abstract class OnChangeOnBoardingPageState extends Equatable {
  const OnChangeOnBoardingPageState();
}

class OnChangeOnBoardingPage extends OnChangeOnBoardingPageState {
  final int index;

  const OnChangeOnBoardingPage({required this.index});

  @override
  List<Object> get props => [index];
}
