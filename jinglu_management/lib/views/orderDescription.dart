import 'package:flutter/material.dart';
import 'package:jinglu_management/models/order.dart';
import 'package:jinglu_management/models/product.dart';
import 'package:jinglu_management/views/userRow.dart';
import 'package:jinglu_management/models/user.dart';
import 'package:jinglu_management/views/productDescription.dart';
import 'package:jinglu_management/dio_client.dart';
import 'package:jinglu_management/views/userDescription.dart';

class OrderDescription extends StatelessWidget {
  OrderDescription({Key? key, required this.order, required this.product})
      : super(key: key);
  final Order order;
  final Product product;
  final DioClient _client = DioClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("订单详情"),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16.0, 28.0, 16.0, 0.0),
        children: [
          Stack(
            children: [
              OrderBar(
                order: order,
                product: product,
              ),
              Positioned.fill(
                  child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProductDescription(product: product);
                    }));
                  },
                ),
              ))
            ],
          ),

          // 操作用户
          FutureBuilder<User?>(
            future: _client.getUserDescription(userID: order.userID.toInt()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                User? user = snapshot.data;

                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                if (user != null) {
                  return OperatingUser(order: order, user: user);
                }
              }
              return LinearProgressIndicator();
            },
          ),

          Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "备注",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF263238)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 252,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFFECEFF1),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            order.description,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF263238),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              children: [
                Text(
                  "订单金额",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF263238)),
                ),
                Spacer(),
                Text(
                  order.price.toString() + " 元",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF26A69A)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderBar extends StatelessWidget {
  const OrderBar({Key? key, required this.order, required this.product})
      : super(key: key);

  final Order order;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(.0, .0, .0, .0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image(
              image: AssetImage("images/placeholder.jpg"),
              width: 122,
              height: 122,
            ),
          ),
          SizedBox(
            height: 122,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20.0),
                    ),
                    Text(
                      product.price.toString() + " 元",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFF26A69A),
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                      ),
                    ),
                    Spacer(),
                    Text(
                      order.getDescription(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFF26A69A),
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                      ),
                    ),
                  ]),
            ),
          ),
          Spacer(),
          Icon(Icons.chevron_right)
        ],
      ),
    );
  }
}

class OperatingUser extends StatelessWidget {
  const OperatingUser({Key? key, required this.order, required this.user})
      : super(key: key);
  final Order order;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "操作员工",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF263238)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Stack(
              children: [
                UserRow(
                  user: user,
                  subWidget: Text(
                    order.getTimeDescription(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFB0BEC5)),
                  ),
                ),
                Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return UserDescription(user: user);
                              }));
                        },
                      ),
                    ))
              ],
            ),
          ),
        ]));
  }
}
