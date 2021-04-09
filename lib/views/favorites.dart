import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineshop/tools/app_data.dart';
import 'package:onlineshop/tools/app_methods.dart';
import 'package:onlineshop/tools/app_tools.dart';
import 'package:onlineshop/tools/firebase_methods.dart';
import 'package:onlineshop/views/check_out.dart';
import 'package:onlineshop/views/shared/icons.dart';

import '../main.dart';
import 'shared/app_colors.dart';
import 'shared/styles.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  AppMethods appMethods = new FirebaseMethods();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isFavorite;
  String noItem = "You have nothing in your favorites...";

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
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: white,
      appBar: new AppBar(
        title: new Text("My Favorites"),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.shopping_cart, color: white),
            onPressed: () => Navigator.of(context).pushNamed('/cart'),
          ),
        ],
      ),
      body: new StreamBuilder(
        stream: fb.collection('appProducts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Center(
              child: new CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
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
    String checkout = 'Checking out ${document[productTitle]}';
    String minusCart = 'Removed ${document[productTitle]} from your cart';
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
                  child: new Icon(Icons.delete_forever, size: 15.0, color: red),
                ),
                new GestureDetector(
                  onTap: () => showRemoveDialog(context, document),
                  child: new Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: new Text("REMOVE", style: favTxt),
                  ),
                ),
              ],
            ),
          ),
        ),
        new Container(
          height: 20.0,
          width: 1.0,
          color: black,
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
                  child: addToCart,
                ),
                new GestureDetector(
                  onTap: () => showShopDialog(context),
                  child: new Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: new Text("SHOP", style: favShop),
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
                  child: new Text("${document[productTitle]}"),
                ),
              ),
              buttons,
            ],
          ), //just for testing, will fill with image later
        ),
      ),
    );
  }

  showRemoveDialog(BuildContext context, DocumentSnapshot document) {
    String minusCart = 'Removed ${document[productTitle]} from your favorites';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove ${document[productTitle]} from favorites?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
          FlatButton(
            child: Text("Yes"),
            onPressed: () {
              fb
                  .collection('appProducts')
                  // .document(document.documentID)
                  .document()
                  .delete()
                  .then((value) => Navigator.pop(context));
              showSnackBar(minusCart, scaffoldKey);
              Navigator.pop(context);
              isFavorite = false;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  showShopDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Proceed to checkout?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
          FlatButton(
            child: Text("Yes"),
            //TODO get the prices and total items from the shop item to checkout
            onPressed: () {
              Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => new CheckOut()));
              Navigator.pop(context);
            },
          ),
        ],
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
              child: new Text(noItem, style: noFav),
            ),
          ],
        ),
      ),
    );
  }
}
