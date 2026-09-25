import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/utils/assets/app_assets.dart';
import 'package:movies_app/core/utils/colors/app_colors.dart';
import 'package:movies_app/core/utils/icons/app_icons.dart';
import 'package:movies_app/core/utils/routes/app_routes.dart';
import 'package:movies_app/core/widgets/custom_btn.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';
import 'package:movies_app/features/movies/ui/profile/cubit/edit_profile_cubit.dart';
import 'package:movies_app/features/movies/ui/profile/cubit/edit_profile_state.dart';

class EditProfileScreen extends StatefulWidget {
   EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  int selectedAvatarIndex = 0;
  String? networkAvatarUrl;


  final List<String> avatars = [
    AppAssets.avatar1,
    AppAssets.avatar2,
    AppAssets.avatar3,
    AppAssets.avatar4,
    AppAssets.avatar5,
    AppAssets.avatar6,
    AppAssets.avatar7,
    AppAssets.avatar8,
    AppAssets.avatar9,
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      nameController.text = user.displayName ?? '';

      String? authPhoto = user.photoURL;

      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;

          setState(() {
            phoneController.text = data['phone'] ?? '';

            if (data['name'] != null && data['name'].toString().isNotEmpty) {
              nameController.text = data['name'];
            }

            String savedAvatar = data['avatar'] ?? authPhoto ?? '';

            if (savedAvatar.startsWith('http')) {
              networkAvatarUrl = savedAvatar;
            } else {
              int index = avatars.indexOf(savedAvatar);
              if (index != -1) {
                selectedAvatarIndex = index;
                networkAvatarUrl = null;
              }
            }
          });
        } else if (authPhoto != null) {
          setState(() {
            networkAvatarUrl = authPhoto;
          });
        }
      } catch (e) {
        debugPrint("Error loading user data: $e");
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        // Reset Password Listener
        if (state.resetPassword.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text("Password reset link sent to your email. Please check your inbox."),
            ),
          );
        } else if (state.resetPassword.isError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(state.resetPassword.errorMessage ?? "Failed to reset password."),
            ),
          );
        }

        // Update Profile Listener
        if (state.updateProfileData.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profile updated successfully!"),
            ),
          );
        } else if (state.updateProfileData.isError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(state.updateProfileData.errorMessage ?? "Failed to update profile."),
            ),
          );
        }

        // Delete Account Listener
        if (state.deleteAccount.isSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        } else if (state.deleteAccount.isError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(state.deleteAccount.errorMessage ?? "Failed to delete account."),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.black,
          appBar: AppBar(
            backgroundColor: AppColors.black,
            title: Text(
              'Pick Avatar',
              style: TextStyle(color: AppColors.yellow),
            ),
            centerTitle: true,
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.keyboard_arrow_left,
                  color: AppColors.yellow,
                  size: 40,
                )),
          ),
          body: LayoutBuilder(
            builder: (context , constraints){
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: InkWell(
                            onTap: () {
                              _showAvatarBottomSheet();
                            },
                            child: CircleAvatar(
                              maxRadius: 70,
                              minRadius: 50,
                              backgroundColor: Colors.transparent,
                              backgroundImage: networkAvatarUrl != null
                                  ? NetworkImage(networkAvatarUrl!) as ImageProvider
                                  : AssetImage(avatars[selectedAvatarIndex]),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        CustomTextField(
                          prefixIcon: AppIcons.profile,
                          controller: nameController,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          prefixIcon: AppIcons.phone,
                          controller: phoneController,
                        ),
                        SizedBox(
                          height: 20,
                        ),


                           Align(
                             alignment: Alignment.centerLeft,
                             child: InkWell(
                              onTap: () {
                                context.read<EditProfileCubit>().resetPassword();
                              },
                              child: Text(
                                'Reset Password',
                                style: TextStyle(color: AppColors.white, fontSize: 20 ),
                              ),
                                                       ),
                           ),
                        Spacer(),
                        state.deleteAccount.isLoading
                            ? Center(child: CircularProgressIndicator(color: AppColors.red))
                            : CustomBtn(
                            inColor: AppColors.red,
                            title: 'Delete Account',
                            titleColor: AppColors.white,
                            onTap: () {
                              context.read<EditProfileCubit>().deleteAccount();
                            },
                            borderColor: Colors.transparent),
                        SizedBox(
                          height: 20,
                        ),
                        state.updateProfileData.isLoading
                            ? Center(child: CircularProgressIndicator(color: AppColors.yellow))
                            : CustomBtn(
                            inColor: AppColors.yellow,
                            title: 'Update Data',
                            titleColor: AppColors.black,
                            onTap: () {
                              context.read<EditProfileCubit>().updateProfileData(
                                name: nameController.text,
                                profileImage: networkAvatarUrl ?? avatars[selectedAvatarIndex],
                                phone: phoneController.text,
                              );
                            },
                            borderColor: Colors.transparent),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },

          ),
        );
      },
    );
  }

  void _showAvatarBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.gray,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: avatars.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  bool isSelected = selectedAvatarIndex == index;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedAvatarIndex = index;
                        networkAvatarUrl = null;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.yellow.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.yellow,
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          avatars[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
