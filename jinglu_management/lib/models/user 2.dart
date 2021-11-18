// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    required this.id,
    required this.phone,
    required this.name,
    required this.jwt,
  });

  final int id;
  final String phone;
  final String name;
  final String jwt;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    phone: json["phone"],
    name: json["name"],
    jwt: json["jwt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "phone": phone,
    "name": name,
    "jwt": jwt,
  };
}

User sampleUser = User(id: 1, phone: "18922001105", name: "王小明", jwt: "123");