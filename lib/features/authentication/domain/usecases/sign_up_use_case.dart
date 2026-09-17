import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies_app/features/authentication/domain/entity/sign_up_entity.dart';
import 'package:movies_app/features/authentication/domain/repositories/authentication_repository.dart';
import '../../../../network/auth_errors/failure.dart';

class SignUpUseCase {
  final AuthenticationRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure , UserCredential>> call(SignUpEntity signUp) async{
    return await repository.signup(signUp);
  }
}