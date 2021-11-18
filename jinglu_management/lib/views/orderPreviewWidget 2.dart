import 'package:flutter/material.dart';
import 'package:jinglu_management/views/orderRow.dart';
import 'package:jinglu_management/models/order.dart';
import 'package:jinglu_management/views/ordersByDay.dart';
import 'package:jinglu_management/dio_client.dart';

class orderWidget extends StatelessWidget {
  orderWidget({Key? key}) : super(key: key);
  final DioClient _client = DioClient();

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(17.0, 0.0, 17.0, 10.0),
            child: Stack(
              children: [
                Row(children: [
                  Text(
                    "订单",
                    style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.w500,
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
                                return OrderListByDay();
                              }));
                        },
                      ),
                    ))
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(16.0, 2, 16.0, 0),
          //   child: OrderRow(order: sampleOrder),
          // )
          FutureBuilder<List<Order>?>(
            future: _client.getListOrderLatest(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<Order>? orders = snapshot.data;

                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                if (orders != null) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: orders.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 10),
                        child: OrderRow(order: orders[index]),
                      );
                    },
                  );
                }
              }
              return LinearProgressIndicator();
            })
        ]);
  }
}
