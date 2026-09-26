import '../../../../../../network/resource.dart';

class ForgetPasswordState {
  final Resource<void> forgotPasswordResult;

  ForgetPasswordState({required this.forgotPasswordResult});

  factory ForgetPasswordState.initial() {
    return ForgetPasswordState(forgotPasswordResult: Resource.initial());
  }

  ForgetPasswordState copyWith({Resource<void>? forgotPasswordResult}) {
    return ForgetPasswordState(
      forgotPasswordResult: forgotPasswordResult ?? this.forgotPasswordResult,
    );
  }
}