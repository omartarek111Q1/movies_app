import 'package:flutter/material.dart';
import '../../../../../core/utils/assets/app_assets.dart';
import '../../../../../core/utils/colors/app_colors.dart';
import '../../../../../core/utils/routes/app_routes.dart';
import '../../../../../core/widgets/custom_btn.dart';

class OnboardingMainScreen extends StatelessWidget {
  const OnboardingMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(AppAssets.onboarding1)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [AppColors.black.withValues(alpha: 1), Colors.transparent],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  //           crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Text('Find Your Next Favorite Movie Here', style: TextStyle(color: AppColors.white , fontSize: 36 , fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                SizedBox(height: 8,),
                Text('Get access to a huge library of movies to suit all tastes. You will surely like it.', style: TextStyle(color: Colors.grey, fontSize: 20 , fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
                SizedBox(height: 24,),
                Center(child: CustomBtn(
                  borderColor: Colors.transparent,
                  withLoading: false,
                  inColor: AppColors.yellow,
                  title: 'Explore now',
                  titleColor: AppColors.black, onTap: () {
                  Navigator.pushReplacement(context, AppRoutes.onboarding);
                },)),
                SizedBox(height: 16,),

              ],
            ),
          )

        ],
      ),
    );
  }
}
