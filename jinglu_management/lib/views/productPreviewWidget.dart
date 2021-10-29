import 'package:flutter/material.dart';
import 'package:jinglu_management/views/productPreview.dart';
import 'package:jinglu_management/models/product.dart';
import 'package:jinglu_management/dio_client.dart';
import 'package:jinglu_management/views/productsByType.dart';


class productPreviewList extends StatelessWidget {
  productPreviewList({Key? key}) : super(key: key);
  final DioClient _client = DioClient();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>?>(
      future: _client.getListProductLatest(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Product>? products = snapshot.data;

          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (products != null) {
            return SizedBox(
              height: 164,
              child: ListView.builder(
                padding: EdgeInsets.only(left: 12),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return ProductPreview(product: products[index]);
                },
              ),
            );
          }
        }
        return LinearProgressIndicator();
      }
      );
  }
}

class productWidget extends StatelessWidget {
  const productWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(17.0,0.0,17.0,2.0),
              child: Stack(
                children: [
                  Row(children: [
                    Text(
                      "库存",
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
                                  return ProductsByType();
                                }));
                          },
                        ),
                      ))
                ],
              ),
            ),
            Positioned(
                child: productPreviewList()),
          ]);
  }
}
