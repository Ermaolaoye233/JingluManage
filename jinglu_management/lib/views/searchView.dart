import 'package:flutter/material.dart';
import 'package:jinglu_management/dio_client.dart';
import 'package:jinglu_management/models/product.dart';
import 'productRow.dart';
import 'productDescription.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class SearchView extends StatefulWidget {
  SearchView({Key? key}) : super(key: key);




  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController searchController = TextEditingController();
  DioClient _client = DioClient();

  String barcodeScanRes = "no_barcode";
  @override


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SearchBar(),
          FutureBuilder<List<Product>?>(
            future: _client.getListProductDescription(userInput: searchController.text),
              builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<Product>? products = snapshot.data;

                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                if (products != null) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: products.length,
                      itemBuilder: (BuildContext context, int index){
                      return ListTile(title: productRow(product: products[index],));
                      });
                }
              }
              return CircularProgressIndicator();
              })
        ],
      ),
    );


  }
  Widget SearchBar(){
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0,8,0,8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.teal,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Row(children: [
                Icon(
                  Icons.search,
                  color: Colors.white70,
                  size: 26,
                ),
                Padding(
                  padding: const EdgeInsets.only(left:4.0, right: 12),
                  child: SizedBox(
                    width: 220 ,
                    child: TextFormField(
                      controller: searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: "搜索商品",
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,

                      ),
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                      cursorColor: Colors.white,
                      onEditingComplete: (){
                        setState(() {
                          print(searchController.text);
                        });
                      },

                    ),
                  ),
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right:12.0),
                      child: Icon(Icons.qr_code_scanner, color: Colors.white70, size: 26),
                    ),
                    Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#66ccff", "取消", true, ScanMode.BARCODE);
                              if (barcodeScanRes != "no_barcode"){
                                try {
                                  Product? product = await _client.getListProductDescriptionByBarcode(barcode: barcodeScanRes);
                                  if (product == null){
                                    _showWarning("无搜索结果", "无法通过该条形码搜索到对应的物品。");
                                  } else {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                      return ProductDescription(product: product);
                                    }));
                                  }
                                } catch (e) {
                                  _showWarning("出现错误", e.toString());
                                }
                              }
                            },
                          ),
                        ))
                  ],
                )
              ]),
            ),
          ),
        ),
        Spacer(),
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(Icons.cancel),
            ),
            Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ))
          ],
        ),
      ],
    );
  }
  Future<void> _showWarning(String title, String content) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: [Text(content)],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('确认'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
