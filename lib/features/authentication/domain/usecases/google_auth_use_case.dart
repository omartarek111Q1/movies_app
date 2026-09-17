import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:movies_app/features/authentication/domain/repositories/authentication_repository.dart';
import '../../../../network/auth_errors/failure.dart';

class GoogleAuthUseCase {
  final AuthenticationRepository repository;
  GoogleAuthUseCase(this.repository);

  Future<Either<Failure , UserCredential>> call() async{
    return await repository.googleSignIn();
  }
}