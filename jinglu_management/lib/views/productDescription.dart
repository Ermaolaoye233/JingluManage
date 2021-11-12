import 'package:flutter/material.dart';
import 'package:jinglu_management/models/product.dart';
import 'package:jinglu_management/views/orderRow.dart';
import 'package:jinglu_management/models/order.dart';
import 'package:jinglu_management/dio_client.dart';
import 'package:jinglu_management/views/relatedOrders.dart';
import 'package:jinglu_management/models/images.dart';
import 'dart:convert';

class ProductDescription extends StatelessWidget {
  const ProductDescription({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("商品详情"),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16.0, 28.0, 16.0, 0.0),
        children: <Widget>[
          ProductBar(product: product),
          Padding(
            // 进货价
            padding: const EdgeInsets.fromLTRB(.0, 16.0, .0, .0),
            child: Row(
              children: [
                Text(
                  "进货价",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                Text(
                  product.inPrice.toString() + " 元",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF26A69A)),
                )
              ],
            ),
          ),
          Padding(
            // 售价
            padding: const EdgeInsets.fromLTRB(.0, 14.0, .0, .0),
            child: Row(
              children: [
                Text(
                  "售价",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                Text(
                  product.price.toString() + " 元",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF26A69A)),
                )
              ],
            ),
          ),
          Padding(
            // 会员价
            padding: const EdgeInsets.fromLTRB(.0, 14.0, .0, .0),
            child: Row(
              children: [
                Text(
                  "会员价",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                Text(
                  product.vipPrice.toString() + " 元",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF26A69A)),
                )
              ],
            ),
          ),
          Padding(
            // 现存
            padding: const EdgeInsets.fromLTRB(.0, 14.0, .0, .0),
            child: Row(
              children: [
                Text(
                  "现存",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                Text(
                  product.amount.toString() + " 件",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF26A69A)),
                )
              ],
            ),
          ),
          RelatedOrders(productID: product.id),
        ],
      ),
    );
  }
}

class ProductBar extends StatelessWidget {
  const ProductBar({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.memory(
              product.image == "no_image"
                  ? base64Decode(placeholder_b64String)
                  : base64Decode(product.image),
              width: 122,
              height: 122,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              product.name,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}

class RelatedOrders extends StatelessWidget {
  RelatedOrders({Key? key, required this.productID}) : super(key: key);
  final DioClient _client = DioClient();
  final int productID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>?>(
      future: _client.getListOrderByProduct(productID: productID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Order>? orders = snapshot.data;

          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (orders != null) {
            if (orders.length == 0) {
              return Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Text("该商品暂无相关订单",
                    style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal,),
              ));
            }

            return Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Stack(
                    children: [
                      Row(children: [
                        Text(
                          "相关订单",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF263238)),
                        ),
                        Spacer(),
                        Icon(Icons.chevron_right),
                      ]),
                      Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return RelatedOrder(orders: orders);
                                    }));
                              },
                            ),
                          ))
                    ]),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: orders.length == null
                    ? 0
                    : (orders.length > 4 ? 4 : orders.length),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: OrderRow(order: orders[index]),
                  );
                  // return Text("found");
                },
              ),
            ]);
          }
        }
        return Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: LinearProgressIndicator(),
        );

      },
    );
  }
}
