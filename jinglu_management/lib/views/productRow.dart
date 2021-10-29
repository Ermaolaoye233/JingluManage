import 'package:flutter/material.dart';
import 'package:jinglu_management/models/product.dart';

class productRow extends StatelessWidget {
  const productRow({
    Key? key,
    required this.product
  }) : super(key: key);

  final Product product;
  @override
  Widget build(BuildContext context) {
    return Row(
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
              Text(product.name,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color(0xFF263238),
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top:4),
                child: Text("现有 " + product.amount.toString() + " 件",
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
          color: Color(0xFF263238),
        )
      ],
    );
  }
}