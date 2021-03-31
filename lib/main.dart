import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'userScreens/home_page.dart';

void main() {
  // ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  // connectionStatus.initialize();

  runApp(MyApp());
}

final Firestore fb = Firestore.instance;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gugulethu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      // initialRoute: ,
      // routes: ,
    );
  }
}
