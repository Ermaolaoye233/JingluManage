// To parse this JSON data, do
//
//     final otherUser = otherUserFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

part 'otherUser.g.dart';

@JsonSerializable()
class OtherUser {
  OtherUser({
    required this.id,
    required this.phone,
    required this.name,
  });

  final int id;
  final String phone;
  final String name;

  factory OtherUser.fromJson(Map<String, dynamic> json) => OtherUser(
    id: json["id"],
    phone: json["phone"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "phone": phone,
    "name": name,
  };
}

