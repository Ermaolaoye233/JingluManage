// To parse this JSON data, do
//
//     final loginUser = loginUserFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'loginUser.g.dart';

@JsonSerializable()
class LoginUser {
  LoginUser({
    required this.phone,
    required this.password,
  });

  final String phone;
  final String password;

  factory LoginUser.fromJson(Map<String, dynamic> json) => LoginUser(
    phone: json["phone"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "password": password,
  };
}
