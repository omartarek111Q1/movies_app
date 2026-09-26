import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/authentication/domain/usecases/forget_password_use_case.dart';

import '../../../../../../network/resource.dart';
import 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPasswordUseCase _forgotPasswordUseCase;

  ForgetPasswordCubit(this._forgotPasswordUseCase) : super(ForgetPasswordState.initial());

  Future<void> sendResetLink(String email) async {
    emit(state.copyWith(forgotPasswordResult: Resource.loading()));

    var apiResult = await _forgotPasswordUseCase.call(email);

    if (isClosed) return;

    if (apiResult.isSuccess) {
      emit(state.copyWith(forgotPasswordResult: Resource.success(null)));
    } else {
      emit(state.copyWith(forgotPasswordResult: Resource.error(apiResult.errorMessage)));
    }
  }
}