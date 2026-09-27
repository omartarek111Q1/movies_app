import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movies_app/features/authentication/ui/cubit/auth_cubit.dart';
import 'package:movies_app/features/authentication/ui/screens/forget_password/forget_password_screen.dart';
import 'package:movies_app/features/authentication/ui/screens/onboarding/onboarding_screens.dart';
import 'package:movies_app/features/authentication/ui/screens/verify_email/verify_email_screen.dart';
import 'package:movies_app/features/movies/data/models/local/movie_local_model_adapter.dart';
import 'package:movies_app/features/movies/ui/main_layout.dart';
import 'features/authentication/ui/screens/login/login_screen.dart';
import 'features/authentication/ui/screens/splash_screen/splash_screen.dart';
import 'firebase_options.dart';
import 'injection_container.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await Hive.initFlutter();
 Hive.registerAdapter(MovieLocalModelAdapter());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth.instance.setLanguageCode('en');
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
      home: SplashScreen(),
    );
  }
}
