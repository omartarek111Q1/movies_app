

import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/colors/app_colors.dart';
import 'package:movies_app/features/movies/ui/home/home_screen.dart';
import 'package:movies_app/features/movies/ui/search/search_screen.dart';
import 'package:movies_app/features/movies/ui/browse/browse_screen.dart';
import 'package:movies_app/features/movies/ui/profile/profile_screen.dart';

import '../../../core/utils/icons/app_icons.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    BrowseScreen(),
    ProfileScreen(),
  ];


  final List<Map<String, String>> _navItems = [
    {
      'unselected': AppIcons.home.toString(),
      'active': AppIcons.home.toString()
    },
    {
      'unselected': AppIcons.search.toString(),
      'active': AppIcons.search.toString()
    },
    {
      'unselected': AppIcons.explore.toString(),
      'active': AppIcons.explore.toString()
    },
    {
      'unselected': AppIcons.profile.toString(),
      'active': AppIcons.profile.toString()
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double itemWidth = constraints.maxWidth / _navItems.length;
            final double indicatorWidth = 55.0;
            final double indicatorHeight = 45.0;

            final double indicatorPosition = (_currentIndex * itemWidth) + (itemWidth / 2) - (indicatorWidth / 2);

            return Container(
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.gray,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: indicatorPosition,
                    top: (70 - indicatorHeight) / 2,
                    child: Container(
                      width: indicatorWidth,
                      height: indicatorHeight,
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(_navItems.length, (index) {
                      final isSelected = _currentIndex == index;
                      final activeImagePath = _navItems[index]['active']!;
                      final unselectedImagePath = _navItems[index]['unselected']!;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                        child: SizedBox(
                          width: itemWidth,
                          height: 70,
                          child: Center(
                            child: Image.asset(
                              isSelected ? activeImagePath : unselectedImagePath,
                              // تغيير لون الأيقونة حسب التحديد
                              color: isSelected ? AppColors.black : AppColors.white,
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
