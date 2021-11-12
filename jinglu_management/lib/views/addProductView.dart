import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jinglu_management/dio_client.dart';
import 'package:jinglu_management/models/product.dart';
import 'package:jinglu_management/models/productType.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:convert';

class AddProductView extends StatefulWidget {
  const AddProductView({Key? key}) : super(key: key);

  @override
  _AddProductViewState createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _inPriceController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _vipPriceController = TextEditingController();

  XFile? photo;
  String? b64image;
  final ImagePicker _picker = ImagePicker();

  String barcodeScanRes = "no_barcode";

  ProductType? _chosenValue;

  DioClient _client = DioClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加商品"),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(children: [
              FutureBuilder<List<ProductType>?>(
                future: _client.getListProductType(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<ProductType>? types = snapshot.data;

                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }

                    if (types != null) {
                      return Row(
                        children: [
                          TypeSelectionButton(types),
                        ],
                      );

                    }
                  }
                  return LinearProgressIndicator();
                },
              ),

              SizedBox(height: 10),

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: "商品名称",
                    hintText: "请输入商品的名称",
                    icon: Icon(Icons.liquor)),
                validator: (v) {
                  return v!.trim().length > 0 ? null : "名称不能为空";
                },
              ),

              SizedBox(height: 10),

              TextFormField(
                controller: _inPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "商品进价",
                    hintText: "请输入商品的进价",
                    icon: Icon(Icons.attach_money)),
                validator: (v) {
                  return v!.trim().length > 0 ? null : "进价不能为空";
                },
              ),

              SizedBox(height: 10),

              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "商品售价",
                    hintText: "请输入商品的售价",
                    icon: Icon(Icons.attach_money)),
                validator: (v) {
                  return v!.trim().length > 0 ? null : "售价不能为空";
                },
              ),

              SizedBox(height: 10),

              TextFormField(
                controller: _vipPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "会员优惠售价",
                    hintText: "请输入针对会员优惠后的价格",
                    icon: Icon(Icons.person)),
                validator: (v) {
                  return v!.trim().length > 0 ? null : "会员优惠售价不能为空";
                },
              ),

              SizedBox(height: 10),

              ElevatedButton.icon(
                icon: Icon(Icons.qr_code),
                  label: Text("扫描条形码"),
                  onPressed: () async {
                    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#66ccff", "取消", true, ScanMode.BARCODE);
                  },
                  ),

              SizedBox(height: 10),



              ElevatedButton.icon(
                icon: Icon(Icons.camera_alt),
                label: Text("添加照片"),
                onPressed: () async {
                  photo = await _picker.pickImage(source: ImageSource.gallery);
                  print("success读取");
                  var photo_byte = await photo!.readAsBytes();
                  print(photo_byte.length);
                  var result = photo_byte;
                  try {
                    var result = await FlutterImageCompress.compressWithList(photo_byte, quality: 20);
                    print("success压缩");
                    print(result.length);
                  } catch (e) {
                    print(e.toString());
                  }
                  b64image = base64Encode(result);
                  print(b64image);
                },
              )
            ]),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SpeedDial(
        label: Text("提交"),
        icon: Icons.check,
        onPress: () async {
          if ((_formKey.currentState as FormState).validate()) {
            try {
              bool? response = await _client.addProduct(
                  product: Product(
                      id: 0,
                      name: _nameController.text,
                      amount: 0,
                      inPrice: double.parse(_inPriceController.text),
                      price: double.parse(_priceController.text),
                      vipPrice: double.parse(_vipPriceController.text),
                      barcode: barcodeScanRes,
                      type: _chosenValue!.id,
                  image: b64image == null ? "no_image" : b64image!));

              if (response == true) {
                Navigator.of(context).pop();
                _showWarning("添加成功", '');
              } else {
                _showWarning("添加失败", '请截图并联系管理员');
              }
            } catch (e) {
              _showWarning("出错", e.toString());
            }
          }
        },
      ),
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

  Widget TypeSelectionButton(List<ProductType> selectionItems) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: Colors.teal,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 1.0, style: BorderStyle.solid, color: Colors.teal),
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: Row(children: [
          Text(
            "商品种类    ",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              value: _chosenValue == null ? _chosenValue = selectionItems[0] : _chosenValue,
              // value: selectionItems[0],
              items: selectionItems.map((ProductType item) {
                return DropdownMenuItem(value: item, child: Text(item.type));
              }).toList(),

              onChanged: (ProductType? newValue) {
                setState(() {
                  this._chosenValue = newValue;
                  print("new" + newValue!.type);
                  print("chosen" + _chosenValue!.type);
                });
              },
              style: TextStyle(color: Colors.white),
              dropdownColor: Colors.teal,
            ),
          ),
        ]),
      ),
    );
  }
}
