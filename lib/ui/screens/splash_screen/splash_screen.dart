import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/ui/utils/assets/app_assets.dart';
import 'package:movies_app/ui/utils/colors/app_colors.dart';
import 'package:movies_app/ui/utils/routes/app_routes.dart';

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
    Future.delayed(Duration(seconds: 3), (){
    Navigator.pushReplacement(context, AppRoutes.onboardingMain);

    });
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
