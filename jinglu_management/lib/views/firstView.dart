import 'package:flutter/material.dart';
import 'userLogin.dart';
import 'mainMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class FirstView extends StatefulWidget {
  const FirstView({Key? key}) : super(key: key);

  @override
  State<FirstView> createState() => _FirstViewState();
}

class _FirstViewState extends State<FirstView> {

  FutureOr RefreshThePage(dynamic value) {
    setState((){});
  }

  Future<bool> jwtIsStored() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwt = prefs.getString('jwt');
    if (jwt == 'no_jwt' || jwt == null){
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(future: jwtIsStored(),builder: (context, snapshot) {
            if (snapshot.data == false) {
              return Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) {
                        return LoginView();
                      })).then(RefreshThePage);
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("登陆")
                    )),
              );
            } else if(snapshot.data == true) {
              return MainMenu();
            }
            return CircularProgressIndicator();
          })
    );
  }
}
