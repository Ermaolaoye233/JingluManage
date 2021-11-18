// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as int,
      name: json['name'] as String,
      amount: json['amount'] as int,
      inPrice: (json['inPrice'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      vipPrice: (json['vipPrice'] as num).toDouble(),
      barcode: json['barcode'] as String,
      type: json['type'] as int,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'inPrice': instance.inPrice,
      'price': instance.price,
      'vipPrice': instance.vipPrice,
      'barcode': instance.barcode,
      'type': instance.type,
    };
