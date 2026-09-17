import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies_app/features/authentication/domain/entity/first_page_entity.dart';
import 'package:movies_app/features/authentication/domain/entity/sign_in_entity.dart';
import 'package:movies_app/features/authentication/domain/entity/sign_up_entity.dart';
import '../../../../network/auth_errors/failure.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure , UserCredential>> signIn(SignInEntity signIn);
  Future<Either<Failure , UserCredential>> signup(SignUpEntity signUp);
  Future<Either<Failure , UserCredential>> googleSignIn();
  FirstPageEntity firstPage();
  Future<Either<Failure, Unit>>  verifyEmail();
  Future<Either<Failure, Unit>> checkEmailVerification(Completer completer); // completer: make me can stop future even if the data picks up and let if finish only when i do it manually
  Future<Either<Failure, Unit>>  logOut();
}