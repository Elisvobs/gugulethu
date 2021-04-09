import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/tools/app_data.dart';
import 'package:onlineshop/tools/app_methods.dart';
import 'package:onlineshop/tools/app_tools.dart';
import 'package:onlineshop/tools/firebase_methods.dart';

import '../main.dart';
import 'item_details.dart';
import 'login.dart';
import 'shared/app_colors.dart';
import 'shared/icons.dart';
import 'shared/styles.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

    // ignore: unnecessary_statements
    accName == null ? accName = "Guest" : accName;
    // ignore: unnecessary_statements
    accEmail == null ? accEmail = "guest@email.com" : accEmail;
    // ignore: unnecessary_statements
    isLoggedIn == false ? "Login" : "Logout";

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text("Gugulethu"),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.favorite, color: white),
            onPressed: () {
              // isLoggedIn == false
              // ? showSnackBar(
              //     "Please login to view your favorites!", scaffoldKey)
              // : Navigator.of(context).pushNamed('/fav');
              Navigator.of(context).pushNamed('/fav');
            },
          ),
          new IconButton(
            icon: new Icon(Icons.chat, color: white),
            onPressed: () {
              // isLoggedIn == false
              //     ? showSnackBar(
              //         "Please login to view your messages!", scaffoldKey)
              //     : Navigator.of(context).pushNamed('/chat');
              Navigator.of(context).pushNamed('/chat');
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
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
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
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(accName),
              accountEmail: new Text(accEmail),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: white,
                child: person,
              ),
            ),
            new ListTile(
              leading: new CircleAvatar(child: notifications),
              title: new Text("Order Notifications"),
              onTap: () {
                Navigator.of(context).pushNamed('/notifications');
                // isLoggedIn == false
                //     ? showSnackBar(
                //     "Please login to view your favorites!", scaffoldKey)
                //     : Navigator.of(context).pushNamed('/notifications');
              },
            ),
            new ListTile(
              leading: new CircleAvatar(child: history),
              title: new Text("Order History"),
              onTap: () {
                Navigator.of(context).pushNamed('/his');
                // isLoggedIn == false
                //     ? showSnackBar(
                //     "Please login to view your history!", scaffoldKey)
                //     : Navigator.of(context).pushNamed('/his');
              },
            ),
            new Divider(),
            new ListTile(
              leading: new CircleAvatar(child: profiles),
              title: new Text("Profile Settings"),
              onTap: () {
                Navigator.of(context).pushNamed('/profile');
                // isLoggedIn == false
                //     ? showSnackBar(
                //     "Please login to modify your profile!", scaffoldKey)
                //     : Navigator.of(context).pushNamed('/profile')
              },
            ),
            new ListTile(
              leading: new CircleAvatar(child: homes),
              title: new Text("Delivery Address"),
              onTap: () {
                Navigator.of(context).pushNamed('/address');
                // isLoggedIn == false
                //     ? Navigator.of(context).pushNamed('/login')
                //     : Navigator.of(context).pushNamed('/address');
              },
            ),
            new Divider(),
            new ListTile(
              trailing: new CircleAvatar(child: aboutUs),
              title: new Text("About Us"),
              onTap: () => Navigator.of(context).pushNamed('/about'),
            ),
            new ListTile(
              trailing: new CircleAvatar(child: logout),
              title: new Text(isLoggedIn == true ? "Logout" : "Login"),
              onTap: () async {
//                checkIfLoggedIn();
                if (isLoggedIn == false) {
                  bool response = await Navigator.of(context).push(
                    new CupertinoPageRoute(
                      builder: (BuildContext context) => new Login(),
                    ),
                  );

                  if (response == true) getCurrentUser();
                  return;
                }
                bool response = await appMethods.logOutUser();
                if (response == true) getCurrentUser();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: new Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          new FloatingActionButton(
            onPressed: () => Navigator.of(context).pushNamed('/cart'),
            child: cart,
          ),
        ],
      ),
    );
  }

  checkIfLoggedIn() async {
    if (isLoggedIn == false) {
      bool response = await Navigator.of(context).pushNamed('/login');
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
              //TODO add default quantity at 1
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
                  child: ClipRRect(
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
                  color: black.withAlpha(100),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text("${document[productTitle]}", style: whiteTxt),
                      new Text("USD${document[productPrice]}", style: priceTxt),
                    ],
                  ),
                )
              ],
            ),
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
            new Icon(Icons.find_in_page, color: black, size: 80.0),
            new Text("No Product available yet", style: noProd),
            new SizedBox(height: 10.0),
            new Text("Please check back later!", style: later),
          ],
        ),
      ),
    );
  }
}
