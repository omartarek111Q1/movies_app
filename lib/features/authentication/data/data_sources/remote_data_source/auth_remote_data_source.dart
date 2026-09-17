import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/sign_in_model.dart';
import '../../models/sign_up_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> signUp(SignUpModel signUp);
  Future<UserCredential> signIn(SignInModel signIn);
  Future<UserCredential> googleAuthentication();

  Future<Unit> verifyEmail();
}