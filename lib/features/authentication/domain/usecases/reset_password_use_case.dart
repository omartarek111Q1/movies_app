import 'package:movies_app/features/authentication/domain/repositories/authentication_repository.dart';

import '../../../../network/api_result.dart';

class ResetPasswordUseCase {
  final AuthenticationRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<ApiResult<void>> call() async {
    return await repository.resetPassword();
  }
}