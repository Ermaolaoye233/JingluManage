import 'package:flutter/material.dart';
import 'package:jinglu_management/models/order.dart';
import 'package:jinglu_management/views/orderDescription.dart';
import 'package:jinglu_management/models/product.dart';
import 'package:jinglu_management/dio_client.dart';

class OrderRow extends StatelessWidget {
  OrderRow({
    Key? key,
    required this.order
  }) : super(key: key);


  final Order order;
  final DioClient _client = DioClient();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product?>(
      future: _client.getProductDescription(id: order.productID.toString()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Product? product = snapshot.data;

          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (product != null) {
            return Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image(
                        image: AssetImage("images/placeholder.jpg"),
                        width: 68,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:13.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text( product.name + ' ' + order.getDescription() ,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color(0xFF263238),
                                fontWeight: FontWeight.w500,
                                fontSize: 20.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:4),
                            child: Text(order.getTimeDescription(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color(0xFFB0BEC5),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500
                              ),),
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.chevron_right_outlined,
                      color: Color(0xFFB0BEC5),
                    )
                  ],
                ),
                Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return OrderDescription(order: order,product: product,);
                              }));
                        },
                      ),
                    ))
              ],
            );
          }
        }
        return SizedBox(
          width: 50,
            height: 50,
            child: CircularProgressIndicator());
    }
    );

  }
}