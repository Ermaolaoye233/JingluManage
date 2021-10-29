// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: json['id'] as int,
      userID: json['userID'] as int,
      productID: json['productID'] as int,
      amount: json['amount'] as int,
      price: json['price'] as double,
      description: json['description'] as String,
      type: json['type'] as int,
      time: json['time'] as String,
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'userID': instance.userID,
      'productID': instance.productID,
      'amount': instance.amount,
      'price': instance.price,
      'description': instance.description,
      'type': instance.type,
      'time': instance.time,
    };
