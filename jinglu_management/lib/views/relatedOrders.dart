import 'package:flutter/material.dart';
import 'package:jinglu_management/models/order.dart';
import 'package:jinglu_management/views/orderRow.dart';
class RelatedOrder extends StatelessWidget {
  const RelatedOrder({Key? key, required this.orders}) : super(key: key);
  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("相关订单"),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(top:20),
          itemCount: orders.length,
          itemBuilder: (BuildContext context,int index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16.0,0,16,10),
              child: OrderRow(order: orders[index]),
            );
      }),
    );
  }
}
