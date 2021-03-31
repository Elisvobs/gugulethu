import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/main.dart';
import 'package:onlineshop/tools/app_data.dart';
import 'package:onlineshop/tools/app_methods.dart';
import 'package:onlineshop/tools/app_tools.dart';
import 'package:onlineshop/tools/firebase_methods.dart';

import 'about_us.dart';
import 'address.dart';
import 'cart.dart';
import 'favorites.dart';
import 'history.dart';
import 'item_details.dart';
import 'login.dart';
import 'messages.dart';
import 'notifications.dart';
import 'profile.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // StreamSubscription _connectionChangeStream;

  int msgCount = 0;
  int cartCount = 0;

  bool isOffline = false;
  BuildContext context;
  String accName = "";
  String accEmail = "";
  String accPhotoUrl = "";
  bool isLoggedIn;
  AppMethods appMethods = new FirebaseMethods();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // ConnectionStatusSingleton connectionStatus =
    //     ConnectionStatusSingleton.getInstance();
    // _connectionChangeStream =
    //     connectionStatus.connectionChange.listen(connectionChanged);
    getCurrentUser();
  }

  // void connectionChanged(dynamic hasConnection) {
  //   setState(() {
  //     isOffline = !hasConnection;
  //   });
  // }

  Future getCurrentUser() async {
    accName = await getDataLocally(key: accountName);
    accEmail = await getDataLocally(key: userEmail);
    accPhotoUrl = await getDataLocally(key: photoUrl);
    isLoggedIn = await getBoolDataLocally(key: loggedIn);

    accName == null ? accName = "Guest" : accName;
    accEmail == null ? accEmail = "guest@email.com" : accEmail;
    isLoggedIn == false ? "Login" : "Logout";

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot snapshot;
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new GestureDetector(
          onLongPress: () {
//            Navigator.of(context)
//                .push(new CupertinoPageRoute(builder: (BuildContext context) {
//              return new AdminHome();
//            }));
          },
          child: new Text("Gugulethu"),
        ),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              // isLoggedIn == false
              // ? showSnackBar(
              //     "Please login to view your favorites!", scaffoldKey)
              // : Navigator.of(context).push(new CupertinoPageRoute(
              //     builder: (BuildContext context) => new Favorites()));
              Navigator.of(context).push(new CupertinoPageRoute(
                  builder: (BuildContext context) => new Favorites()));
            },
          ),
          new IconButton(
            icon: new Icon(Icons.chat, color: Colors.white),
            onPressed: () {
              // isLoggedIn == false
              //     ? showSnackBar(
              //         "Please login to view your messages!", scaffoldKey)
              //     : Navigator.of(context).push(new CupertinoPageRoute(
              //         builder: (BuildContext context) => new Messages()));
              Navigator.of(context).push(new CupertinoPageRoute(
                  builder: (BuildContext context) => new Messages()));
            },
          )
        ],
      ),
      body: new StreamBuilder(
          stream: fb.collection(appProducts).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return new Center(
                child: new CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              );
            } else {
              final int dataCount = snapshot.data.documents.length;
              print("data count $dataCount");
              if (dataCount == 0) {
                return noDataFound();
              } else {
                return new GridView.builder(
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: dataCount,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot document =
                        snapshot.data.documents[index];
                    return buildProducts(context, index, document);
                  },
                );
              }
            }
          }),
      floatingActionButton: new Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          new FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(new CupertinoPageRoute(
                  builder: (BuildContext context) => new Cart()));
            },
            child: new Icon(Icons.shopping_cart),
          ),
        ],
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(accName),
              accountEmail: new Text(accEmail),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.white,
                child: new Icon(Icons.person),
              ),
            ),
            new ListTile(
              leading: new CircleAvatar(
                child: new Icon(Icons.notifications,
                    color: Colors.white, size: 20.0),
              ),
              title: new Text("Order Notifications"),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new Notifications()));
                // isLoggedIn == false
                //     ? showSnackBar(
                //     "Please login to view your favorites!", scaffoldKey)
                //     : Navigator.of(context).push(new CupertinoPageRoute(
                //     builder: (BuildContext context) => new Notifications()));
              },
            ),
            new ListTile(
              leading: new CircleAvatar(
                child: new Icon(Icons.history, color: Colors.white, size: 20.0),
              ),
              title: new Text("Order History"),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new History()));
                // isLoggedIn == false
                //     ? showSnackBar(
                //     "Please login to view your history!", scaffoldKey)
                //     : Navigator.of(context).push(new CupertinoPageRoute(
                //     builder: (BuildContext context) => new History()));
              },
            ),
            new Divider(),
            new ListTile(
              leading: new CircleAvatar(
                child: new Icon(Icons.person, color: Colors.white, size: 20.0),
              ),
              title: new Text("Profile Settings"),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new Profile()));
                // isLoggedIn == false
                //     ? showSnackBar(
                //     "Please login to modify your profile!", scaffoldKey)
                //     : Navigator.of(context).push(new CupertinoPageRoute(
                //     builder: (BuildContext context) => new Profile()));
              },
            ),
            new ListTile(
              leading: new CircleAvatar(
                child: new Icon(Icons.home, color: Colors.white, size: 20.0),
              ),
              title: new Text("Delivery Address"),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new Address()));
                // isLoggedIn == false
                //     ? Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context)=> Login()))
                //     : Navigator.of(context).push(new CupertinoPageRoute(
                //     builder: (BuildContext context) => new Address()));
              },
            ),
            new Divider(),
            new ListTile(
              trailing: new CircleAvatar(
                child:
                    new Icon(Icons.live_help, color: Colors.white, size: 20.0),
              ),
              title: new Text("About Us"),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new AboutUs()));
              },
            ),
            new ListTile(
                trailing: new CircleAvatar(
                  child: new Icon(Icons.exit_to_app,
                      color: Colors.white, size: 20.0),
                ),
                title: new Text(isLoggedIn == true ? "Logout" : "Login"),
                onTap: () async {
//                checkIfLoggedIn();
                  if (isLoggedIn == false) {
                    bool response = await Navigator.of(context).push(
                        new CupertinoPageRoute(
                            builder: (BuildContext context) => new Login()));
                    if (response == true) getCurrentUser();
                    return;
                  }
                  bool response = await appMethods.logOutUser();
                  if (response == true) getCurrentUser();
                }),
          ],
        ),
      ),
    );
  }

  checkIfLoggedIn() async {
    if (isLoggedIn == false) {
      bool response = await Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new Login()));
      if (response == true) getCurrentUser();
      return;
    }
    bool response = await appMethods.logOutUser();
    if (response == true) getCurrentUser();
  }

  Widget buildProducts(context, index, DocumentSnapshot document) {
    List productImage = document[productImages] as List;
    List productColors = document[productColor] as List;
    List productSizes = document[productSize] as List;

    return new GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (context) => new ItemDetail(
              itemImage: productImage[0],
              itemImages: productImage,
              itemName: document[productTitle],
              itemSubName: document[productCategory],
              itemDesc: document[productDescription],
              itemPrice: document[productPrice],
              itemRating: document[productRating],
              itemColors: productColors,
              itemSizes: productSizes,
            ),
          ),
        );
      },
      child: new Card(
        child: new Stack(
          alignment: FractionalOffset.topLeft,
          children: <Widget>[
            new Stack(
              alignment: FractionalOffset.bottomCenter,
              children: <Widget>[
                new Container(
                  // decoration: new BoxDecoration(
                  //   image: new DecorationImage(
                  //     fit: BoxFit.fitWidth,
                  //     image: new NetworkImage(productImage[0]),
                  //   ),
                  // ),
                  child: ClipRRect(
                    // borderRadius: new BorderRadius.circular(16.0),
                    child: FadeInImage.assetNetwork(
                      height: 160.0,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      image: productImage[0],
                      placeholder: 'assets/images/placeholder.png',
                      // placeholder: kTransparentImage,
                    ),
                  ),
                ),
                new Container(
                  height: 50.0,
                  width: double.infinity,
                  color: Colors.black.withAlpha(100),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                        "${document[productTitle]}",
                        style: new TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      new Text(
                        "USD${document[productPrice]}",
                        style: new TextStyle(
                          color: Colors.red[500],
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            // new Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: <Widget>[
            //     new Container(
            //       height: 30.0,
            //       width: 50.0,
            //       decoration: new BoxDecoration(
            //         color: Colors.black,
            //         borderRadius: new BorderRadius.only(
            //           topRight: new Radius.circular(5.0),
            //           bottomRight: new Radius.circular(5.0),
            //         ),
            //       ),
            //       child: new Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: <Widget>[
            //             new Icon(
            //               Icons.star,
            //               color: Colors.blue,
            //             ),
            //             new Text(
            //               "${document[productRating]}",
            //               style: new TextStyle(color: Colors.white),
            //             ),
            //           ]),
            //     ),
            //     // new IconButton(
            //     //   icon: new Icon(
            //     //     Icons.favorite_border,
            //     //     color: Colors.blue,
            //     //   ),
            //     //   onPressed: () {},
            //     // )
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  Widget noDataFound() {
    return new Container(
      child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(Icons.find_in_page, color: Colors.black45, size: 80.0),
            new Text(
              "No Product available yet",
              style: new TextStyle(color: Colors.black45, fontSize: 20.0),
            ),
            new SizedBox(height: 10.0),
            new Text(
              "Please check back later!",
              style: new TextStyle(color: Colors.red, fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}
