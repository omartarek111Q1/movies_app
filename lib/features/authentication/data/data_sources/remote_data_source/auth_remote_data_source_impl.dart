import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movies_app/features/authentication/data/data_sources/remote_data_source/auth_remote_data_source.dart';
import 'package:movies_app/features/authentication/data/models/sign_in_model.dart';
import 'package:movies_app/features/authentication/data/models/sign_up_model.dart';

import '../../../../../network/auth_errors/exceptions.dart';

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource{
  @override


  Future<UserCredential> googleAuthentication() async {
    FirebaseAuth firebaseInstance = FirebaseAuth.instance;
    // final GoogleSignIn signIn = GoogleSignIn.instance;
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw ServerException();
    }
    final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      // accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      final userCredential = await firebaseInstance.signInWithCredential(credential);

      if (userCredential.additionalUserInfo?.isNewUser ?? false) {

        final Map<String, dynamic> userData = {
          'uid': userCredential.user!.uid,
          'name': userCredential.user!.displayName ?? 'User',
          'email': userCredential.user!.email ?? '',
          'phone': userCredential.user!.phoneNumber ?? '',
          'avatar': userCredential.user!.photoURL ?? 'assets/images/avatar1.png',
          // 'languageCode': 'en',
          'createdAt': FieldValue.serverTimestamp(),
        };


        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userData);
      }

      return userCredential;
    } catch (e) {
      print('====== Google Sign-In Error: ${e.toString()} ======');
      throw ServerException();
    }
  }
  // Future<UserCredential> googleAuthentication() async{
  //   FirebaseAuth firebaseInstance = FirebaseAuth.instance;
  //   await  firebaseInstance.currentUser?.reload();
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //   try{
  //     return await firebaseInstance.signInWithCredential(credential);
  //   }catch(e){
  //     throw ServerException();
  //   }
  // }

  @override
  Future<UserCredential> signIn(SignInModel signIn) async{
    try {
      FirebaseAuth firebaseInstance = FirebaseAuth.instance;
      await  firebaseInstance.currentUser?.reload();
      return  await firebaseInstance.signInWithEmailAndPassword(
        email: signIn.email,
        password: signIn.password,
      );
    }  on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw ExistedAccountException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordException();
      }else{
        throw ServerException();
      }
    }
  }

  @override
  Future<UserCredential> signUp(SignUpModel signUp) async {
    try {
      FirebaseAuth firebaseInstance = FirebaseAuth.instance;

      final userCredential = await firebaseInstance.createUserWithEmailAndPassword(
        email: signUp.email,
        password: signUp.password,
      );
      if (userCredential.user != null) {
        final Map<String, dynamic> userData = {
          'uid': userCredential.user!.uid,
          'name': signUp.name,
          'email': signUp.email,
          'phone': signUp.phone,
          'avatar': signUp.avatar,
          // 'languageCode': signUp.languageCode,
          'createdAt': FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userData);
      }

      return userCredential;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeekPassException();
      } else if (e.code == 'email-already-in-use') {
        throw ExistedAccountException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
  // Future<UserCredential> signUp(SignUpModel signUp) async{
  //   try {
  //     FirebaseAuth firebaseInstance = FirebaseAuth.instance;
  //     await  firebaseInstance.currentUser?.reload();
  //     return await firebaseInstance.createUserWithEmailAndPassword(
  //       email: signUp.email,
  //       password: signUp.password,
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       throw WeekPassException();
  //     } else if (e.code == 'email-already-in-use') {
  //       throw ExistedAccountException();
  //     }else{
  //       throw ServerException();
  //     }
  //   }
  // }

  @override
  Future<Unit> verifyEmail() async{
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      try{
        await user.reload();
        await user.sendEmailVerification();
      }on FirebaseAuthException catch (e) {
        if (e.code == 'too-many-requests') {
          throw TooManyRequestsException();
        }else {
          throw ServerException();
        }
      }catch(e){
        throw ServerException();
      }
    }else{
      throw NoUserException();
    }
    return Future.value(unit);
  }

}