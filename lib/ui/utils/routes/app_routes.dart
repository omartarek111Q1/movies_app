import 'package:flutter/material.dart';
import 'package:movies_app/ui/screens/login/login_screen.dart';
import 'package:movies_app/ui/screens/onboarding/onboarding_main_screen.dart';
import 'package:movies_app/ui/screens/onboarding/onboarding_screens.dart';
import 'package:movies_app/ui/screens/splash_screen/splash_screen.dart';

class AppRoutes {

  static MaterialPageRoute get splash => MaterialPageRoute(builder: (_) => SplashScreen());
  static MaterialPageRoute get onboardingMain => MaterialPageRoute(builder: (_) => OnboardingMainScreen());
  static MaterialPageRoute get onboarding => MaterialPageRoute(builder: (_) => OnboardingScreens());
  static MaterialPageRoute get login => MaterialPageRoute(builder: (_) => LoginScreen());




}