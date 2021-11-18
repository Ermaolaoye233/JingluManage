import 'package:flutter/material.dart';
import 'package:jinglu_management/views/userLogin.dart';

class DefaultView extends StatefulWidget {
  const DefaultView({Key? key}) : super(key: key);

  @override
  _DefaultViewState createState() => _DefaultViewState();
}

class _DefaultViewState extends State<DefaultView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LoginView();
                  }));
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("登陆")
                )
            ),
          ],
        ),
      ),
    );
  }
}
