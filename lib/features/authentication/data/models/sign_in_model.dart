import 'package:movies_app/features/authentication/domain/entity/sign_in_entity.dart';

class SignInModel extends SignInEntity{
  const new({required super.email, required super.password});

}

// class SignInModel extends SignInEntity {
//   const SignInModel({required String email,required String password})
//       : super(  email: email, password: password);
// }