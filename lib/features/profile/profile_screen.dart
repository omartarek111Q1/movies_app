import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/utils/routes/app_routes.dart';

import '../authentication/ui/cubit/auth_cubit.dart';

// تأكد من استيراد مسارات مشروعك الصحيحة
// import '../../../../../features/authentication/presentation/bloc/auth_cubit.dart';
// import '../../../../../core/utils/colors/app_colors.dart';
// import '../../../../../core/utils/routes/app_routes.dart';
// import '../../../../../core/widgets/custom_btn.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // الحصول على المستخدم الحالي من فايربيز
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black, // استبدلها بـ AppColors.black
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.amber), // استبدلها بـ AppColors.yellow
        ),
        centerTitle: true,
      ),

      // استخدام BlocConsumer لمراقبة حالة تسجيل الخروج
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoggedOutState) {
            // عند نجاح تسجيل الخروج، نعود لشاشة تسجيل الدخول
            Navigator.pushReplacement(context, AppRoutes.login); // استخدم AppRoutes.login
          } else if (state is ErrorAuthState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          // إذا لم يكن هناك مستخدم مسجل
          if (currentUser == null) {
            return const Center(
              child: Text('No User Logged In', style: TextStyle(color: Colors.white)),
            );
          }

          // جلب بيانات المستخدم من Firestore بناءً على الـ UID
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get(),
            builder: (context, snapshot) {

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.amber));
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Error loading data', style: TextStyle(color: Colors.red)));
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(
                  child: Text('User data not found in Firestore', style: TextStyle(color: Colors.white)),
                );
              }

              // تحويل البيانات القادمة إلى Map لتسهيل قراءتها
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // عرض الـ Avatar
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(userData['avatar'] ?? 'assets/images/avatar1.png'),
                    ),
                    const SizedBox(height: 30),

                    // عرض البيانات في كروت
                    _buildInfoCard('Name', userData['name'] ?? 'N/A'),
                    const SizedBox(height: 15),
                    _buildInfoCard('Email', userData['email'] ?? 'N/A'),
                    const SizedBox(height: 15),
                    _buildInfoCard('Phone', userData['phone'] ?? 'N/A'),

                    const Spacer(),

                    // زر تسجيل الخروج
                    state is LoadingState
                        ? const CircularProgressIndicator(color: Colors.amber)
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        // استدعاء دالة تسجيل الخروج من الـ Cubit
                        context.read<AuthCubit>().logOut();
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ويدجت مساعدة لعرض البيانات بشكل جميل
  Widget _buildInfoCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.amber, fontSize: 12),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
