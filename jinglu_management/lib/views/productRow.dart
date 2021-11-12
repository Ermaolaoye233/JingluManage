import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jinglu_management/models/product.dart';
import 'package:jinglu_management/views/productDescription.dart';
import 'package:jinglu_management/models/images.dart';

class productRow extends StatelessWidget {
  productRow({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              // child: Image(
              //   image: AssetImage("images/placeholder.jpg"),
              //   width: 68,
              // ),
              child: Image.memory(
                product.image == "no_image"
                    ? base64Decode(placeholder_b64String)
                    : base64Decode(product.image),
                width: 68,
                height: 68,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color(0xFF263238),
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "现有 " + product.amount.toString() + " 件",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color(0xFFB0BEC5),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                    ),
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
        ),
        Positioned.fill(
            child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProductDescription(product: product);
              }));
            },
          ),
        ))
      ],
    );
  }
}
