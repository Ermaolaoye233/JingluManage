import 'package:flutter/material.dart';
import 'package:jinglu_management/views/productDescription.dart';
import 'productPreviewWidget.dart';
import 'orderPreviewWidget.dart';
import 'searchView.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'addProductView.dart';
import 'userLogin.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'addOrderView.dart';
import 'package:jinglu_management/dio_client.dart';
import 'package:jinglu_management/models/product.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  String barcodeScanRes = "no_barcode";

  DioClient _client = DioClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // ElevatedButton(
          //     onPressed: () {
          //       Navigator.push(context, MaterialPageRoute(builder: (context) {
          //         return LoginView();
          //       }));
          //     },
          //     child: Padding(
          //         padding: const EdgeInsets.all(16.0),
          //         child: Text("登陆")
          //     )),

          SearchBar(),
          productWidget(),
          Padding(
            padding: const EdgeInsets.only(top: 17.0),
            child: orderWidget(),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        useRotationAnimation: true,
        spacing: 3,
        children: [
          SpeedDialChild(
              child: Icon(
                Icons.description,
              ),
              label: "添加订单",
          onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return AddOrderView();
                }));
          }
          ),
          SpeedDialChild(child: Icon(Icons.liquor), label: "添加商品",
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AddProductView();
            }));
          })
        ],
        openCloseDial: isDialOpen,
      ),
    );
  }

  Widget SearchBar() {
    return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.teal,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(children: [
                 Stack(
                   children: [
                     Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.white70,
                            size: 26,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: SizedBox(
                              width: 250,
                              child: TextFormField(
                                enabled: false,
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
                              ),
                            ),
                          ),
                        ],
                      ),
                     Positioned.fill(
                         child: Material(
                           color: Colors.transparent,
                           child: InkWell(
                             onTap: () {
                               Navigator.push(context, PageRouteBuilder(pageBuilder:
                                   (BuildContext context, Animation<double> animation,
                                   Animation SecondaryAnimation) {
                                 return FadeTransition(
                                   opacity: animation,
                                   child: SearchView(),
                                 );
                               }));
                             },
                           ),
                         ))
                   ],
                 ),
                  Spacer(),
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
            )
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

Widget _buildBody() {
  return Text("");
}
