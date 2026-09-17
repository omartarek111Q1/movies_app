import 'package:dartz/dartz.dart';
import 'package:movies_app/features/authentication/domain/repositories/authentication_repository.dart';
import '../../../../network/auth_errors/failure.dart';

class VerifyEmailUseCase {
  final AuthenticationRepository repository;
  VerifyEmailUseCase(this.repository);

  Future<Either<Failure , Unit>> call() async{
    return await repository.verifyEmail();
  }
}