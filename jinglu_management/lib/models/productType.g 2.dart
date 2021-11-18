part of 'productType.dart';

ProductType _$ProductTypeFromJson(Map<String, dynamic> json) => ProductType(
    id: json['id'] as int,
    type: json['type'] as String,
);

Map<String, dynamic> _$ProductTypeToJson(ProductType instance) => <String, dynamic>{
    'id': instance.id,
    'type': instance.type,
};