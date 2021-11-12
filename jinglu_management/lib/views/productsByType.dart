import 'package:flutter/material.dart';
import 'package:jinglu_management/dio_client.dart';
import 'package:jinglu_management/models/productType.dart';
import 'package:jinglu_management/models/product.dart';
import 'package:jinglu_management/views/productRow.dart';

class ProductsByType extends StatefulWidget {
  const ProductsByType({Key? key}) : super(key: key);

  @override
  State<ProductsByType> createState() => _ProductsByTypeState();
}

class _ProductsByTypeState extends State<ProductsByType> {
  ProductType? _chosenValue;
  final DioClient _client = DioClient();

  ScrollController _controller = ScrollController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("库存列表"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<ProductType>?>(
              future: _client.getListProductType(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<ProductType>? types = snapshot.data;

                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }

                  if (types != null) {
                    return TypeSelectionButton(types);
                  }
                }
                return LinearProgressIndicator();
              },
    ),

              FutureBuilder<List<Product>?>(
                future: _client.getListProductDescriptionByType(typeID: _chosenValue?.id ?? 0),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<Product>? products = snapshot.data;
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }

                    if (products != null) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: products.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index){
                            return ListTile(
                              contentPadding: EdgeInsets.fromLTRB(24, 8, 24, 0),
                              title: productRow(product: products[index]),
                            );
                          },
                        ),
                      );
                    }
                  }
                  return CircularProgressIndicator();
                }
              ),
          ],
        ));
  }

  Widget TypeSelectionButton(List<ProductType> selectionItems){
    return Padding(
      padding: const EdgeInsets.only(left:12.0, top: 16),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Colors.teal,
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.teal),
              borderRadius: BorderRadius.all(Radius.circular(25.0))
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: Padding(
            padding: const EdgeInsets.only(left:20.0, right: 20.0),
            child: DropdownButton(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              value: _chosenValue ?? selectionItems[0],
              // value: selectionItems[0],
              items: selectionItems.map((ProductType item) {
                return DropdownMenuItem(value: item, child: Text(item.type));
              }).toList(),

              onChanged: (ProductType? newValue){
                setState((){
                  this._chosenValue = newValue;
                  print("new" + newValue!.type);
                  print("chosen" + _chosenValue!.type);
                });
              },
              style: TextStyle(
                  color: Colors.white
              ),
              dropdownColor: Colors.teal,
            ),
          ),
        ),
      ),
    );
  }
}

