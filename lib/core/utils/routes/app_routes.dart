import 'package:flutter/material.dart';
import 'package:movies_app/features/authentication/ui/screens/verify_email/verify_email_screen.dart';
import 'package:movies_app/features/profile/profile_screen.dart';

import '../../../features/authentication/ui/screens/forget_password/forget_password_screen.dart';
import '../../../features/authentication/ui/screens/login/login_screen.dart';
import '../../../features/authentication/ui/screens/onboarding/onboarding_main_screen.dart';
import '../../../features/authentication/ui/screens/onboarding/onboarding_screens.dart';
import '../../../features/authentication/ui/screens/register/register_screen.dart';
import '../../../features/authentication/ui/screens/splash_screen/splash_screen.dart';


class AppRoutes {

  static MaterialPageRoute get splash => MaterialPageRoute(builder: (_) => SplashScreen());
  static MaterialPageRoute get onboardingMain => MaterialPageRoute(builder: (_) => OnboardingMainScreen());
  static MaterialPageRoute get onboarding => MaterialPageRoute(builder: (_) => OnboardingScreens());
  static MaterialPageRoute get login => MaterialPageRoute(builder: (_) => LoginScreen());
  static MaterialPageRoute get register => MaterialPageRoute(builder: (_) => RegisterScreen());
  static MaterialPageRoute get forgetPassword => MaterialPageRoute(builder: (_) => ForgetPasswordScreen());
  static MaterialPageRoute get profile => MaterialPageRoute(builder: (_) => ProfileScreen());
  static MaterialPageRoute get emailVerifier => MaterialPageRoute(builder: (_) => VerifyEmailScreen());








}