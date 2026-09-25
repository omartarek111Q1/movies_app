import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/utils/colors/app_colors.dart';
import 'package:movies_app/core/utils/routes/app_routes.dart';
import 'package:movies_app/features/authentication/ui/cubit/auth_cubit.dart';
import 'package:movies_app/features/movies/ui/profile/cubit/profile_cubit.dart';
import 'package:movies_app/features/movies/ui/profile/cubit/profile_state.dart';

import '../../../../injection_container.dart';
import 'cubit/edit_profile_cubit.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..fetchUserData(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoggedOutState) {
            Navigator.pushAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          } else if (state is ErrorAuthState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              // User Info Section
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(color: AppColors.yellow),
                    );
                  } else if (state is ProfileLoaded) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 45,
                                backgroundColor: AppColors.gray,
                                backgroundImage: state.isNetworkImage
                                    ? NetworkImage(state.avatarUrl) as ImageProvider
                                    : AssetImage(state.avatarUrl),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                state.name,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          _buildCounter('Wish List', '12'),
                          const SizedBox(width: 32),
                          _buildCounter('History', '10'),
                          const SizedBox(width: 16),
                        ],
                      ),
                    );
                  } else if (state is ProfileError) {
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(state.message, style: const TextStyle(color: Colors.red)),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 24),
              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => sl<EditProfileCubit>(),
                                child:  EditProfileScreen(),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellow,
                          foregroundColor: AppColors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Builder(
                      builder: (innerContext) {
                        return Expanded(
                          flex: 1,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              innerContext.read<AuthCubit>().logOut();
                            },
                            icon: const Text(
                              'Exit',
                              style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            label: const Icon(Icons.logout, color: AppColors.white),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.red,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Tab Bar
              TabBar(
                controller: _tabController,
                indicatorColor: AppColors.yellow,
                indicatorWeight: 3,
                labelColor: AppColors.yellow,
                unselectedLabelColor: AppColors.white,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.list),
                    text: 'Watch List',
                  ),
                  Tab(
                    icon: Icon(Icons.folder),
                    text: 'History',
                  ),
                ],
              ),
              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildEmptyState(),
                    _buildEmptyState(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounter(String title, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Image.asset(
        'assets/images/Empty.png', 
        width: 150,
        height: 150,
      ),
    );
  }
}
