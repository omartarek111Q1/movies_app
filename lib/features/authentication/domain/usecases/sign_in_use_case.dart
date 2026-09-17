import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies_app/features/authentication/domain/entity/sign_in_entity.dart';
import 'package:movies_app/features/authentication/domain/repositories/authentication_repository.dart';
import '../../../../network/auth_errors/failure.dart';

class SignInUseCase {
  final AuthenticationRepository repository;
  SignInUseCase(this.repository);

  Future<Either<Failure , UserCredential>> call(SignInEntity signIn) async{
    return await repository.signIn(signIn);
  }
}