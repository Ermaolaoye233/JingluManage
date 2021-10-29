import 'package:flutter/material.dart';
import 'package:jinglu_management/models/user.dart';
import 'package:jinglu_management/dio_client.dart';
import 'package:jinglu_management/models/order.dart';
import 'package:jinglu_management/views/orderRow.dart';
import 'package:jinglu_management/views/relatedOrders.dart';

class UserDescription extends StatelessWidget {
  const UserDescription({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("员工详情"),
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(16.0, 28.0, 16.0, 0.0),
            children: <Widget>[
              UserBar(userName: user.name),

              RelatedOrdersByUser(userID: user.id),
            ],
          ),
        );
  }
}

class UserBar extends StatelessWidget {
  const UserBar({Key? key, required this.userName}) : super(key: key);

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(.0, .0, .0, .0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image(
                image: AssetImage("images/placeholder.jpg"),
                width: 122,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                userName,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RelatedOrdersByUser extends StatelessWidget {
  RelatedOrdersByUser({Key? key, required this.userID}) : super(key: key);
  final DioClient _client = DioClient();
  final int userID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>?>(
      future: _client.getListOrderByUser(userID: userID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Order>? orders = snapshot.data;

          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (orders != null) {
            if (orders.length == 0) {
              return Text("该商品暂无相关订单",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF263238)),);
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

