import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/main.dart';
import 'package:onlineshop/tools/app_data.dart';
import 'package:onlineshop/tools/app_methods.dart';
import 'package:onlineshop/tools/app_tools.dart';
import 'package:onlineshop/tools/firebase_methods.dart';
import 'package:onlineshop/userScreens/cart.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  AppMethods appMethods = new FirebaseMethods();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;
  var refreshMenuKey = GlobalKey<RefreshIndicatorState>();
  int cartCount;
  final int dataCount = 0;
  bool isInCart;
  bool isFavorite;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new GestureDetector(
          onLongPress: () {},
          child: new Text(
            "My Favorites",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () => Navigator.of(context).push(
              new CupertinoPageRoute(
                builder: (BuildContext context) => new Cart(),
              ),
            ),
          ),
        ],
      ),
      body: new StreamBuilder(
        stream: fb.collection('appProducts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Center(
              child: new CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            );
          } else {
            final int favCount = snapshot.data.documents.length;
            if (favCount == 0) {
              return noFavorites();
            } else {
              return new GridView.builder(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: favCount,
                itemBuilder: (context, index) {
                  final DocumentSnapshot document =
                      snapshot.data.documents[index];
                  return buildFavorites(context, index, document);
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget buildFavorites(context, index, DocumentSnapshot document) {
    List productImage = document[productImages] as List;
    final buttons = new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new Container(
          height: 20.0,
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
          ),
          child: new Center(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: new Icon(
                    Icons.delete_forever,
                    size: 15.0,
                    color: Colors.red,
                  ),
                ),
                new GestureDetector(
                  onTap: () {
                    //TODO delete from favorites collection
                    showSnackBar(
                        /*widget.fbConn.getProductNameAsList()[widget.index] +*/
                        "Removed ${document[productTitle]} from favorites",
                        scaffoldKey);
                    isFavorite = false;
                    setState(() {});
                  },
                  child: new Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: new Text(
                      "REMOVE",
                      style: new TextStyle(
                        color: Colors.red,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        new Container(
          height: 20.0,
          width: 1.0,
          color: Colors.black12,
          margin: const EdgeInsets.only(left: 2.0, right: 2.0),
        ),
        new Container(
          height: 20.0,
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
          ),
          child: new Center(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: new Icon(
                    Icons.add_shopping_cart,
                    size: 15.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                new GestureDetector(
                  //TODO proceed to payments page
                  onTap: () {
                    bool fav = true;
                    isInCart = fav;
                    // firestore.collection('favorites').document(userID).setData({
                    // fb.collection('cart').add({
                    //   'isFavorite': fav,
                    //   'product': productTitle,
                    //   'price': productPrice,
                    //   'image': productImage,
                    //   // 'quantity': defaultQuantity,
                    //   'color': productColor,
                    //   'size': productSize,
                    //   // 'isFavorite': isFavorite,
                    // });
                    showSnackBar(
                        " Added ${document[productTitle]} to your cart",
                        scaffoldKey);
                    setState(() {});
                  },
                  child: new Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: new Text(
                      "SHOP",
                      style: new TextStyle(
                        color: Colors.black,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
    return GestureDetector(
      onLongPress: () {},
      child: new Card(
        elevation: 4.0,
        child: new GridTile(
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(4.0),
                child: new Container(
                  child: ClipRRect(
                    child: FadeInImage.assetNetwork(
                      height: 100.0,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      image: productImage[0],
                      placeholder: 'assets/images/placeholder.png',
                      // placeholder: kTransparentImage,
                    ),
                  ),
                  // decoration: new BoxDecoration(
                  //   image: new DecorationImage(
                  //     fit: BoxFit.fitWidth,
                  //     image: new NetworkImage(productImage[0]),
                  //   ),
                  // ),
                ),
              ),
              new Align(
                alignment: Alignment.center,
                child: new Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: new Text(
                    "${document[productTitle]}",
                  ),
                ),
              ),
              buttons,
            ],
          ), //just for testing, will fill with image later
        ),
      ),
    );
  }

  Widget noFavorites() {
    return new Container(
      constraints: const BoxConstraints(maxHeight: 500.0),
      child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              margin: new EdgeInsets.only(top: 00.0, bottom: 0.0),
              height: 150.0,
              width: 150.0,
              child: new Image.asset('assets/images/empty.png'),
            ),
            new Padding(
              padding: const EdgeInsets.all(5.0),
              child: new Text(
                "You have nothing in your favorites...",
                style: new TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
