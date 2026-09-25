import 'package:movies_app/features/authentication/domain/repositories/authentication_repository.dart';

import '../../../../network/api_result.dart';

class UpdateProfileUseCase {
  final AuthenticationRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<ApiResult<void>> call({required String name, required String profileImage, required String phone}) async {
    return await repository.updateProfile(name: name, profileImage: profileImage, phone: phone);
  }
}