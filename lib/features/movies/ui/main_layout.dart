//
// import 'package:flutter/material.dart';
// import 'package:movies_app/core/utils/colors/app_colors.dart';
// import 'package:movies_app/features/movies/ui/home/home_screen.dart';
// import 'package:movies_app/features/movies/ui/search/search_screen.dart';
// import 'package:movies_app/features/movies/ui/browse/browse_screen.dart';
// import 'package:movies_app/features/movies/ui/profile/profile_screen.dart';
//
// class MainLayout extends StatefulWidget {
//   const MainLayout({Key? key}) : super(key: key);
//
//   @override
//   State<MainLayout> createState() => _MainLayoutState();
// }
//
// class _MainLayoutState extends State<MainLayout> {
//   int _currentIndex = 0;
//
//   final List<Widget> _screens = const [
//     HomeScreen(),
//     SearchScreen(),
//     BrowseScreen(),
//     ProfileScreen(),
//   ];
//
//   // لستة الأيقونات عشان نسهل عرضهم في الـ Row
//   final List<Map<String, IconData>> _navItems = [
//     {'unselected': Icons.home_outlined, 'active': Icons.home},
//     {'unselected': Icons.search_outlined, 'active': Icons.search},
//     {'unselected': Icons.explore_outlined, 'active': Icons.explore},
//     {'unselected': Icons.person_outline, 'active': Icons.person},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.black,
//       extendBody: true, // الشاشات تنزل تحت البار
//       body: _screens[_currentIndex],
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             // حساب عرض كل عنصر عشان نعرف نحرك المربع الأصفر بدقة
//             final double itemWidth = constraints.maxWidth / _navItems.length;
//             final double indicatorWidth = 55.0; // عرض المربع الأصفر
//             final double indicatorHeight = 45.0; // طول المربع الأصفر
//
//             // حساب مكان المربع الأصفر (Left Position) بناءً على الاندكس الحالي
//             final double indicatorPosition = (_currentIndex * itemWidth) + (itemWidth / 2) - (indicatorWidth / 2);
//
//             return Container(
//               height: 70,
//               decoration: BoxDecoration(
//                 color: AppColors.gray,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: Stack(
//                 children: [
//                   // 1. المربع الأصفر اللي بيتحرك (الخلفية)
//                   AnimatedPositioned(
//                     duration: const Duration(milliseconds: 500), // سرعة الانيميشن
//                     curve: Curves.easeInOut, // شكل الحركة (ناعمة في البداية والنهاية)
//                     left: indicatorPosition,
//                     top: (70 - indicatorHeight) / 2, // توسيط عمودي جوه البار
//                     child: Container(
//                       width: indicatorWidth,
//                       height: indicatorHeight,
//                       decoration: BoxDecoration(
//                         color: AppColors.yellow,
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                     ),
//                   ),
//
//                   // 2. صف الأيقونات اللي فوق المربع
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: List.generate(_navItems.length, (index) {
//                       final isSelected = _currentIndex == index;
//                       final activeIcon = _navItems[index]['active']!;
//                       final unselectedIcon = _navItems[index]['unselected']!;
//
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             _currentIndex = index;
//                           });
//                         },
//                         behavior: HitTestBehavior.opaque, // عشان الاستجابة للضغط تكون في مساحة العنصر كلها مش الأيقونة بس
//                         child: SizedBox(
//                           width: itemWidth,
//                           height: 70,
//                           child: Icon(
//                             isSelected ? activeIcon : unselectedIcon,
//                             color: isSelected ? AppColors.black : AppColors.white, // تغيير لون الأيقونة
//                             size: 28,
//                           ),
//                         ),
//                       );
//                     }),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

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

  // استخدام متغيرات AppIcons مباشرة هنا
  // غير أسماء المتغيرات دي (زي AppIcons.homeIcon) لأسماء المتغيرات الفعلية اللي كاتبها جوه كلاس AppIcons عندك
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
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
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
