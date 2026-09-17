import 'package:movies_app/features/authentication/domain/entity/sign_up_entity.dart';

class SignUpModel extends SignUpEntity {
  const new({
    required super.name,
    required super.email,
    required super.password,
    required super.confirmPassword,
    required super.phone,
    required super.avatar,
    // required super.languageCode,
  });
}
