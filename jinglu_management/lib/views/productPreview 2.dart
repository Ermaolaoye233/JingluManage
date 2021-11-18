import 'package:flutter/material.dart';
import 'package:jinglu_management/models/product.dart';
import 'package:jinglu_management/views/productDescription.dart';

// class ProductPreview extends StatefulWidget {
//   const ProductPreview({Key? key}) : super(key: key);
//
//   @override
//   _ProductPreviewState createState() => _ProductPreviewState();
// }

class ProductPreview extends StatelessWidget {
  const ProductPreview({
    Key? key,
    required this.product
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 139,
      height: 164,
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18.0))),
        child: new Stack(alignment: Alignment.bottomLeft, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              child: Image(
                image: AssetImage("images/placeholder.jpg"),
                width: 139,
                height: 164,
                fit: BoxFit.cover,
              ),
              foregroundDecoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment(-1, -1),
                    end: Alignment(-1, -0.6),
                    colors: [Colors.black38, Colors.transparent]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                      shadows: [
                        Shadow(
                            offset: Offset(0.0, 1.0),
                            blurRadius: 5.0,
                            color: Colors.black26)
                      ],
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFECEFF1)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Text(
                    product.amount.toString() + " 件",
                    style: TextStyle(shadows: [
                      Shadow(
                          offset: Offset(0.0, 1.0),
                          blurRadius: 5.0,
                          color: Colors.black26)
                    ], fontSize: 14.0, color: Color(0xFFECEFF1)),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProductDescription(product: product);
                }));
              },
            ),
          ))
        ]),
      ),
    );
  }
}
