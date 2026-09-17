import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:movies_app/features/authentication/data/data_sources/remote_data_source/auth_remote_data_source.dart';
import 'package:movies_app/features/authentication/domain/entity/first_page_entity.dart';
import 'package:movies_app/features/authentication/domain/entity/sign_in_entity.dart';
import 'package:movies_app/features/authentication/domain/entity/sign_up_entity.dart';
import 'package:movies_app/features/authentication/domain/repositories/authentication_repository.dart';
import '../../../../network/auth_errors/exceptions.dart';
import '../../../../network/auth_errors/failure.dart';

import '../../../../network/check_network/network_info.dart';
import '../models/first_page_model.dart';
import '../models/sign_in_model.dart';
import '../models/sign_up_model.dart';

class AuthRepositoryImpl implements AuthenticationRepository{
  final AuthRemoteDataSource authRemoteDataSource;
  final NetworkInfo networkInfo;
  AuthRepositoryImpl({required this.networkInfo , required this.authRemoteDataSource });

  Future<void> waitForVerifiedUser(Completer completer) async {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      if(FirebaseAuth.instance.currentUser!.emailVerified){
        completer.complete();
        timer.cancel();
      }
    });
    await completer.future;
  }

  @override
  Future<Either<Failure, Unit>> checkEmailVerification(Completer<dynamic> completer)async {
    try{
      await waitForVerifiedUser( completer).timeout(const Duration(days: 30));
      return const Right(unit);
    }catch (e){
      return Left(ServerFailure());
    }
  }

  @override
  FirstPageEntity firstPage() {
    final userCredential = FirebaseAuth.instance.currentUser;
    if(userCredential != null && userCredential.emailVerified){
      return const FirstPageModel(isVerifyingEmail: false , isLoggedIn: true);
    }else if(userCredential != null ){
      return const FirstPageModel(isVerifyingEmail: true , isLoggedIn: false);
    }else{
      return const FirstPageModel(isVerifyingEmail: false , isLoggedIn: false);
    }
  }

  @override
  // Future<Either<Failure, UserCredential>> googleSignIn() async{
  //   if ( !await networkInfo.isConnected) {
  //     return Left(OfflineFailure());
  //   }else{
  //     try{
  //       final userCredential = await authRemoteDataSource.googleAuthentication();
  //       return Right(userCredential) ;
  //     }on ServerException {
  //       return Left(ServerFailure());
  //     }
  //   }
  // }

  @override
  Future<Either<Failure, Unit>> logOut()async {
    if (await networkInfo.isConnected) {
      try {
        // GoogleSignIn _googleSignIn = GoogleSignIn();
        // await _googleSignIn.signOut();
        await FirebaseAuth.instance.signOut();
        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure());
      }
    }else{
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, UserCredential>> signIn(SignInEntity signIn) async {
    if (await networkInfo.isConnected) {
      try{
        final signInModel = SignInModel(email: signIn.email, password: signIn.password);
        final userCredential =  await authRemoteDataSource.signIn(signInModel);
        return Right(userCredential) ;
      }on ExistedAccountException {
        return Left(ExistedAccountFailure()) ;
      }on WrongPasswordException {
        return Left(WrongPasswordFailure());
      }on ServerException {
        return Left(ServerFailure());
      }
    }else{
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, UserCredential>> signup(SignUpEntity signUp)async {
    if ( !await networkInfo.isConnected) {
      return Left(OfflineFailure());
    }else if (signUp.password != signUp.confirmPassword){
      return Left(UnmatchedPassFailure());
    }else{
      try{
        final signUpModel = SignUpModel(name: signUp.name, email: signUp.email, password: signUp.password, confirmPassword: signUp.confirmPassword, phone: signUp.phone, avatar: signUp.avatar,);
        final userCredential =  await authRemoteDataSource.signUp(signUpModel);
        return Right(userCredential) ;
      }on WeekPassException {
        return Left(WeakPassFailure()) ;
      }on ExistedAccountException {
        return Left(ExistedAccountFailure());
      }on ServerException {
        return Left(ServerFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyEmail() async {
    if (await networkInfo.isConnected) {
      try {
        await authRemoteDataSource.verifyEmail();
        return const Right(unit);
      } on TooManyRequestsException {
        return Left(TooManyRequestsFailure());
      }on ServerException {
        return Left(ServerFailure());
      }on NoUserException {
        return Left(NoUserFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, UserCredential>> googleSignIn() async {
    if ( !await networkInfo.isConnected) {
      return Left(OfflineFailure());
    }else{
      try{
        final userCredential = await authRemoteDataSource.googleAuthentication();
        return Right(userCredential) ;
      }on ServerException {
        return Left(ServerFailure());
      }
    }
  }
}