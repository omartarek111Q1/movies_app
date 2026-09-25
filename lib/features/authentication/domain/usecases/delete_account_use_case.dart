import 'package:movies_app/features/authentication/domain/repositories/authentication_repository.dart';

import '../../../../network/api_result.dart';

class DeleteAccountUseCase {
  final AuthenticationRepository repository;

  DeleteAccountUseCase(this.repository);

  Future<ApiResult<void>> call() async {
    return await repository.deleteAccount();
  }
}