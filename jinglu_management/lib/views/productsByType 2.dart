import 'package:flutter/material.dart';
import 'package:jinglu_management/dio_client.dart';
import 'package:jinglu_management/models/productType.dart';

class ProductsByType extends StatefulWidget {
  const ProductsByType({Key? key}) : super(key: key);

  @override
  State<ProductsByType> createState() => _ProductsByTypeState();
}

class _ProductsByTypeState extends State<ProductsByType> {
  ProductType _chosenValue = ProductType(id: 0, type: "");
  final DioClient _client = DioClient();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("库存列表"),
        ),
        body: Column(
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
                    _chosenValue = types.first;
                    return TypeSelectionButton(types);
                  }
                }
                return LinearProgressIndicator();
              },
            )
          ],
        ));
  }

  Widget TypeSelectionButton(List<ProductType> selectionItems){
    return Padding(
      padding: const EdgeInsets.only(left:16.0, top: 16),
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
              value: _chosenValue,
              items: selectionItems.map((ProductType item) {
                return DropdownMenuItem(value: item, child: Text(item.type));
              }).toList(),

              onChanged: (ProductType? newValue){
                setState((){
                  _chosenValue = newValue!;
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
