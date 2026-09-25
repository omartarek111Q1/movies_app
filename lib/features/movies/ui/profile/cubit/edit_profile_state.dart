import 'package:movies_app/network/resource.dart';

class EditProfileState {
  final Resource<void> updateProfileData;
  final Resource<void> resetPassword;
  final Resource<void> deleteAccount;

  EditProfileState({
required this.updateProfileData,
    required this.resetPassword,
    required this.deleteAccount
  });

 factory EditProfileState.initial(){
     return EditProfileState(
        updateProfileData: Resource.initial(),
        resetPassword: Resource.initial(),
        deleteAccount:  Resource.initial(),
    );
  }

  EditProfileState copyWith({
    Resource<void>? updateProfileData,
    Resource<void>? resetPassword,
    Resource<void>? deleteAccount,
}) {
    return EditProfileState(
      updateProfileData: updateProfileData ?? this.updateProfileData,
      resetPassword: resetPassword ?? this.resetPassword,
      deleteAccount: deleteAccount ?? this.deleteAccount,
    );
  }
}