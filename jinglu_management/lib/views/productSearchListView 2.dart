import 'package:flutter/material.dart';
import 'package:jinglu_management/dio_client.dart';
import 'package:jinglu_management/models/product.dart';
import 'package:jinglu_management/views/productRow.dart';
import 'package:jinglu_management/views/productDescription.dart';

class ProductSearchListView extends StatefulWidget {
  const ProductSearchListView({Key? key}) : super(key: key);

  @override
  _productSearchListViewState createState() => _productSearchListViewState();
}

class _productSearchListViewState extends State<ProductSearchListView> {
  final DioClient _client = DioClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Product>?>(
          future: _client.getListProductDescription(userInput: "test"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<Product>? products = snapshot.data;
              // Error Handling
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (products != null) {
                return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index){
                      return ListTile(title: productRow(product: products[index]),
                      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ProductDescription(product: products[index]);
                      }));}
                      ,);
                    });
              }
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
