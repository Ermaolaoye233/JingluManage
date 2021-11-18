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
  });

  final int id;
  final String name;
  final int amount;
  final double inPrice;
  final double price;
  final double vipPrice;
  final String barcode;
  final int type;


  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    amount: json["amount"],
    inPrice: json["inPrice"],
    price: json["price"],
    vipPrice: json["vipPrice"],
    barcode: json["barcode"],
    type: json["type"],
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
  };
}

var sampleProduct = Product(id: 1, name: "贵州茅台酒", amount: 10, inPrice:1500.0 ,price: 1000.0, vipPrice: 900.0, barcode: "", type: 1);

var testJson = {
  "id": 2, "name": "test", "amount": 0, "inPrice": 1.0, "price": 2233.0, "vipPrice": 123.0, "barcode": "00", "type": 1
};

Product testJsonProduct = Product.fromJson(testJson);