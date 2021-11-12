import 'package:flutter/material.dart';
import 'package:jinglu_management/dio_client.dart';
import 'package:jinglu_management/models/order.dart';
import 'package:jinglu_management/models/product.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'productRowNotClickable.dart';
import 'searchView4addOrder.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class AddOrderView extends StatefulWidget {
  const AddOrderView({Key? key}) : super(key: key);

  @override
  _AddOrderViewState createState() => _AddOrderViewState();
}

class _AddOrderViewState extends State<AddOrderView> {
  GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  bool _isEnabled = false;

  Product _productSelected = Product(
      id: 0,
      name: "请选择商品",
      amount: 0,
      inPrice: 0,
      price: 0,
      vipPrice: 0,
      barcode: "",
      type: 0,
  image: "no_image");
  bool _typeSelected = false;

  DioClient _client = DioClient();

  void updateInformation(Product updateProduct) {
    print(updateProduct.toString());
    setState(() { _productSelected = updateProduct;
    _isEnabled = true;
    });
    print(_productSelected.toString());
  }

  void moveToSearchPage() async {
    final Product updateProduct =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SearchViewChoose();
    }));
    print("succeed");
    updateInformation(updateProduct);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("添加订单")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: [
              Stack(children: [
                productRow(_productSelected),
                Positioned.fill(
                    child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      moveToSearchPage();
                    },
                  ),
                ))
              ]),
              SizedBox(height:10),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "订单数量",
                    hintText: "请输入订单的数量",
                    icon: Icon(Icons.pin),
                    suffixText: "件"),
                validator: (v) {
                  return v!.trim().length > 0 ? null : "数量不能为空";
                },
              ),
              SizedBox(height:10),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "订单价格",
                    hintText: "请输入订单的价格",
                    icon: Icon(Icons.attach_money),
                    suffixText: "元"),
                validator: (v) {
                  return v!.trim().length > 0 ? null : "价格不能为空";
                },
              ),
              SizedBox(height:20),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xFFECEFF1)
                ),
                child: TextFormField(
                    controller: _descriptionController,
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "请输入备注",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16)
                    ),
                  validator: (v) {
                    return v!.trim().length > 0 ? null : "备注不能为空";
                  },),
              ),
              SizedBox(height:20),
              Row(
                children: [
                  Text(
                    "订单类型",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  Spacer(),
                  FlutterSwitch(
                      height: 32,
                      value: _typeSelected,
                      showOnOff: true,
                      activeText: "出库",
                      inactiveText: "入库",
                      onToggle: (value) {
                        setState(() {
                          _typeSelected = value;
                        });
                      }),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SpeedDial(
        visible: _isEnabled,
        label: Text("提交"),
        icon: Icons.check,
        onPress: () async {
          if ((_formKey.currentState as FormState).validate()) {
            try {
              bool? response = await _client.addOrders(
                  order: Order(
                      id: 0,
                      userID: 0,
                      productID: _productSelected.id,
                      amount: int.parse(_amountController.text),
                      price: double.parse(_priceController.text),
                      description: _descriptionController.text,
                      type: _typeSelected ? 1 : 0,
                      time: ""));
              if (response == true) {
                Navigator.of(context).pop();
                _showWarning("添加成功", '');
              } else {
                _showWarning("添加失败", "请截图并联系管理员");
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
}
