import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/assets/app_assets.dart';
import '../../../../../core/utils/colors/app_colors.dart';
import '../../../../../core/utils/icons/app_icons.dart';
import '../../../../../core/utils/routes/app_routes.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../profile/profile_screen.dart';
import '../../../domain/entity/sign_in_entity.dart';
import '../../cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is SignedInState || state is GoogleSignInState) {
              Navigator.pushReplacement(context, AppRoutes.profile);
            } else if (state is ErrorAuthState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Image.asset(AppAssets.logo),
                  const SizedBox(height: 70),
                  CustomTextField(
                    prefixIcon: AppIcons.email,
                    hint: 'Email',
                    controller: emailController,
                  ),
                  const SizedBox(height: 22),
                  CustomTextField(
                    prefixIcon: AppIcons.password,
                    hint: 'Password',
                    isPassword: true,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 18),
                  InkWell(
                    onTap: () {
                      // TODO: Navigate to Forget Password Screen
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forget Password ?',
                        style: TextStyle(
                          color: AppColors.yellow,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 34),

                  state is LoadingState
                      ? const CircularProgressIndicator(color: AppColors.yellow)
                      : CustomBtn(
                    inColor: AppColors.yellow,
                    title: 'Login',
                    titleColor: AppColors.black,
                    borderColor: Colors.transparent,
                    onTap: () {
                      final entity = SignInEntity(
                        email: emailController.text.trim(),
                        password: passwordController.text,
                      );
                      context.read<AuthCubit>().signIn(entity);
                    },
                  ),

                  const SizedBox(height: 23),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't Have Account ? ",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, AppRoutes.register);
                        },
                        child: Text(
                          'Create One',
                          style: TextStyle(
                            color: AppColors.yellow,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 27),
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.yellow, height: 1.12, endIndent: 16, indent: 80)),
                      Text('OR', style: TextStyle(color: AppColors.yellow, fontWeight: FontWeight.w400, fontSize: 15)),
                      Expanded(child: Divider(color: AppColors.yellow, height: 1.12, endIndent: 80, indent: 16)),
                    ],
                  ),
                  const SizedBox(height: 28),

                  state is LoadingState
                      ? const SizedBox()
                      : CustomBtn(
                    isThereIcon: true,
                    inColor: AppColors.yellow,
                    title: 'Login With Google',
                    titleColor: AppColors.black,
                    prefixIcon: AppIcons.rating,
                    borderColor: Colors.transparent,
                    onTap: () {
                      // استدعاء دالة جوجل من الـ Cubit
                      context.read<AuthCubit>().signInWithGoogle();
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}