import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies_app/features/authentication/domain/entity/first_page_entity.dart';
import 'package:movies_app/features/authentication/domain/repositories/authentication_repository.dart';
import '../../../../network/auth_errors/failure.dart';

class FirstPageUseCase {
  final AuthenticationRepository repository;
  FirstPageUseCase(this.repository);

FirstPageEntity call(){
   return repository.firstPage();
  }
}