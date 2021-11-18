// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'package:date_format/date_format.dart';
import 'package:jinglu_management/models/product.dart';
import 'package:jinglu_management/dio_client.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  Order({
    required this.id,
    required this.userID,
    required this.productID,
    required this.amount,
    required this.price,
    required this.description,
    required this.type,
    required this.time,
  });

  final int id;
  final int userID;
  final int productID;
  final int amount;
  final double price;
  final String description;
  final int type;
  final String time;

  String getDescription(){
    if (type == 0) {
      // 进货
      return "入库 " + amount.toString() + " 件";
    } else {
      // 出货
      return "出库 " + amount.toString() + " 件";
    }
  }

  String getTimeDescription(){
    DateTime dt = DateTime.parse(time);
    return formatDate(dt, [mm, "月", dd, "日 ", hh, "时", mm,"分"]);
  }



  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    userID: json["userID"],
    productID: json["productID"],
    amount: json["amount"],
    price: json["price"],
    description: json["description"],
    type: json["type"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userID": userID,
    "productID": productID,
    "amount": amount,
    "price": price,
    "description": description,
    "type": type,
    "time": time,
  };
}

var sampleOrder = Order(id: 1, userID: 1, productID: 1, amount: 1, price: 1, description: "卖三箱茅台给刘某某。卖三箱茅台给刘某某。卖三箱茅台给刘某某。卖三箱茅台给刘某某。卖三箱茅台给刘某某。卖三箱茅台给刘某某。卖三箱茅台给刘某某。卖三箱茅台给刘某某。", type: 0, time: "2021-01-02T07:12:50");
