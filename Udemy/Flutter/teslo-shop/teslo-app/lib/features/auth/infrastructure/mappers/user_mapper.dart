import 'package:teslo_shop/features/auth/domain/entities/user.dart';

class UserMapper {
  static userJsonToEntity(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        fullName: json['fullName'] ?? 'Cui cui',
        roles: json['roles'] != null ? List<String>.from(json['roles'].map((role) => role)) : ['admin'],
        token: json['token'],
      );
}
