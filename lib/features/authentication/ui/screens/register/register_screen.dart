import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // استيراد البلوك
// تأكد من استيراد مسارات الـ Cubit والـ State والـ Entity الخاصة بك
// import '../../../../../features/authentication/presentation/bloc/auth_cubit.dart';
// import '../../../../../features/authentication/domain/entities/sign_up_entity.dart';

import '../../../../../core/utils/assets/app_assets.dart';
import '../../../../../core/utils/colors/app_colors.dart';
import '../../../../../core/utils/icons/app_icons.dart';
import '../../../../../core/utils/routes/app_routes.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../domain/entity/sign_up_entity.dart';
import '../../cubit/auth_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final List<String> avatars = [
    AppAssets.avatar1, AppAssets.avatar2, AppAssets.avatar3,
    AppAssets.avatar4, AppAssets.avatar5, AppAssets.avatar6,
    AppAssets.avatar7, AppAssets.avatar8, AppAssets.avatar9,
  ];
  late String selectedAvatar;

  @override
  void initState() {
    super.initState();
    selectedAvatar = avatars[0];
  }

  @override
  void dispose() {

    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        leading: InkWell(
          highlightColor: Colors.transparent,
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.keyboard_arrow_left,
            color: AppColors.yellow,
            size: 30,
          ),
        ),
        backgroundColor: AppColors.black,
        title: Text(
          "Register",
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
          if (state is SignedUpState) {
            context.read<AuthCubit>().sendEmailVerification();
            Navigator.pushReplacement(context, AppRoutes.emailVerifier);
          } else if (state is ErrorAuthState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              children: [
                CarouselSlider(
                  items: avatars.map((image) {
                    return Builder(
                      builder: (BuildContext context) {
                        return CircleAvatar(
                          radius: double.infinity,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(image),
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    enlargeFactor: .4,
                    height: 150,
                    enableInfiniteScroll: true,
                    enlargeCenterPage: true,
                    viewportFraction: .36,
                    onPageChanged: (index, reason) {
                      selectedAvatar = avatars[index];
                    },
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Avatar',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                CustomTextField(prefixIcon: AppIcons.name, hint: 'Name', controller: nameController,),
                SizedBox(height: 24),
                CustomTextField(prefixIcon: AppIcons.email, hint: 'Email' , controller: emailController,),
                SizedBox(height: 24),
                CustomTextField(prefixIcon: AppIcons.password, hint: 'Password' , isPassword: true, controller:  passwordController,),
                SizedBox(height: 24),
                CustomTextField(prefixIcon: AppIcons.password, hint: 'Confirm Password' , isPassword: true, controller: confirmPasswordController,),
                SizedBox(height: 24),
                CustomTextField(prefixIcon: AppIcons.phone, hint: 'Phone Number', controller:  phoneController,),
                SizedBox(height: 24),


                state is LoadingState
                    ? const CircularProgressIndicator(color: AppColors.yellow)
                    : CustomBtn(
                  inColor: AppColors.yellow,
                  title: 'Create Account',
                  titleColor: AppColors.black,
                  borderColor: Colors.transparent,
                  onTap: () {
                    final entity = SignUpEntity(
                      name: nameController.text.trim(),
                      email: emailController.text.trim(),
                      password: passwordController.text,
                      confirmPassword: confirmPasswordController.text,
                      phone: phoneController.text.trim(),
                      avatar: selectedAvatar,
                      // languageCode: 'en',
                    );
                    context.read<AuthCubit>().signUp(entity);
                  },
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already Have Account ? ",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context, AppRoutes.login);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: AppColors.yellow,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}