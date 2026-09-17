import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/authentication/ui/cubit/auth_cubit.dart';
import 'package:movies_app/features/authentication/ui/screens/onboarding/onboarding_screens.dart';
import 'package:movies_app/features/profile/profile_screen.dart';

import 'features/authentication/ui/screens/login/login_screen.dart';
import 'features/authentication/ui/screens/splash_screen/splash_screen.dart';
import 'firebase_options.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();
  runApp(
    BlocProvider(create: ((context) => sl<AuthCubit>()), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is SignedInPageState) {
            return const ProfileScreen();
          } else {
            return const  OnboardingScreens();
          }
        },
      ),
    );
  }
}
