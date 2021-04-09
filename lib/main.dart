import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/views/profile.dart';

import 'views/about_us.dart';
import 'views/address.dart';
import 'views/cart.dart';
import 'views/favorites.dart';
import 'views/history.dart';
import 'views/home.dart';
import 'views/login.dart';
import 'views/messages.dart';
import 'views/notifications.dart';
import 'views/shared/app_colors.dart';
import 'views/signup.dart';

void main() {
  // ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  // connectionStatus.initialize();

  runApp(MyApp());
}

final Firestore fb = Firestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gugulethu',
      theme: ThemeData(primarySwatch: primaryColor),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => Home(),
        '/about': (BuildContext context) => AboutUs(),
        '/address': (BuildContext context) => Address(),
        '/cart': (BuildContext context) => Cart(),
        '/fav': (BuildContext context) => Favorites(),
        '/his': (BuildContext context) => History(),
        '/chat': (BuildContext context) => Messages(),
        '/login': (BuildContext context) => Login(),
        '/register': (BuildContext context) => SignUp(),
        '/notifications': (BuildContext context) => Notifications(),
        '/profile': (BuildContext context) => Profile(),
      },
    );
  }
}
