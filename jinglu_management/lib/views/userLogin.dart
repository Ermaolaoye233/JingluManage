import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:jinglu_management/models/loginUser.dart';
import 'package:jinglu_management/models/user.dart';
import 'package:jinglu_management/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _unameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  GlobalKey _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  final DioClient _client = DioClient();

  var _loginSucceed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户登陆"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12.0,100.0,12.0,.0),
        child: Column(
          children: [
            Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  controller: _unameController,
                  decoration: InputDecoration(
                    labelText: "手机号",
                    hintText: "请输入您的手机号",
                    icon: Icon(Icons.phone),
                  ),
                  validator: (v) {
                    return v!.trim().length > 0 ? null : "用户名不能为空";
                  },
                ),

                TextFormField(
                  controller: _pwdController,
                  decoration: InputDecoration(
                    labelText: "密码",
                    hintText: "请输入您的密码",
                    icon: Icon(Icons.lock),
                  ),
                  validator: (v) {
                    return v!.trim().length > 0 ? null : "密码不能为空";
                  },
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: RoundedLoadingButton(
                    child: Text('登陆'),
                    controller: _btnController,
                    onPressed: _onLogin,
                    borderRadius: 4,
                  ),
                )

              ],
            ),
          ),
          ]
        ),
      ),
    );
  }

  void _onLogin() async{
    if ((_formKey.currentState as FormState).validate()) {
      User? user;
      try {
        user = await _client.userLogin(loginUser: LoginUser(phone: _unameController.text, password: _pwdController.text));
        if (user != null) {
          print(user.name);
          _btnController.success();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt', user.jwt);
          await prefs.setString('name', user.name);
          await prefs.setInt('userID', user.id);
          Navigator.of(context).pop();
          _showWarning('登陆成功', '');
        }
      } on DioError catch (error) {
        print("error123123123");
        if (error.response?.statusCode == 401){
            print("密码错误");
            _showWarning('密码错误', '您输入的密码有误，请重试。');
            _btnController.reset();
        };
        if (error.response?.statusCode == 400){
          _showWarning('用户不存在', '您输入的手机号未在本 App 注册，请检查后重试。');
          _btnController.reset();
        }

      }
    } else {
      _btnController.reset();
    }

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
              children: [
                Text(content)
              ],
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
      }
    );
  }
}
