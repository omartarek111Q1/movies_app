import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/colors/app_colors.dart';
import '../../../../../core/utils/routes/app_routes.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../cubit/auth_cubit.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        title: const Text(
          "Verify Email",
          style: TextStyle(
            color: AppColors.yellow,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is EmailIsVerifiedState) {
            Navigator.pushReplacement(context, AppRoutes.profile);
          } else if (state is ErrorAuthState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.mark_email_unread_outlined,
                  color: AppColors.yellow,
                  size: 100,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Please Verify Your Email',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'We have sent you an email to verify your account. Please check your inbox and click on the verification link.',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                state is LoadingState
                    ? const CircularProgressIndicator(color: AppColors.yellow)
                    : CustomBtn(
                        inColor: AppColors.yellow,
                        title: 'Check Verification',
                        titleColor: AppColors.black,
                        borderColor: Colors.transparent,
                        onTap: () {
                          context.read<AuthCubit>().checkEmailVerification();
                        },
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
