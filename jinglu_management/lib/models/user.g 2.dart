// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      phone: json['phone'] as String,
      name: json['name'] as String,
      jwt: json['jwt'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'name': instance.name,
      'jwt': instance.jwt,
    };
