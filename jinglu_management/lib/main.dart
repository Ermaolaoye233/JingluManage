import 'package:flutter/material.dart';
import 'package:jinglu_management/views/orderDescription.dart';
import 'package:jinglu_management/models/order.dart';
import 'package:jinglu_management/models/product.dart';
import 'package:jinglu_management/views/defaultView.dart';
import 'package:jinglu_management/views/mainMenu.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh'),
      ],
      locale: const Locale('zh'),
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.teal,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: Color(0x263238FF)
          )
        ).apply(
          bodyColor: Color(0x263238FF)
        )
      ),
      home: MainMenu(),
    );
  }
}