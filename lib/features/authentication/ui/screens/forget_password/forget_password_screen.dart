import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/utils/assets/app_assets.dart';
import 'package:movies_app/core/utils/colors/app_colors.dart';
import 'package:movies_app/core/utils/icons/app_icons.dart';
import 'package:movies_app/core/widgets/custom_btn.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';
import 'package:movies_app/injection_container.dart';

import 'cubit/forget_password_cubit.dart';
import 'cubit/forget_password_state.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ForgetPasswordCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.yellow),
          title: const Text(
            'Forget Password',
            style: TextStyle(color: AppColors.yellow),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
            listener: (context, state) {
              if (state.forgotPasswordResult.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password reset link sent to your email.'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              } else if (state.forgotPasswordResult.isError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.forgotPasswordResult.errorMessage ?? 'An error occurred'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      AppAssets.forgotPassword,
                      height: 350,
                    ),
                    const SizedBox(height: 40),
                    CustomTextField(
                      prefixIcon: AppIcons.email,
                      hint: 'Email',
                      controller: emailController,
                    ),
                    const SizedBox(height: 34),
                    state.forgotPasswordResult.isLoading
                        ? const Center(child: CircularProgressIndicator(color: AppColors.yellow))
                        : CustomBtn(
                            inColor: AppColors.yellow,
                            title: 'Verify Email',
                            titleColor: AppColors.black,
                            borderColor: Colors.transparent,
                            onTap: () {
                              final email = emailController.text.trim();
                              if (email.isNotEmpty) {
                                context.read<ForgetPasswordCubit>().sendResetLink(email);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter your email.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
