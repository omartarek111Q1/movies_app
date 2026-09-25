import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> fetchUserData() async {
    emit(ProfileLoading());
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        emit(const ProfileError('User not logged in'));
        return;
      }

      String name = 'User';
      String avatarUrl = 'assets/images/avatar_1.png';
      bool isNetworkImage = false;

      // Handle Google Sign-in data directly if available
      if (currentUser.photoURL != null && currentUser.photoURL!.isNotEmpty) {
        avatarUrl = currentUser.photoURL!;
        isNetworkImage = avatarUrl.startsWith('http');
      }
      if (currentUser.displayName != null && currentUser.displayName!.isNotEmpty) {
        name = currentUser.displayName!;
      }

      // Fetch from Firestore if necessary
      if (!isNetworkImage || name == 'User') {
        final doc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          if (!isNetworkImage) {
            avatarUrl = data['avatar'] ?? avatarUrl;
            isNetworkImage = avatarUrl.startsWith('http');
          }
          if (name == 'User') {
            name = data['name'] ?? name;
          }
        }
      }

      emit(ProfileLoaded(
        name: name,
        avatarUrl: avatarUrl,
        isNetworkImage: isNetworkImage,
      ));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
