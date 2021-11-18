import 'package:flutter/material.dart';
import 'package:jinglu_management/views/productPreview.dart';
import 'package:jinglu_management/views/userLogin.dart';
import 'productPreviewWidget.dart';
import 'orderPreviewWidget.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
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
          productWidget(),
          Padding(
            padding: const EdgeInsets.only(top:17.0),
            child: orderWidget(),
          ),
        ],
      ),
    );
  }
}

Widget _buildBody() {
  return Text("");
}