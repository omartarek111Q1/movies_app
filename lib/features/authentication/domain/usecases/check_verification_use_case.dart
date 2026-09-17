import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:movies_app/features/authentication/domain/repositories/authentication_repository.dart';

import '../../../../network/auth_errors/failure.dart';

class CheckVerificationUseCase {
  final AuthenticationRepository repository;
  CheckVerificationUseCase(this.repository);

  Future<Either<Failure , Unit>> call(Completer completer) async{
    return await repository.checkEmailVerification(completer);
    // create var and if api.success or api.error try and catch
  }
}