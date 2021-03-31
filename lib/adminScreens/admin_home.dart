import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_products.dart';
import 'app_messages.dart';
import 'app_orders.dart';
import 'app_products.dart';
import 'app_users.dart';
import 'order_history.dart';
import 'privileges.dart';
import 'search_data.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  Size screenSize;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: new Text("App Admin"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          children: <Widget> [
            new SizedBox(
              height: 20.0,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                new GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (context) => SearchData()));
                  },
                  child: new CircleAvatar(
                    maxRadius: 70.0,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          new Icon(Icons.search),
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text("Search Data"),
                        ]
                    ),
                  ),
                ),
                new GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (context) => AppUsers()));
                  },
                  child: new CircleAvatar(
                    maxRadius: 70.0,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          new Icon(Icons.people),
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text("App Users"),
                        ]
                    ),
                  ),
                ),
              ],
            ),

            new SizedBox(
              height: 20.0,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                new GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (context) => AppOrders()));
                  },
                  child: new CircleAvatar(
                    maxRadius: 70.0,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          new Icon(Icons.notifications),
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text("App Orders"),
                        ]
                    ),
                  ),
                ),
                new GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (context) => AppMessages()));
                  },
                  child: new CircleAvatar(
                    maxRadius: 70.0,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          new Icon(Icons.chat),
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text("App Messages"),
                        ]
                    ),
                  ),
                ),
              ],
            ),

            new SizedBox(
              height: 20.0,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                new GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (context) => AppProducts()));
                  },
                  child: new CircleAvatar(
                    maxRadius: 70.0,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          new Icon(Icons.shop),
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text("App Products"),
                        ]
                    ),
                  ),
                ),
                new GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (context) => AddProducts()));
                  },
                  child: new CircleAvatar(
                    maxRadius: 70.0,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          new Icon(Icons.add),
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text("Add Products"),
                        ]
                    ),
                  ),
                ),
              ],
            ),

            new SizedBox(
              height: 20.0,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                new GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (context) => OrderHistory()));
                  },
                  child: new CircleAvatar(
                    maxRadius: 70.0,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          new Icon(Icons.history),
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text("Order History"),
                        ]
                    ),
                  ),
                ),
                new GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (context) => Privileges()));
                  },
                  child: new CircleAvatar(
                    maxRadius: 70.0,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          new Icon(Icons.person),
                          new SizedBox(
                            height: 10.0,
                          ),
                          new Text("Admin Privileges"),
                        ]
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}