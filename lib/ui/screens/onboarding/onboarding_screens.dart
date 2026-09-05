import 'package:flutter/material.dart';
import 'package:movies_app/ui/utils/assets/app_assets.dart';
import 'package:movies_app/ui/utils/build_context_extensions.dart';
import 'package:movies_app/ui/utils/colors/app_colors.dart';
import 'package:movies_app/ui/utils/routes/app_routes.dart';
import 'package:movies_app/ui/widgets/custom_btn.dart';

class OnboardingScreens extends StatefulWidget {
  const OnboardingScreens({super.key});

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final PageController _pageController = PageController();
  int currentIndex = 0;
  List<OnboardingModel> onboardingData = [
    OnboardingModel(
      image: AppAssets.onboarding_2,
      title: 'Discover Movies',
      description: 'Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.',
      gradientColors: [
        Colors.blue.withValues(alpha: 1),
        Colors.transparent,
      ],
    ),
    OnboardingModel(
      image: AppAssets.onboarding_3,
      title: 'Explore All Genres',
      description: 'Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.',
      gradientColors: [
        Colors.deepOrange.withValues(alpha: 1),
        Colors.transparent,
      ],
    ),
    OnboardingModel(
      image: AppAssets.onboarding_4,
      title: 'Create Watchlists',
      description: 'Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.',
      gradientColors: [
        Colors.purple.withValues(alpha: 1),
        Colors.transparent,
      ],
    ),
    OnboardingModel(
      image: AppAssets.onboarding_5,
      title: 'Rate, Review, and Learn',
      description: "Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews.",
      gradientColors: [Colors.red.withValues(alpha: 1), Colors.transparent],
    ),
    OnboardingModel(
      image: AppAssets.onboarding_6,
      title: 'Start Watching Now',
      description: '',
      gradientColors: [
        Colors.blue.withValues(alpha: 1),
        Colors.transparent,
      ],
    ),
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageView.builder(
physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        itemCount: onboardingData.length,
        onPageChanged: (index) {
          currentIndex = index;
          setState(() {

          });
        },
        itemBuilder: (context, index) {
          final data = onboardingData[index];
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(data.image),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: data.gradientColors,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  // height: context.height * .3,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          data.title,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: currentIndex == 0 ? 24 : 8,),
                      if(data.description.isNotEmpty)
                      Center(
                        child: Text(
                          data.description,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ) ,
                      SizedBox(height: currentIndex == 0 ? 24 : 16,),
                      CustomBtn(
                        borderColor: Colors.transparent,
                        withLoading: false,
                        inColor: AppColors.yellow,
                        title: currentIndex == onboardingData.length - 1
                            ? "Finish"
                            : "Next",
                        titleColor: AppColors.black,
                        onTap: () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          if(currentIndex == onboardingData.length -1 ){
                            Navigator.push(context, AppRoutes.login);
                          }
                        },
                      ),
                      back_btn()
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget back_btn() {
    if (currentIndex > 0) {
      return Column(
        children: [
          SizedBox(height: 16,),
          CustomBtn(
            borderColor: AppColors.yellow,
            withLoading: false,
            inColor: AppColors.black,
            title: 'Back',
            titleColor: AppColors.yellow,
            onTap: () {
              _pageController.previousPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      );
    }else{
      return Text('');
    }
  }
}

class OnboardingModel {
  final String image;
  final String title;
  final String description;
  final List<Color> gradientColors;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
    required this.gradientColors,
  });
}
