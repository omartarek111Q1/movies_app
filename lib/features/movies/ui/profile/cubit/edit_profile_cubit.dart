
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/movies/ui/profile/cubit/edit_profile_state.dart';
import 'package:movies_app/network/resource.dart';

import '../../../../authentication/domain/usecases/delete_account_use_case.dart';
import '../../../../authentication/domain/usecases/reset_password_use_case.dart';
import '../../../../authentication/domain/usecases/update_profile_use_case.dart';

class EditProfileCubit extends Cubit<EditProfileState>{
  final UpdateProfileUseCase _updateProfileUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;

  EditProfileCubit(
      this._updateProfileUseCase,
      this._resetPasswordUseCase,
      this._deleteAccountUseCase,
      ) : super(EditProfileState.initial());

  Future<void> updateProfileData({
    required String name,
    required String profileImage,
    required String phone
})async{
    emit(state.copyWith(updateProfileData: Resource.loading() ));

    var apiResult = await _updateProfileUseCase.call(
        name: name,
        profileImage: profileImage,
        phone: phone);

    if(isClosed)return;

    if(apiResult.isSuccess){
      emit(state.copyWith(updateProfileData:  Resource.success(null)));
    }else{
      emit(state.copyWith(updateProfileData: Resource.error(apiResult.errorMessage)));
    }
  }

  Future<void> resetPassword()async{
    emit(state.copyWith(resetPassword: Resource.loading()));

    var apiResult = await _resetPasswordUseCase.call();

    if(isClosed) return;

    if(apiResult.isSuccess){
      emit(state.copyWith(resetPassword: Resource.success(null)));
    }else{
      emit(state.copyWith(resetPassword: Resource.error(apiResult.errorMessage)));
    }
  }

  Future<void> deleteAccount()async{
    emit(state.copyWith(deleteAccount: Resource.loading()));

    var apiResult = await _deleteAccountUseCase.call();

    if(isClosed) return;

    if(apiResult.isSuccess){
      emit(state.copyWith(deleteAccount: Resource.success(null)));
    }else{
      emit(state.copyWith(deleteAccount: Resource.error(apiResult.errorMessage)));
    }
  }

}