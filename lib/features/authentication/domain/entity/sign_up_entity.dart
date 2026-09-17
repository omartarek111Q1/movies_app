import 'package:equatable/equatable.dart';

class SignUpEntity extends Equatable {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String phone;
  final String avatar;
  // final String languageCode;

  const SignUpEntity({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phone,
    required this.avatar,
    // required this.languageCode,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    name,
    email,
    password,
    confirmPassword,
    phone,
    avatar,
    // languageCode,
  ];
}
