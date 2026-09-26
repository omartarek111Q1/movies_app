import 'package:movies_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:movies_app/network/api_result.dart';

class ForgetPasswordUseCase {
  final AuthenticationRepository repository;
  ForgetPasswordUseCase(this.repository);

  Future<ApiResult<void>> call(String email) async {
    return await repository.forgetPassword(email: email);
  }
}