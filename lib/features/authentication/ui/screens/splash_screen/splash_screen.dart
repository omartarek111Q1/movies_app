import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/utils/assets/app_assets.dart';
import '../../../../../core/utils/colors/app_colors.dart';
import '../../../../../core/utils/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // 1. استنى ثانيتين (وقت عرض الـ Splash)
    await Future.delayed(const Duration(seconds: 2));

    // 2. اقرأ الداتا من SharedPreferences عشان تعرف دي أول مرة ولا لأ
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('is_first_time') ?? true;

    if (!mounted) return;

    if (isFirstTime) {
      // 3. لو أول مرة -> احفظ إنها مابقتش أول مرة، ووديه للـ Onboarding
      await prefs.setBool('is_first_time', false);
      Navigator.pushReplacement(
        context, AppRoutes.onboardingMain, // اسم شاشة الأونبوردنج عندك
      );
    } else {
      // 4. لو مش أول مرة -> اكشف على حالة تسجيل الدخول
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // مسجل دخول -> MainLayout
        Navigator.pushReplacement(
          context,AppRoutes.mainLayOut,
        );
      } else {
        // مش مسجل دخول -> LoginScreen
        Navigator.pushReplacement(
          context,AppRoutes.login,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Expanded(child: Center(child: ZoomIn(delay: Duration(seconds: 1), child: Image.asset(AppAssets.logo, alignment: Alignment.center,)))),
        SlideInUp(delay: Duration(seconds: 1),child: Image.asset(AppAssets.route )),
        ],
      ),
    );
  }
}
