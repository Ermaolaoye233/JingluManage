// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  Product({
    required this.id,
    required this.name,
    required this.amount,
    required this.inPrice,
    required this.price,
    required this.vipPrice,
    required this.barcode,
    required this.type,
    required this.image
  });

  final int id;
  final String name;
  final int amount;
  final double inPrice;
  final double price;
  final double vipPrice;
  final String barcode;
  final int type;
  final String image;


  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    amount: json["amount"],
    inPrice: json["inPrice"],
    price: json["price"],
    vipPrice: json["vipPrice"],
    barcode: json["barcode"],
    type: json["type"],
    image: json['image'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "amount": amount,
    "inPrice": inPrice,
    "price": price,
    "vipPrice": vipPrice,
    "barcode": barcode,
    "type": type,
    'image': image,
  };
}
